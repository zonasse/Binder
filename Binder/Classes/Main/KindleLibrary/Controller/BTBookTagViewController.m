//
//  BTBookTagViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/5.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBookTagViewController.h"
@interface BTBookTagViewController ()

@property (nonatomic,strong)NSMutableArray *resultBooksArray;

@end

@implementation BTBookTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_resultBooksArray) {
        [_resultBooksArray removeAllObjects];
        _resultBooksArray = [[NSMutableArray alloc] init];

    }else{
        _resultBooksArray = [[NSMutableArray alloc] init];

    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __block NSError *error;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [manager POST:@"http://15809m650x.iok.la/BinderApi/searchBookLibrary.php" parameters:@{@"bookTag":self.bookTag} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseBooksDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if (responseBooksDict[@"error"] || !responseBooksDict) {
              
                return ;
            }else{
                
                NSArray *reponseBooksArray = responseBooksDict[@"books"];
                for (NSDictionary *bookDict in reponseBooksArray) {
                    if ([bookDict isKindOfClass:[NSNull class]] ) {
                        continue;
                    }
                    BTBook *book = [[BTBook alloc] initWithDictionary:bookDict];
                    [_resultBooksArray addObject:book];
                }
                
                [self.tableView reloadData];
                
            }

            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    });
    
    
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

    
    BTKindleBookCell *cell = [BTKindleBookCell cellWithTableView:tableView andIdentifier:cellId];
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



@end
