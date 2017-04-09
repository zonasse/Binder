//
//  BTBookBrowser.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "BTBookBrowser.h"
#import "BTBook.h"
#import "BTChapter.h"
#import "uchardet.h"
#import "NSString+BTOverRange.h"
#import "BTBookBrowserTool.h"
#import "BookBrowser.h"
@interface BTBookBrowser ()<NSCoding>


@end

@implementation BTBookBrowser
{
    //书籍文件编码
    char bookEncode[20] ;
}
- (instancetype)initWithBook:(BTBook *)book
{
    if(self = [super init])
    {
        self.book = book;
    }
    
    return self;
}

- (void)setBook:(BTBook *)book
{
    _book = book;
        
    //创建CoreData文件
    BTBookBrowserTool *tool = [[BTBookBrowserTool alloc] init];
    [tool createCoreDataContent];
    
    NSString *bookFullName = [book.title stringByAppendingFormat:@".%@",book.suffix];
    NSError *error;
    
    //查询CoreData,看是否存储过
    //1.先查询bookBrowser
    NSFetchRequest *bookBrowserRequest = [NSFetchRequest fetchRequestWithEntityName:@"BookBrowser"];
    NSPredicate *bookBrowserPredicate = [NSPredicate predicateWithFormat:@"bookFullName like %@",bookFullName];
    bookBrowserRequest.predicate = bookBrowserPredicate;
    //1.2 执行请求,此处只有一个结果
    NSArray *resultBookBrowser = [[NSArray alloc] init];
    resultBookBrowser = [tool.managedContext executeFetchRequest:bookBrowserRequest error:&error];
    
    if(resultBookBrowser.count == 0)
    {
        //查询失败,开始解码
        NSLog(@"%@",[error localizedDescription]);
        /**
         *  初始化字符串文本处理
         */
        NSString *path = [downloadBookPath stringByAppendingPathComponent:bookFullName];
        
        int result = [self haveTextBianMa:[path UTF8String]];
        CFStringEncoding cfEncode = 0;
        if(result == 0)
        {
            NSString *encodeStr = [[NSString alloc] initWithCString:bookEncode encoding:NSUTF8StringEncoding];
            if ([encodeStr isEqualToString:@"GB18030"]) {
                
                cfEncode = kCFStringEncodingGB_18030_2000;
                
            }else if([encodeStr isEqualToString:@"Big5"]){
                
                cfEncode= kCFStringEncodingBig5;
                
            }else if([encodeStr isEqualToString:@"UTF-8"]){
                
                cfEncode= kCFStringEncodingUTF8;
                
            }else if([encodeStr isEqualToString:@"Shift_JIS"]){
                
                cfEncode= kCFStringEncodingShiftJIS;
                
            }else if([encodeStr isEqualToString:@"windows-1252"]){
                
                cfEncode= kCFStringEncodingWindowsLatin1;
                
            }else if([encodeStr isEqualToString:@"x-euc-tw"]){
                
                cfEncode= kCFStringEncodingEUC_TW;
                
            }else if([encodeStr isEqualToString:@"EUC-KR"]){
                
                cfEncode= kCFStringEncodingEUC_KR;
                
            }else if([encodeStr isEqualToString:@"EUC-JP"]){
                
                cfEncode= kCFStringEncodingEUC_JP;
                
            }
        }else if(result == 1){
            [MBProgressHUD showError:@"文件打开失败"];
        }else{
            [MBProgressHUD showError:@"文件解码失败"];
        }
        
        
        NSString *bookString=[NSString stringWithContentsOfFile:path encoding:CFStringConvertEncodingToNSStringEncoding(cfEncode) error:&error];
        __unsafe_unretained typeof(self) weakSelf =  self;
        [weakSelf extractNovelWithContent:bookString async:YES maintainEmptyCharcter:NO result:^(NSArray<BTChapter *> *models) {
            self.chapters = models;
            //写入CoreData
            [tool insertBrowserDataWithChapters:self.chapters currentPage:[NSNumber numberWithInt:self.currentPage]totalPages:[NSNumber numberWithInt:self.totalPages] bookFullName:bookFullName];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bookPreparedWorkFinished" object:nil];
        }];
        
        
    }else{
        //查询成功
        //取出browser相关数据
        for (BookBrowser *bookBrowser in resultBookBrowser) {

            //            NSData *coreData_chapters = [bookBrowser valueForKey:@"data_chapters"];
            NSArray *coreData_array_chapters =  [NSKeyedUnarchiver unarchiveObjectWithData: bookBrowser.data_chapters];
            
        }
    }

    
    
    
       
}

