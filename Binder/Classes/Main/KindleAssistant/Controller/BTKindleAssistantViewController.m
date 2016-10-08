//
//  BTKindleAssistantViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/27.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTKindleAssistantViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "BTBookLibraryViewController.h"

@interface BTKindleAssistantViewController ()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,BTSearchHistoryViewControllerDelegate>

@property (nonatomic,strong) UIDocumentInteractionController *documentInteration;
@property (nonatomic,strong) BTSearchViewController *searchController;
@property (nonatomic,strong) BTSearchHistoryViewController *searchHistoryController;
@property (nonatomic,strong) NSMutableArray  *searchBooks;
@property (nonatomic,strong) NSMutableArray  *localBooks;
@property (nonatomic,strong) UILabel *normalFooterView;
@property(nonatomic,strong) UILabel *loadMoreFooterView;
//搜索进程指示器
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;


@end

@implementation BTKindleAssistantViewController
#pragma mark -- 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"kindle助手";
    
    //1.设置搜索控制器
    self.searchController = [[BTSearchViewController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44);

    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //2.设置通知项
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openDownloadedBookWithNotification:) name:@"openDownloadedBook" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBookDetailView:) name:@"showBookDetailView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(findInAmazon:) name:@"findInAmazon" object:nil];
   
    
    //3.设置导航栏左侧按钮

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cellBackground"] forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton *toggleToLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [toggleToLeft addTarget:self action:@selector(showLeftController) forControlEvents:UIControlEventTouchUpInside];
    [toggleToLeft setImage:[UIImage imageNamed:@"left_navItem_normal"] forState:UIControlStateNormal];
    [toggleToLeft setImage:[UIImage imageNamed:@"left_navItem_highlited"] forState:UIControlStateHighlighted];
    UIBarButtonItem *toggleToLeftButton = [[UIBarButtonItem alloc] initWithCustomView:toggleToLeft];
    self.navigationItem.leftBarButtonItem = toggleToLeftButton;
    
    //4.设置导航栏右侧按钮
    UIButton *toggleToRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [toggleToRight addTarget:self action:@selector(showBooksTag) forControlEvents:UIControlEventTouchUpInside];
    [toggleToRight setImage:[UIImage imageNamed:@"right_navItem_normal"] forState:UIControlStateNormal];
    [toggleToRight setImage:[UIImage imageNamed:@"right_navItem_highlited"] forState:UIControlStateHighlighted];

    
    UIBarButtonItem *toggleToRightButton = [[UIBarButtonItem alloc] initWithCustomView:toggleToRight];
    self.navigationItem.rightBarButtonItem = toggleToRightButton;

    //5.设置搜索历史记录控制器
    self.searchHistoryController = [[BTSearchHistoryViewController alloc] initWithStyle:UITableViewStylePlain];
    self.searchHistoryController.tableView.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height);
    self.searchHistoryController.delegate = self;
    
  
    _indicatorView = [[UIActivityIndicatorView alloc] init];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _indicatorView.center = CGPointMake(UIScreenWidth * 0.5, 60);
    _indicatorView.width = 60;
    _indicatorView.height = 60;
    _indicatorView.hidesWhenStopped = YES;
    // 6.创建footerView
    if (self.searchController.active == NO) {

        //正常
        self.tableView.tableFooterView = nil;
        UIFont *font = [UIFont fontWithName:@"Marker Felt" size:14.0];
        self.normalFooterView = [[UILabel alloc] init];
        self.normalFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34);
        [self.normalFooterView setTextAlignment:NSTextAlignmentCenter];
        [self.normalFooterView setTextColor:[UIColor lightGrayColor]];
        [self.normalFooterView setFont:font];
        self.tableView.tableFooterView = self.normalFooterView;
    }
    
    //7.加载本地书籍
    [self loadLocalBooks];
}


