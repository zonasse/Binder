//
//  BTKindleAssistantViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/27.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTKindleAssistantViewController.h"
#import "BTBook.h"
#import "BTKindleBookCell.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "BTSearchViewController.h"
#import "BTBargainPriceBookViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "BTSearchHistoryViewController.h"


// 取得AppDelegate单例
#define ShareApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface BTKindleAssistantViewController ()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,BTSearchHistoryViewControllerDelegate>
@property (nonatomic,strong) UIDocumentInteractionController *documentInteration;
@property (nonatomic,strong) BTBook *currentBook;

@property (nonatomic,strong) BTSearchViewController *searchController;
@property (nonatomic,strong) BTSearchHistoryViewController *searchHistoryController;
@property (nonatomic,strong) NSMutableArray  *searchBooks;
@property (nonatomic,strong) NSMutableArray  *localBooks;

@property(nonatomic,strong) UILabel *footerView;

//书籍详细信息view


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
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:14.0];
    self.footerView = [[UILabel alloc] init];
    self.footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    [self.footerView setTextAlignment:NSTextAlignmentCenter];
    [self.footerView setTextColor:[UIColor lightGrayColor]];
    [self.footerView setFont:font];
    self.tableView.tableFooterView = self.footerView;
    
    //2.设置通知项
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendToKindle:) name:@"sendToKindle" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openDownloadedBookWithNotification:) name:@"openDownloadedBook" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBookDetailView:) name:@"showBookDetailView" object:nil];
    
    //3.加载本地书籍
    [self loadLocalBooks];
    
    //4.设置amazon每日特价推荐按钮
//    
//    UIButton *bargainPriceBookCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 81, 32)];
//    [bargainPriceBookCustomButton addTarget:self action:@selector(specialBookCommandButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [bargainPriceBookCustomButton setImage:[UIImage imageNamed:@"mood_buttonNormal_特价"] forState:UIControlStateNormal];
//    [bargainPriceBookCustomButton setImage:[UIImage imageNamed:@"mood_buttonActive_特价"] forState:UIControlStateHighlighted];
//    
//    UIBarButtonItem *bargainPriceBookButton = [[UIBarButtonItem alloc] initWithCustomView:bargainPriceBookCustomButton];
//
//    
//    self.navigationItem.rightBarButtonItem = bargainPriceBookButton;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cellBackground"] forBarMetrics:UIBarMetricsDefault];
//
    
        UIButton *bargainPriceBookCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 81, 32)];
        [bargainPriceBookCustomButton addTarget:self action:@selector(showLeftController) forControlEvents:UIControlEventTouchUpInside];
        [bargainPriceBookCustomButton setImage:[UIImage imageNamed:@"mood_buttonNormal_特价"] forState:UIControlStateNormal];
        [bargainPriceBookCustomButton setImage:[UIImage imageNamed:@"mood_buttonActive_特价"] forState:UIControlStateHighlighted];
    
        UIBarButtonItem *bargainPriceBookButton = [[UIBarButtonItem alloc] initWithCustomView:bargainPriceBookCustomButton];
    
    
        self.navigationItem.leftBarButtonItem = bargainPriceBookButton;
    
    
    
//    
//    NSMutableDictionary *textAttrNormal = [NSMutableDictionary dictionary];
//    textAttrNormal[NSForegroundColorAttributeName] = [UIColor blackColor ];
//    
//    NSMutableDictionary *textAttrSelected = [NSMutableDictionary dictionary];
//    textAttrSelected[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    UITabBarItem *homeTabBarItem = [self.tabBarController.tabBar.items objectAtIndex:0];
//    [homeTabBarItem setTitle:@"首页"];
//    
//    
//    [homeTabBarItem setTitleTextAttributes:textAttrNormal forState:UIControlStateNormal];
//    [homeTabBarItem setTitleTextAttributes:textAttrSelected forState:UIControlStateSelected];
//    [homeTabBarItem setImage:[[UIImage imageNamed:@"tabbar_home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [homeTabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    UITabBarItem *profileTabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
//    [profileTabBarItem setTitle:@"我"];
//    [profileTabBarItem setTitleTextAttributes:textAttrNormal forState:UIControlStateNormal];
//    [profileTabBarItem setTitleTextAttributes:textAttrSelected forState:UIControlStateSelected];
//
//    [profileTabBarItem setImage:[[UIImage imageNamed:@"tabbar_profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [profileTabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //5.设置搜索历史记录控制器
    self.searchHistoryController = [[BTSearchHistoryViewController alloc] initWithStyle:UITableViewStylePlain];
    self.searchHistoryController.tableView.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height);
    self.searchHistoryController.delegate = self;
    
    
 
}