-(int)haveTextBianMa:(const char*)strTxtPath{
    
    FILE* file;
    char buf[2048];
    size_t len;
    uchardet_t ud;
    
    /* 打开被检测文本文件，并读取一定数量的样本字符 */
    
    file = fopen(strTxtPath, "rt");
    
    if (file==NULL) {
        
        printf("文件打开失败！\n");
        
        return 1;
        
    }
    
    len = fread(buf, sizeof(char), 2048, file);
    fclose(file);
    ud = uchardet_new();
    
    if(uchardet_handle_data(ud, buf, len) != 0)
    {
        printf("分析编码失败！\n");
        return -1;
    }
    uchardet_data_end(ud);
    printf("文本的编码方式是%s。\n", uchardet_get_charset(ud));
    
    strcpy(bookEncode, uchardet_get_charset(ud)) ;
    uchardet_delete(ud);
    return 0;
}
/**
 提取章节的NSRange信息
 
 @param content 文本内容
 @return `range字符串`数组
 */
- (NSArray<NSTextCheckingResult *> *)extractChapterListWithContent:(NSString *)content{
    
    NSString* regPattern = @"(\\s)+[第]{0,1}[0-9一二三四五六七八九十百千万]+[章回节卷集幕计][ \t]*(\\S)*";
    NSError* error = NULL;
    NSRegularExpression* regExp = [NSRegularExpression regularExpressionWithPattern:regPattern
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    
    return [regExp matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
}
/**
 根据 title Range 提取章节所需信息
 
 @param content 字符串内容
 @param maintainEmptyCharcter 是否保留空章节
 @return BTChapter数组
 */
- (NSArray<BTChapter *> *)analyseTxtWithContent:(NSString *)content
                          maintainEmptyCharcter:(BOOL)maintainEmptyCharcter{
    
    NSArray<NSTextCheckingResult *> *matchResult = [self extractChapterListWithContent:content];
    NSMutableArray *BTChapters = @[].mutableCopy ;
    
    if (matchResult.count == 0) {
        BTChapter *model = [BTChapter new] ;
        model.title = @"内容";
        model.contentRange = NSMakeRange(0, content.length);
        model.allContentRange = NSMakeRange(0, content.length);
        return @[model];
    }
    
    for (NSInteger i = 0; i < matchResult.count ; i++) {
        
        NSRange titleRange = matchResult[i].range;
        NSString *chapterTitle = [[content overRange_substringWithRange:titleRange] trimmed];
        NSLog(@"%@",chapterTitle);
        if (i == 0) { //第0章前
            
            NSString *firstTitle = @"开始";
            NSString *contentString = [content overRange_substringWithRange:NSMakeRange(0, titleRange.location)];
            if (contentString.trimmed.length > 0 ) {
                
                BTChapter *model2 = [BTChapter modelWithTitle:firstTitle
                                                   titleRange:NSMakeRange(0, 0)
                                              allContentRange:NSMakeRange(0, titleRange.location)];
                [BTChapters addObject:model2];
            }
        }
        
        if (i < matchResult.count-1) {
            
            NSRange nextRange = matchResult[i+1].range;
            if (nextRange.location > titleRange.location) {
                
                NSInteger length = nextRange.location - titleRange.location ;
                BTChapter *model2 = [BTChapter modelWithTitle:chapterTitle
                                                   titleRange:titleRange
                                              allContentRange:NSMakeRange(titleRange.location, length)];
                
                [self BTChapters:BTChapters addModel:model2 content:content maintainEmpty:maintainEmptyCharcter];
            }
        }
        
        if (i == matchResult.count-1){ //最后章节
            
            BTChapter *model2 = [BTChapter modelWithTitle:chapterTitle
                                               titleRange:titleRange
                                          allContentRange:NSMakeRange(titleRange.location,content.length -  titleRange.location)];
            [self BTChapters:BTChapters addModel:model2 content:content maintainEmpty:maintainEmptyCharcter];
        }
    }
    return [BTChapters copy];
}

- (void)BTChapters:(NSMutableArray *)BTChapters
          addModel:(BTChapter *)model
           content:(NSString *)content
     maintainEmpty:(BOOL)maintainEmptyCharcter{
    NSInteger contentLength = [[content overRange_substringWithRange:model.contentRange] trimmed].length;
    //保留空章节 或者 章节有内容
    if (maintainEmptyCharcter == YES || contentLength > 0) {
        [BTChapters addObject:model];
    }
}
/**
 提取章节信息
 
 @param content 文本内容
 @param isAsync 是否是异步
 @param isNeedMaintainEmptyCharcter 是否需要提取空的章节
 @param result 返回ChapterModel数组
 */
- (void)extractNovelWithContent:(NSString *)content
                          async:(BOOL)isAsync
          maintainEmptyCharcter:(BOOL)isNeedMaintainEmptyCharcter
                         result:(void(^)(NSArray<BTChapter *> *models))result {
    
    if (result == nil) {  return ;}
    
    if (isAsync) {
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            
            NSArray *models = [self analyseTxtWithContent:content maintainEmptyCharcter:isNeedMaintainEmptyCharcter];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                result(models);
            });
        });
        
    }else {
        result([self analyseTxtWithContent:content maintainEmptyCharcter:isNeedMaintainEmptyCharcter]);
    }
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.chapters forKey:@"chapters"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        
    }
    return self;
}
@end