- (void)findInAmazon:(NSNotification *)notification
{
    BTBook *book = notification.object;
    NSString *amazonURL= @"https://www.amazon.cn/s/ref=nb_sb_noss_2?__mk_zh_CN=%E4%BA%9A%E9%A9%AC%E9%80%8A%E7%BD%91%E7%AB%99&url=search-alias%3Daps&field-keywords=";
    amazonURL = [amazonURL stringByAppendingString:book.title];
    
    BTBaseWebViewController *baseWebViewVC = [[BTBaseWebViewController alloc] init];
    [baseWebViewVC loadWithURLString:amazonURL title:book.title isRequest:YES];
    [self presentViewController:baseWebViewVC animated:YES completion:^{
        
    }];
    
}

// 弹出左侧控制器
- (void)showLeftController
{
    [ShareApp.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}
//弹出书籍分类控制器
- (void)showBooksTag
{

    BTBookLibraryViewController *bookLibraryVC = [[BTBookLibraryViewController alloc] init];
    UINavigationController *bookLibraryNAV = [[UINavigationController alloc ]initWithRootViewController:bookLibraryVC];
    
    
    [self presentViewController:bookLibraryNAV animated:YES completion:^{
        
    }];
    
    
    
}

- (void)applicationBecomeActive
{
    //加载本地书籍
    [self loadLocalBooks];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 系统代理方法
/**
 *  点击了搜索取消按钮
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //此时searchController.active仍为yes
    [_indicatorView stopAnimating];
    self.searchController.active = NO;
    if (!self.searchController.active) {
    [self loadLocalBooks];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"searchStopped" object:nil];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return _searchBooks.count;
    }else{
        return _localBooks.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"bookCell";
    
    BTKindleBookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[BTKindleBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }

        if (self.searchController.active) {
            cell.rowNumber = indexPath.row + 1;
            BTBook *book = _searchBooks[indexPath.row];
            //设置cell数据
            cell.book = book;
            
        }else{
            cell.rowNumber = 0;
            BTBook *book = _localBooks[indexPath.row];
            //设置cell数据
            cell.book = book;
           
        }

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) {
        return NO;
    }else{
        return YES;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.searchController.active ) {

    BTBook *book = _localBooks[indexPath.row];
    
    //本地数据库删除行，本地文件删除
    FMDatabase *db = [FMDatabase databaseWithPath:[downloadBookPath stringByAppendingPathComponent:@"downloadBook.db"]];
    if ([db open]) {
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM bt_book WHERE bt_bookId = '%@'",book.bookId];
        if ([db executeUpdate:deleteQuery]) {
            //删除本地文件和图片缓存
            if ([[NSFileManager defaultManager] fileExistsAtPath:[downloadBookPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",book.title,book.suffix]]]) {
                [[NSFileManager defaultManager] removeItemAtPath:[downloadBookPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",book.title,book.suffix]] error:nil];
                
                
                NSString *baseImageURL =[NSString stringWithFormat:@"http://15809m650x.iok.la%@",book.cover];
                baseImageURL = [baseImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[SDImageCache sharedImageCache]removeImageForKey: baseImageURL fromDisk:YES withCompletion:^{
                    [self.localBooks removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [MBProgressHUD showSuccess:@"删除成功"];
                    if (self.localBooks.count == 0) {
                        self.normalFooterView.text = @"本地列表为空";
                    }
                }];
                
            }else{
                [self.localBooks removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [MBProgressHUD showSuccess:@"删除成功"];
                 if (self.localBooks.count == 0) {
                self.normalFooterView.text = @"本地列表为空";
                 }
            }
        };
    }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    if (self.searchController.active == YES && _loadMoreFooterView) {
        
    
    // 下拉到最底部时显示更多数据
        // 1.差距
        CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
        // 刚好能完整看到footer的高度
        CGFloat sawFooterH = self.view.height - self.loadMoreFooterView.height;
        
        // 2.如果能看见整个footer
        if (delta <= (sawFooterH - 0)) {
            [self getMoreBooks];
        
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section ==0?0.1f:8.0f;// 0.1f:防止tableView顶部留白一块
}

/**
 *  搜索栏搜索文字改变时调用
 */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    
    self.normalFooterView.text = @"";
    //监测网络
    if (kNetworkNotReachability) {
        [MBProgressHUD showError:@"当前没有可用网络"];
        self.normalFooterView.text = @"暂无搜索结果";
        return ;
    }
    

    //开始搜索
    //若搜索栏无文字则显示搜索历史记录
    if (searchController.searchBar.text.length == 0 && searchController.active == YES) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"searchStart" object:nil];
        [self.view addSubview:self.searchHistoryController.view];
        [self.tableView reloadData];
        return;
        
    }else{
        [self.searchHistoryController.view removeFromSuperview];
    }
    
    //显示搜索进程指示器
    if (self.searchController.active) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"searchStart" object:nil];

        [_indicatorView startAnimating];
        
        [self.view addSubview:_indicatorView];
    }
   
    
    //1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    if (_searchBooks != nil) {
        [_searchBooks removeAllObjects];
        _searchBooks = [[NSMutableArray alloc] init];
        [self.tableView reloadData];
    }else{
        _searchBooks = [[NSMutableArray alloc] init];
    }
    
    NSString *book = self.searchController.searchBar.text;
 
        //向私人服务器发送搜索请求
        
                [self searchBooksWithURLAddress:@"http://15809m650x.iok.la/BinderApi/searchBooks.php" params:@{@"book":book,@"bookRecord":[NSNumber numberWithInteger:_searchBooks.count]} ];
