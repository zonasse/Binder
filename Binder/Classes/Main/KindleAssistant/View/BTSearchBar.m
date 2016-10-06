//
//  BTSearchBar.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/27.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTSearchBar.h"
#import "UIView+extension.h"
#import "AFNetworking.h"
#import "BTBook.h"
#import "BTKindleAssistantViewController.h"
@interface BTSearchBar()

@property (nonatomic,strong,readwrite)NSArray *resultBooks;
@end

@implementation BTSearchBar


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.width = [UIScreen mainScreen].bounds.size.width;
        self.height = 44;
        self.x = 0;
        self.y = 20;
        self.backgroundColor = [UIColor greenColor];
        self.placeholder = @"输入书名";
        self.delegate = self;
        
        
    }
    return self;
}

- (void)setResultBooks:(NSArray *)resultBooks
{
    _resultBooks = resultBooks;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block NSError *error;
    
    NSMutableArray *mutableResultBooks = [NSMutableArray array];
    
    //2.异步向服务器发送请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *book = self.text;
        
        NSDictionary *params = @{@"book":book};
        [manager POST:@"http://172.18.96.73:8888/www/BulletApi/searchBooks.php" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSArray *responseBooks = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            [responseBooks enumerateObjectsUsingBlock:^(NSDictionary  *bookDict, NSUInteger idx, BOOL * _Nonnull stop) {
                BTBook *book = [[BTBook alloc] initWithDictionary:bookDict];
                [mutableResultBooks addObject:book];
                
            }];
//            拿到返回的BTBook数组
            self.resultBooks = mutableResultBooks;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"searchBooksResultGot" object:self.resultBooks];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    });
    
}



@end