- (void)showLeftController
{
    [ShareApp.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
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
    [self loadLocalBooks];
    
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
    BTKindleBookCell *cell = [BTKindleBookCell cellWithTableView:tableView andIdentifier:cellId];
    if (self.searchController.active) {
        BTBook *book = _searchBooks[indexPath.row];
        //设置cell数据
        cell.book = book;
    }else{
        
        BTBook *book = _localBooks[indexPath.row];
        //设置cell数据
        cell.book = book;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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
                
                
                NSString *baseImageURL =[NSString stringWithFormat:@"http://172.18.96.73:8888%@",book.cover];
                baseImageURL = [baseImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[SDImageCache sharedImageCache]removeImageForKey: baseImageURL fromDisk:YES withCompletion:^{
                    [self.localBooks removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [MBProgressHUD showSuccess:@"删除成功"];
                }];
                
            }
        };
    }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        NSFileManager *manager = [NSFileManager defaultManager];
        
        
        NSString *bookFullName = [_currentBook.title stringByAppendingFormat:@".%@",_currentBook.suffix];
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:bookFullName];
        
        
        if ([manager fileExistsAtPath:path]) {
            if([MFMailComposeViewController canSendMail])
            {
                Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
                if (!mailClass) {
                    //                    [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
                    return;
                }
                if (![mailClass canSendMail]) {
                    //                    [self alertWithMessage:@"用户没有设置邮件账户"];
                    return;
                }
                
                [mailComposeVC setSubject:@"推送到kindle"];
                
                NSString *userEmailAddress = [alertView textFieldAtIndex:0].text;
                //保存用户邮箱地址
                [[NSUserDefaults standardUserDefaults] setObject:userEmailAddress forKey:@"userEmailAddress"];
                //收件人
                NSArray *toRecipients = [NSArray arrayWithObject: userEmailAddress];
                [mailComposeVC setToRecipients:toRecipients];
                
                NSData *data = [NSData dataWithContentsOfFile:path];
                [mailComposeVC addAttachmentData:data mimeType:@"" fileName:bookFullName];
                [self presentViewController:mailComposeVC animated:YES completion:^{
                    
                }];
                
            }
        }
        
    }
}
/**
 *  搜索栏搜索文字改变时调用
 */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //监测网络
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                [MBProgressHUD showError:@"当前没有可用网络"];
                self.footerView.text = @"暂无搜索结果";
                return ;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;

        }
    }];
    
    
    //开始搜索
    //若搜索栏无文字则显示搜索历史记录
    if (searchController.searchBar.text.length == 0 && searchController.active == YES) {
        [self.view addSubview:self.searchHistoryController.view];
    }else{
        [self.searchHistoryController.view removeFromSuperview];
    }
    
    
    //1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    if (_searchBooks != nil) {
        [_searchBooks removeAllObjects];
        _searchBooks = [[NSMutableArray alloc] init];
    }else{
        _searchBooks = [[NSMutableArray alloc] init];
    }
    
    NSString *book = self.searchController.searchBar.text;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        //向私人服务器发送搜索请求
        
        [self searchBooksWithURLAddress:@"http://172.18.96.73:8888/www/BulletApi/searchBooks.php" params:@{@"book":book} manager:manager group:group];
    });
    //搜索结束
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.searchController.active == YES) {

            if (self.searchBooks.count == 0 ) {
            self.footerView.text = @"暂无搜索结果";
            }else{
            self.footerView.text = @"已无更多";
            }
        }
        [self.tableView reloadData];
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSArray *tempArray = [[NSArray alloc] init];
    //将搜索记录添加进搜索历史记录
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"]) {
         tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"];
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
            book.cover = [resultSet stringForColumn:@"bt_cover_path"];
            book.bookStatus = btBookStatusDownloaded;
            
            [self.localBooks addObject:book];
        }
    }
    [downloadBookDatabase close];
    if (_localBooks.count == 0) {
        //显示本地书籍列表为空
        self.footerView.text = @"本地列表为空";

    }
    NSArray *temp = (NSArray *)_localBooks;
    _searchBooks = [NSMutableArray arrayWithArray:temp];
    
    [self.tableView reloadData];
    
    
}
/**
 *  用户点击了sendToKindle按钮
 */
- (void)sendToKindle:(NSNotification *)notification
{
    self.currentBook = notification.object;
    NSString *userEmailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmailAddress"];
    //判断用户是否输入过邮箱地址
    if (userEmailAddress) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *bookFullName = [_currentBook.title stringByAppendingFormat:@".%@",_currentBook.suffix];
        NSString *path = [downloadBookPath stringByAppendingPathComponent:bookFullName];
        
        if ([manager fileExistsAtPath:path]) {
            if([MFMailComposeViewController canSendMail])
            {
                Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
                if (!mailClass) {
                    //                    [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
                    return;
                }
                if (![mailClass canSendMail]) {
                    //                    [self alertWithMessage:@"用户没有设置邮件账户"];
                    return;
                }
                
                [mailComposeVC setSubject:@"推送到kindle"];
                
                //收件人
                NSArray *toRecipients = [NSArray arrayWithObject: userEmailAddress];
                [mailComposeVC setToRecipients:toRecipients];
                
                NSData *data = [NSData dataWithContentsOfFile:path];
                [mailComposeVC addAttachmentData:data mimeType:@"" fileName:bookFullName];
                [self presentViewController:mailComposeVC animated:YES completion:^{
                }];
            }
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入默认kindle邮箱地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
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
//发送邮件
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissModalViewControllerAnimated:YES];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
}
/**
 *  搜索书籍
 */
- (void)searchBooksWithURLAddress:(NSString *)address params:(NSDictionary *)params manager:(AFHTTPSessionManager *)manager group:(dispatch_group_t)group
{
    __block NSError *error;
    
    dispatch_group_enter(group);
    
    [manager POST:address parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseBooksDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (responseBooksDict[@"error"] || !responseBooksDict) {
            dispatch_group_leave(group);
            return ;
        }else{
            
            NSArray *reponseBooksArray = responseBooksDict[@"books"];
            for (NSDictionary *bookDict in reponseBooksArray) {
                if ([bookDict isKindOfClass:[NSNull class]] ) {
                    continue;
                }
                BTBook *book = [[BTBook alloc] initWithDictionary:bookDict];
                [_searchBooks addObject:book];
            }
            
        }
        
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(group);
    }];
}

/**
 *  打开书籍特价菜单
 */
- (void)specialBookCommandButtonClicked
{
    
    BTBargainPriceBookViewController *specialBookAccountVC = [[BTBargainPriceBookViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:specialBookAccountVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];

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