//        [self searchBooksWithURLAddress:@"http://localhost:8888/www/BulletApi/searchBooks.php" params:@{@"book":book,@"bookRecord":[NSNumber numberWithInteger:_searchBooks.count]} ];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSArray *tempArray = [[NSArray alloc] init];
    //将搜索记录添加进搜索历史记录
    
    __block BOOL historyExist = NO;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"]) {
         tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"];
        
        [tempArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:searchBar.text]) {
                historyExist = YES;
            }
        }];
    }
    
    if (historyExist) {
        return;
    }
    
    
    self.searchHistoryController.searchHistoryArray = [NSMutableArray arrayWithArray:tempArray];
    [self.searchHistoryController.searchHistoryArray addObject:searchBar.text];
    [self.searchHistoryController.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryController.searchHistoryArray forKey:@"searchHistoryArray"];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchController.view endEditing:YES];
}
#pragma mark - 自定义方法

/**
 *  加载本地文件
 */
- (void)loadLocalBooks
{
    
    if (self.localBooks != nil) {
        [self.localBooks removeAllObjects];
        _localBooks = [[NSMutableArray alloc] init];
    }else{
        _localBooks = [[NSMutableArray alloc] init];
    }
    //设置headerView
    //从本地数据库读取
    FMDatabase *downloadBookDatabase = [FMDatabase databaseWithPath:[downloadBookPath stringByAppendingPathComponent:@"downloadBook.db"]];
    if ([downloadBookDatabase open]) {
        NSString *sqlString = @"SELECT * FROM bt_book";
        FMResultSet *resultSet = [downloadBookDatabase executeQuery:sqlString];
        while ([resultSet next]) {
            BTBook *book = [[BTBook alloc] init];
            
            book.bookId = [resultSet stringForColumn:@"bt_bookId"];
            book.title = [resultSet stringForColumn:@"bt_title"];
            book.suffix = [resultSet stringForColumn:@"bt_suffix"];
            book.author =  [resultSet stringForColumn:@"bt_author"];
            book.category = [resultSet stringForColumn:@"bt_category"];
            book.publisher = [resultSet stringForColumn:@"bt_publisher"];
            book.publishTime = [resultSet stringForColumn:@"bt_publish_time"];
            book.size = [resultSet stringForColumn:@"bt_size"];
            book.path = [resultSet stringForColumn:@"bt_path"];
            book.cover = [resultSet stringForColumn:@"bt_cover_path"];
            book.bookStatus = btBookStatusDownloaded;
            book.tag = [resultSet stringForColumn:@"bt_tag"];
            book.rating = [resultSet stringForColumn:@"bt_rating"];
            [self.localBooks addObject:book];
        }
    }
    [downloadBookDatabase close];
    self.tableView.tableFooterView = nil;
    if (self.loadMoreFooterView) {
        self.loadMoreFooterView = nil;
    }
    self.tableView.tableFooterView = _normalFooterView;
    if (_localBooks.count == 0) {
        //显示本地书籍列表为空
        
        self.normalFooterView.text = @"本地列表为空";

    }else{
        self.normalFooterView.text = @"";
    }
         [self.tableView reloadData];

    
}

