//
//  BTBookTagViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/5.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBookTagViewController.h"
#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"
#import "BTOpenDownloadedBookActionSheet.h"
@interface BTBookTagViewController ()<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong) UILabel *normalFooterView;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteration;

@property (nonatomic,strong)NSMutableArray *resultBooksArray;
//电子书打开提示框
@property (nonatomic,strong) BTOpenDownloadedBookActionSheet *actionSheet;
@property (nonatomic,strong) UIView *bookDetailViewCover;
@end

@implementation BTBookTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openDownloadedBookWithNotification:) name:@"openDownloadedBook" object:nil];
    //设置电子书打开时显示的alertView
    if (!_actionSheet) {
        
        
        _actionSheet = [[BTOpenDownloadedBookActionSheet alloc] initWithTitle:@"文件选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预览(txt,pdf)",@"其他应用", nil];
    }
    self.tableView.scrollsToTop = YES;
    if (_resultBooksArray) {
        [_resultBooksArray removeAllObjects];
        _resultBooksArray = [[NSMutableArray alloc] init];
        
    }else{
        _resultBooksArray = [[NSMutableArray alloc] init];
        
    }
    
    
    //用于刷新
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewBooks)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableView.mj_header = header;

  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultBooksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"bookCell";
    
    BTKindleBookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[BTKindleBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    BTBook *book = _resultBooksArray[indexPath.row];
    //设置cell数据
    cell.book = book;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
}

- (void)getMoreBooks
{
    
    [self searchBooks];
}

- (void)getNewBooks
{
    if (_resultBooksArray) {
        [_resultBooksArray removeAllObjects];
        _resultBooksArray = [[NSMutableArray alloc] init];
    }
    
    [self searchBooks];
    
    
    
}

- (void)searchBooks
{
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __block NSError *error;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //    [self searchBooksWithURLAddress:@"http://localhost:8888/www/BulletApi/searchBooks.php" params:@{@"book":book,@"bookRecord":[NSNumber numberWithInteger:_searchBooks.count]} ];http://15809m650x.iok.la/BinderApi/searchBookLibrary.php
    
        [manager POST:@"http://15809m650x.iok.la/BinderApi/searchBookLibrary.php" parameters:@{@"book":self.bookTag,@"bookRecord":[NSNumber numberWithInteger:_resultBooksArray.count]} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseBooksDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if (responseBooksDict[@"error"] ) {
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                    [self.tableView.mj_header endRefreshing];
                }
         
                
                
                if (self.tableView.mj_footer && self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
                    //没有更多结果
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];

                }else{
                    //没有搜索结果
                    self.tableView.tableFooterView = nil;
                    _normalFooterView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 34)];
                    _normalFooterView.textColor = [UIColor lightGrayColor];
                    self.tableView.tableFooterView = self.normalFooterView;
                    self.normalFooterView.text = @"暂无搜索结果";
                    self.normalFooterView.textAlignment = NSTextAlignmentCenter;
                }

                
            }else{
                
                NSArray *reponseBooksArray = responseBooksDict[@"books"];
                for (NSDictionary *bookDict in reponseBooksArray) {
                    if ([bookDict isKindOfClass:[NSNull class]] ) {
                        continue;
                    }
                    BTBook *book = [[BTBook alloc] initWithDictionary:bookDict];
                    [_resultBooksArray addObject:book];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                        [self.tableView.mj_header endRefreshing];
                    }
                    
                    if (self.tableView.mj_footer && self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
                        [self.tableView.mj_footer endRefreshing];
                    }else{
                        //上拉加载更多
                        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreBooks)];
                        // 设置文字
                        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
                        [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
                        [footer setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
                        
                        // 设置字体
                        footer.stateLabel.font = [UIFont systemFontOfSize:12];
                        
                        // 设置颜色
                        footer.stateLabel.textColor = [UIColor lightGrayColor];
                        
                        // 设置footer
                        self.tableView.mj_footer = footer;
                        
                        if (_resultBooksArray.count >0 && _resultBooksArray.count < 15) {
                            [footer endRefreshingWithNoMoreData];
                        }
                        
                    }
                    
                    [self.tableView reloadData];
                });
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self.tableView.mj_header && self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                [self.tableView.mj_header endRefreshing];

            }
            if(self.tableView.mj_footer && self.tableView.mj_footer.state == MJRefreshStateRefreshing)
            {
                [self.tableView.mj_footer endRefreshing];
            }
            //网络故障
            [MBProgressHUD showError:@"网络故障"];

        }];
        
    });
    

}

//打开已下载的书籍
- (void)openDownloadedBookWithNotification:(NSNotification *)notification
{
    
    BTBook *book = notification.object;
    _actionSheet.book = book;
    [_actionSheet showInView:self.view];
}


/**
 *  打开书籍ActionSheet的代理方法
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *bookFullName = [_actionSheet.book.title stringByAppendingFormat:@".%@",_actionSheet.book.suffix];
    NSString *path = [downloadBookPath stringByAppendingPathComponent:bookFullName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && _actionSheet.book.bookStatus == btBookStatusDownloaded) {
        _documentInteration = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
        _documentInteration.delegate = self;
        
    }
    switch (buttonIndex) {
   
        case 0:
        {
            //预览
            [_documentInteration presentPreviewAnimated:YES];
        }
            break;
        case 1:
        {
            //其他应用
            [_documentInteration presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
            
            
            
        }
            break;
            
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ==0?0.1f:8.0f;// 0.1f:防止tableView顶部留白一块
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section ==0?0.1f:8.0f;// 0.1f:防止tableView顶部留白一块
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //显示书籍详细信息
    BTBook *book = _resultBooksArray[indexPath.row];
    
    _bookDetailViewCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    _bookDetailViewCover.backgroundColor = [UIColor lightGrayColor];
    _bookDetailViewCover.alpha = 0.95;
    
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, UIScreenHeight * 0.2, UIScreenWidth - 20, 30) ];
    
    if ([book.category isEqualToString:@""]) {
        textView.text = @"  暂无书籍简介";
    }else{
        textView.text = book.category;
    }
    
    CGSize textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(textView.width, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    textView.height = textSize.height + 10;
    //    textView.y -= textSize.height;
    textView.editable = NO;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(60, UIScreenHeight - 64, UIScreenWidth - 120, 44)];
    closeButton.backgroundColor = [UIColor colorWithRed:237/256.0 green:215/256.0 blue:176/256.0 alpha:1.0];
    
    [closeButton setTitle:@"确定" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBookDetailViewCover) forControlEvents:UIControlEventTouchUpInside];
    
    [_bookDetailViewCover addSubview:textView];
    [_bookDetailViewCover addSubview:closeButton];
    
    [ShareApp.window addSubview:_bookDetailViewCover];
    
    
}
- (void)closeBookDetailViewCover
{
    [_bookDetailViewCover removeFromSuperview];
}

@end
