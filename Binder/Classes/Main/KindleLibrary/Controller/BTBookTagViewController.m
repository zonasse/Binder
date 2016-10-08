//
//  BTBookTagViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/5.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBookTagViewController.h"
@interface BTBookTagViewController ()
@property (nonatomic,strong) UILabel *normalFooterView;
@property(nonatomic,strong) UILabel *loadMoreFooterView;
@property (nonatomic,strong)NSMutableArray *resultBooksArray;
//搜索进程指示器
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@end

@implementation BTBookTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationItem.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewScrollToTop)]];
    
    _indicatorView = [[UIActivityIndicatorView alloc] init];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _indicatorView.center = CGPointMake(UIScreenWidth * 0.5, 60);
    _indicatorView.width = 60;
    _indicatorView.height = 60;
    _indicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_indicatorView];
    [_indicatorView startAnimating];
    
    //正常
    self.tableView.tableFooterView = nil;
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:14.0];
    self.normalFooterView = [[UILabel alloc] init];
    self.normalFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34);
    [self.normalFooterView setTextAlignment:NSTextAlignmentCenter];
    [self.normalFooterView setTextColor:[UIColor lightGrayColor]];
    [self.normalFooterView setFont:font];
    
    self.tableView.scrollsToTop = YES;
    if (_resultBooksArray) {
        [_resultBooksArray removeAllObjects];
        _resultBooksArray = [[NSMutableArray alloc] init];

    }else{
        _resultBooksArray = [[NSMutableArray alloc] init];

    }

    [self searchBooks];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    if ( _loadMoreFooterView) {
        
        
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

- (void)getMoreBooks
{
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
        
        [manager POST:@"http://http://15809m650x.iok.la/BinderApi/searchBookLibrary.php" parameters:@{@"bookTag":self.bookTag,@"bookRecord":[NSNumber numberWithInteger:_resultBooksArray.count]} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseBooksDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if (responseBooksDict[@"error"] ) {
                if (_loadMoreFooterView) {
                    //已无更多
                    [_loadMoreFooterView setText:@"已无更多"];
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
                    [_indicatorView stopAnimating];

                    if (self.resultBooksArray.count > 0 ) {
                        
                        //上拉加载更多
                        self.tableView.tableFooterView = nil;
                        
                        _loadMoreFooterView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 34.0f)];
                        _loadMoreFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
                        [_loadMoreFooterView setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
                        [_loadMoreFooterView setTextAlignment:NSTextAlignmentCenter];
                        [_loadMoreFooterView setText:@"上拉显示更多"];
                        
                        self.tableView.tableFooterView = _loadMoreFooterView;
                        
                    }else{
                        self.tableView.tableFooterView = nil;
                        self.tableView.tableFooterView = self.normalFooterView;
                        self.normalFooterView.text = @"暂无搜索结果";
                    }
                    
                    [self.tableView reloadData];
                    
                });
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    });
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section ==0?0.1f:8.0f;// 0.1f:防止tableView顶部留白一块
}
@end