/**
 *  打开已下载的书籍
 */
- (void)openDownloadedBook:(BTBook *)book
{
    NSString *bookFullName = [book.title stringByAppendingFormat:@".%@",book.suffix];
    NSString *path = [downloadBookPath stringByAppendingPathComponent:bookFullName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path] && book.bookStatus == btBookStatusDownloaded) {
        _documentInteration = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
        _documentInteration.delegate = self;
        [_documentInteration presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
    }
    
}

/**
 *  搜索书籍
 */
- (void)searchBooksWithURLAddress:(NSString *)address params:(NSDictionary *)params
{
    __block NSError *error;
    //1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_async(queue, ^{
    
        [manager POST:address parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseBooksDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (responseBooksDict[@"error"] ) {
            if(_loadMoreFooterView)
            {
                [_loadMoreFooterView setText:@"已无更多"];
            }
        }else{
            
            NSArray *reponseBooksArray = responseBooksDict[@"books"];
            for (NSDictionary *bookDict in reponseBooksArray) {
                if ([bookDict isKindOfClass:[NSNull class]] ) {
                    continue;
                }
                BTBook *book = [[BTBook alloc] initWithDictionary:bookDict];
                [_searchBooks addObject:book];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.searchController.active == YES) {
                    
                    if (self.searchBooks.count > 0 ) {
                        
                        //上拉加载更多
                        self.tableView.tableFooterView = nil;
                        
                        _loadMoreFooterView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 34.0f)];
                        _loadMoreFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
                        [_loadMoreFooterView setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
                        [_loadMoreFooterView setTextAlignment:NSTextAlignmentCenter];
                        [_loadMoreFooterView setText:@"上拉显示更多"];
                        
                        self.tableView.tableFooterView = _loadMoreFooterView;
                        
                    }else{
                        
                        self.normalFooterView.text = @"暂无搜索结果";
                    }
                }
                [_indicatorView stopAnimating];
                [self.tableView reloadData];
                
                
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    });
    
   
    
}
- (void)getMoreBooks
{
  
    NSString *book = self.searchController.searchBar.text;

    //向私人服务器发送搜索请求
        
            [self searchBooksWithURLAddress:@"http://15809m650x.iok.la/BinderApi/searchBooks.php" params:@{@"book":book,@"bookRecord":[NSNumber numberWithInteger:_searchBooks.count]} ];
//    [self searchBooksWithURLAddress:@"http://localhost:8888/www/BulletApi/searchBooks.php" params:@{@"book":book,@"bookRecord":[NSNumber numberWithInteger:_searchBooks.count]} ];

}

/**
 *  点击了搜索历史记录cell
 */
- (void)searchHistoryCellDidClicked:(NSString *)cellText
{
    self.searchController.searchBar.text = cellText;
}


#pragma mark - 通知方法
//打开已下载的书籍
- (void)openDownloadedBookWithNotification:(NSNotification *)notification
{
    BTBook *book = notification.object;
    [self openDownloadedBook:book];
}

//显示书籍详细信息
- (void)showBookDetailView:(NSNotification *)notification
{
    BTBook *book = notification.object;
    
}

@end
