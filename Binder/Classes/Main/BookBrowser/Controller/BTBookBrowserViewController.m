//
//  BTBookBrowserViewController.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "BTBookBrowserViewController.h"
#import "BTBookBrowserTool.h"
#import "BookBrowser.h"
#import "Chapter.h"

#define MAX_LIMIT_NUMS 100

@interface  BTBookBrowserViewController()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong) UITextView *contentTextView;
//@property (nonatomic,strong) UILabel *pageInfoLabel;
//@property (nonatomic,strong) UISlider *pageSlider;
//@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UITableView *chapterListTableView;
@property (nonatomic,strong) UIFont *textFont;


@property (nonatomic,assign) BOOL isReading;
@property (nonatomic,assign) BOOL isChoosingChapter;


@end

@implementation BTBookBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isReading = YES;
    _isChoosingChapter = NO;
    
    //初始化视图
    //顶部导航条
    
    UIBarButtonItem *chapterItem = [[UIBarButtonItem alloc] initWithTitle:@"章节" style:UIBarButtonItemStylePlain target:self action:@selector(displayChapters)];
    
    UIBarButtonItem *decreaseFontSizeButton = [[UIBarButtonItem alloc] initWithTitle:@"a" style:UIBarButtonItemStylePlain target:self action:@selector(decreaseFontSize)];
    UIBarButtonItem *increaseFontSizeButton = [[UIBarButtonItem alloc] initWithTitle:@"A" style:UIBarButtonItemStylePlain target:self action:@selector(increaseFontSize)];
    
    [self.navigationItem setLeftBarButtonItems:@[chapterItem,decreaseFontSizeButton,increaseFontSizeButton]];
    self.title = self.book.title;
    
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBack)];
    
    //    self.navigationItem.leftBarButtonItem = chapterItem;
    self.navigationItem.rightBarButtonItem = closeItem;
    //底部工具条
    //    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-84, UIScreenWidth, 84)];
    //    bottomView.backgroundColor = [UIColor blackColor];
    //    bottomView.alpha = 0.5;
    //    _bottomView = bottomView;
    //    
    //    UILabel *pageInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.5*(UIScreenWidth - 80), 0, 80, 20)];
    //    pageInfoLabel.text = @"300/883";
    //    pageInfoLabel.backgroundColor = [UIColor redColor];
    //    _pageInfoLabel = pageInfoLabel;
    //    
    //    UISlider *pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageInfoLabel.frame)+5, UIScreenWidth, 15)];
    //    pageSlider.maximumValue = 1.0;
    //    pageSlider.minimumValue = 0.0;
    //    pageSlider.value = 0.5;
    //    _pageSlider = pageSlider;
    //    
    //    [bottomView addSubview:pageInfoLabel];
    //    [bottomView addSubview:pageSlider];
    
    
    
    //初始化章节列表视图
    self.chapterListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UIScreenWidth  , UIScreenHeight * 0.5) style:UITableViewStylePlain];
    NSLog(@"%f",CGRectGetMaxY(self.navigationController.navigationBar.frame));
    self.chapterListTableView.alpha = 0.8;
    self.chapterListTableView.delegate = self;
    self.chapterListTableView.dataSource = self;
}

- (void)setBook:(BTBook *)book
{
    _book = book;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadVCData:) name:@"bookPreparedWorkFinished" object:nil];
    //1.检查CoreData,是否已解析过
    self.tool = [[BTBookBrowserTool alloc] init];
    [self.tool checkLocalCoreDataWithBookFullName:[NSString stringWithFormat:@"%@.%@",book.title,book.suffix]];
    
}

- (void)reloadVCData:(NSNotification *)notification
{
    
    self.browser = notification.object;
    if(!self.chapters)
    {
        self.chapters = [[NSArray alloc] init];
    }
    self.chapters = [NSKeyedUnarchiver unarchiveObjectWithData:self.browser.chapters];
    
    //文字TextView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+20, UIScreenWidth, UIScreenHeight - self.navigationController.navigationBar.height)];
    textView.textAlignment = NSTextAlignmentLeft;
    
    UIFont *textFont = [UIFont fontWithName:@"Zapfino" size:self.browser.fontSize.floatValue];
    textView.font = textFont;
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor brownColor];
    textView.editable = NO;
    textView.delegate = self;
    self.textFont = textFont;
    self.contentTextView = textView;
    [self.contentTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeChapterList)]];
    [self.view addSubview:self.contentTextView];
    
    Chapter *chapter = [self.chapters objectAtIndex:self.browser.currentChapterIndex.intValue];
    self.contentTextView.text = [self.browser.bookContentString substringWithRange:chapter.allContentRange];
}

