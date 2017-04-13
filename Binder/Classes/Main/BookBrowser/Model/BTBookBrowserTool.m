//
//  BTBookBrowserTool.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "BTBookBrowserTool.h"
#import "BookBrowser.h"
#import "Chapter.h"
#import "uchardet.h"
#import "NSString+BTOverRange.h"

@implementation BTBookBrowserTool

#pragma mark -- 文件解码

{
    //书籍文件编码
    char bookEncode[20] ;
}


- (void)checkLocalCoreDataWithBookFullName:(NSString *)bookFullName
{
    //创建CoreData文件句柄
    [self createCoreDataContent];
    NSError *error;
    
    //查询CoreData,看是否存储过
    //1.先查询bookBrowser
    NSFetchRequest *bookBrowserRequest = [NSFetchRequest fetchRequestWithEntityName:@"BookBrowser"];
    NSPredicate *bookBrowserPredicate = [NSPredicate predicateWithFormat:@"bookFullName like %@",bookFullName];
    bookBrowserRequest.predicate = bookBrowserPredicate;
    //1.2 执行请求,此处只有一个结果
    NSArray *resultBookBrowser = [[NSArray alloc] init];
    resultBookBrowser = [self.managedContext executeFetchRequest:bookBrowserRequest error:&error];
    
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
        [weakSelf extractNovelWithContent:bookString async:YES maintainEmptyCharcter:NO result:^(NSArray<Chapter *> *models) {
            //写入CoreData
            NSLog(@"插入数据");
            //创建模型数据模型
            
            BookBrowser *bookBrowser = [NSEntityDescription insertNewObjectForEntityForName:@"BookBrowser" inManagedObjectContext:self.managedContext];
            bookBrowser.chapters = [NSKeyedArchiver archivedDataWithRootObject:models];
            bookBrowser.currentChapterIndex = [NSNumber numberWithInt:0];
            bookBrowser.bookFullName = bookFullName;
            bookBrowser.fontSize = [NSNumber numberWithFloat:14.0];
            bookBrowser.bookContentString = bookString;
            
            //保存,用 save 方法
            NSError *error = nil;
            BOOL success = [self.managedContext save:&error];
            if (!success) {
                [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
            }

            //发出通知并返回bookBrowser
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bookPreparedWorkFinished" object:bookBrowser];
        }];
        
        
    }else{
        //查询成功
        //取出browser相关数据
        for (BookBrowser *bookBrowser in resultBookBrowser) {
            //发出通知并返回bookBrowser
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bookPreparedWorkFinished" object:bookBrowser];


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
    
    NSString* regPattern = @"(\\s)+[第]{0,1}[0-9一二三四五六七八九十百千万]+[章回节卷集幕计].*";

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
 @return Chapter数组
 */
- (NSArray<Chapter *> *)analyseTxtWithContent:(NSString *)content
                          maintainEmptyCharcter:(BOOL)maintainEmptyCharcter{
    
    NSArray<NSTextCheckingResult *> *matchResult = [self extractChapterListWithContent:content];
    NSMutableArray *Chapters = @[].mutableCopy ;
    
    if (matchResult.count == 0) {
        Chapter *model = [Chapter modelWithTitle:@"内容" titleRange:NSMakeRange(0, content.length) allContentRange:NSMakeRange(0, content.length)] ;
        
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
                
                Chapter *model2 = [Chapter modelWithTitle:firstTitle
                                                   titleRange:NSMakeRange(0, 0)
                                              allContentRange:NSMakeRange(0, titleRange.location)];
                [Chapters addObject:model2];
            }
        }
        
        if (i < matchResult.count-1) {
            
            NSRange nextRange = matchResult[i+1].range;
            if (nextRange.location > titleRange.location) {
                
                NSInteger length = nextRange.location - titleRange.location ;
                Chapter *model2 = [Chapter modelWithTitle:chapterTitle
                                                   titleRange:titleRange
                                              allContentRange:NSMakeRange(titleRange.location, length)];
                
                [self Chapters:Chapters addModel:model2 content:content maintainEmpty:maintainEmptyCharcter];
            }
        }
        
        if (i == matchResult.count-1){ //最后章节
            
            Chapter *model2 = [Chapter modelWithTitle:chapterTitle
                                               titleRange:titleRange
                                          allContentRange:NSMakeRange(titleRange.location,content.length -  titleRange.location)];
            [self Chapters:Chapters addModel:model2 content:content maintainEmpty:maintainEmptyCharcter];
        }
    }
    return [Chapters copy];
}

- (void)Chapters:(NSMutableArray *)Chapters
          addModel:(Chapter *)model
           content:(NSString *)content
     maintainEmpty:(BOOL)maintainEmptyCharcter{
    
    NSInteger contentLength = [[content overRange_substringWithRange:model.contentRange] trimmed].length;
    //保留空章节 或者 章节有内容
    if (maintainEmptyCharcter == YES || contentLength > 0) {
        [Chapters addObject:model];
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
                         result:(void(^)(NSArray<Chapter *> *models))result {
    
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


#pragma mark -- CoreData相关操作
/**
 *  coreData操作-增(插入)
 */
- (void)createCoreDataContent{
    
    //documet目录下
    NSString *doc  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"/bookBrowser.db"];//注意不是:stringByAppendingString
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSLog(@"-----------------------------------");
    NSLog(@"data : %@",path);
    
    //创建文件,并且打开数据库文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //给存储器指定存储的类型
    NSError *error;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"添加数据库错误" format:@"%@",[error localizedDescription]];
    }
        //创建图形上下文
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        context.persistentStoreCoordinator = psc;
        self.managedContext = context;
}


/**
 *  coreData操作-改(更新)
 */


//更新数据
- (void)modifyDataWithBookFullName:(NSString *)bookFullName currentChapterIndex:(NSNumber* )currentChapterIndex fontSize:(NSNumber *)fontSize{
    // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
    //先从数据库中取出所有的数据,然后从其中选出要修改的那个,进行修改,然后保存
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookBrowser"];
    
    //设置过滤条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"bookFullName = %@",bookFullName];
    request.predicate = pre;
    
    NSError *error = nil;
    NSArray *objs = [self.managedContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    
    // 2.更新身高
    for (BookBrowser *browser in objs) {
        browser.currentChapterIndex = currentChapterIndex;
        browser.fontSize = fontSize;
    }
    
    //保存,用 save 方法
    BOOL success = [self.managedContext save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
    }
    
}
/**
 *  coreData操作-删
 */

//删除
- (void)removeDataWithBookFullName:(NSString *)bookFullName{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookBrowser"];
    
    //查到到你要删除的数据库中的对象
    NSPredicate *predic = [NSPredicate predicateWithFormat:@"bookFullName = %@",bookFullName];
    request.predicate = predic;
    
    //请求数据
    NSArray *objs = [self.managedContext executeFetchRequest:request error:nil];
    
    for (BookBrowser *browser in objs) {
        [self.managedContext deleteObject:browser];
    }
    
    [self.managedContext save:nil];
}

@end