- (void)displayChapters
{
    if(!_isChoosingChapter)
    {
        [self.view addSubview:_chapterListTableView];
        [self.chapterListTableView reloadData];
        
    }else{
        [self.chapterListTableView removeFromSuperview];
    }
    _isChoosingChapter = !_isChoosingChapter;
    
}
- (void)closeChapterList
{
    if(_isChoosingChapter)
    {
        [self.chapterListTableView removeFromSuperview];
        _isChoosingChapter = !_isChoosingChapter;
    }
}
- (void)decreaseFontSize
{
    CGFloat pointSize = self.textFont.pointSize;
    
    self.contentTextView.font = [UIFont fontWithName:@"Zapfino" size: --pointSize];
    self.textFont = [UIFont fontWithName:@"Zapfino" size: pointSize];
}
- (void)increaseFontSize
{
    CGFloat pointSize = self.textFont.pointSize;
    
    self.contentTextView.font = [UIFont fontWithName:@"Zapfino" size: ++pointSize];
    self.textFont = [UIFont fontWithName:@"Zapfino" size: pointSize];
}
- (void)closeBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        //保存数据到持久层
        [self.tool modifyDataWithBookFullName:self.browser.bookFullName currentChapterIndex:self.browser.currentChapterIndex fontSize:[NSNumber numberWithFloat:self.textFont.pointSize]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chapters.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"chapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Chapter *chapter = self.chapters[indexPath.row];
    cell.textLabel.text = chapter.title;
    if(self.browser.currentChapterIndex.integerValue == indexPath.row)
    {
        cell.textLabel.textColor = [UIColor brownColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Chapter *chapter = [self.chapters objectAtIndex:indexPath.row];
    self.browser.currentChapterIndex = [NSNumber numberWithInteger:indexPath.row];
    self.contentTextView.text = [self.browser.bookContentString substringWithRange:chapter.allContentRange];
    [self.chapterListTableView removeFromSuperview];
    self.isChoosingChapter = !self.isChoosingChapter;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point = [[touches anyObject]locationInView:self.view];
    NSLog(@"%f",CGRectGetMaxY(self.chapterListTableView.frame));
    if( CGRectContainsPoint(CGRectMake(0,CGRectGetMaxY(self.chapterListTableView.frame),UIScreenWidth,UIScreenHeight - CGRectGetMaxY(self.chapterListTableView.frame)), point) )
    {
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(220, MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    textView.frame = frame;
    
    //    CGRect lableFrame = self.pageInfoLabel.frame;
    //    lableFrame.origin.y = frame.origin.y + frame.size.height + 2;
    //    self.pageInfoLabel.frame = lableFrame;
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了（即，在输入还未确定的时候不计算）
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //不让显示负数
    //        self.pageInfoLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.contentTextView resignFirstResponder];
        return NO;
    }else{
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
            
            if (offsetRange.location < MAX_LIMIT_NUMS) {
                return YES;
            }else{
                return NO;
            }
        }
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
        if (caninputlen >= 0)
        {
            return YES;
        }else{
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = @"";
                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                if (asc) {
                    s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                }else{
                    __block NSInteger idx = 0;
                    __block NSString  *trimString = @"";//截取出的字串
                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                              if (idx >= rg.length) {
                                                  *stop = YES; //取出所需要就break，提高效率
                                                  return ;
                                              }
                                              trimString = [trimString stringByAppendingString:substring];
                                              idx++;
                                          }];
                    s = trimString;
                }
                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
                //既然是超出部分截取了，哪一定是最大限制了。
                //                self.pageInfoLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
            }
            return NO;
        }
    }
}
@end
