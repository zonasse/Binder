//
//  BTKindleBookCell.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/28.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTKindleBookCell.h"
#import "BTBaseWebViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
@interface BTKindleBookCell ()<ASProgressPopUpViewDataSource,UIAlertViewDelegate>
//cell内部子控件
@property(nonatomic,strong)UIImageView *replaceContentView;
@property(nonatomic,strong)UIImageView *bookImageView;
@property(nonatomic,strong)UILabel *bookTitleLabel;
@property(nonatomic,strong)UILabel *bookAuthorLabel;
@property(nonatomic,strong)UILabel *bookSizeLabel;
@property(nonnull,strong)UILabel *bookSuffixLabel;
@property(nonatomic,strong)UILabel *bookTagLabel;
@property (nonatomic,strong) UILabel *bookRatingLabel;
//@property(nonatomic,strong)UILabel *bookPublishTimeLabel;
@property (nonatomic,strong) UIButton *searchInAmazonButton;
@property(nonatomic,strong)UIButton *downloadButton;
@property(nonatomic,strong)UIButton *bookSendToKindleButton;
@property (nonatomic,strong) UIView *hideView;
@property (nonatomic,strong) ASProgressPopUpView *progressView;
@property (nonatomic,strong) UIButton *cancelDownloadButton;


@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation BTKindleBookCell

- (void)setBook:(BTBook *)book
{
    _book = book;
    

    
    NSString *baseImageURL =[NSString stringWithFormat:@"http://15809m650x.iok.la%@",_book.cover];
    baseImageURL = [baseImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *imageURL = [NSURL URLWithString:baseImageURL];
   
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:baseImageURL];
    if (originalImage) {
        _bookImageView.image = originalImage;
    }else{
        [_bookImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBook"]];
    }
   
    
    
    if (self.rowNumber != 0) {
        _bookTitleLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)self.rowNumber,book.title];
    }else{
    _bookTitleLabel.text =  book.title;
    }
    _bookAuthorLabel.text = [NSString stringWithFormat:@"作者:%@", book.author? book.author:@"未知"];

    _bookSizeLabel.text = [NSString stringWithFormat:@"%@", book.size];
    
    _bookSuffixLabel.text = [NSString stringWithFormat:@"格式:%@",book.suffix];
    _bookTagLabel.text = [NSString stringWithFormat:@"标签:%@", book.tag ? book.tag:@"暂无"];
    _bookRatingLabel.text = [NSString stringWithFormat:@"豆瓣评分:%@",book.rating?book.rating:@"暂无"];
    
    //设置下载按钮
    if(_book.bookStatus == btBookStatusDownloaded)
    {
        //已下载
        [_downloadButton setTitle:@"  打开" forState:UIControlStateNormal];
        [_downloadButton setTitle:@"  打开" forState:UIControlStateHighlighted];
        [_downloadButton setImage:[UIImage imageNamed:@"profile_0005_Book"] forState:UIControlStateNormal];
        
    
    }else if(_book.bookStatus == btBookStatusNone){
        
        //没有下载
    
        [_downloadButton setTitle:@"  下载" forState:UIControlStateNormal];

        [_downloadButton setImage:[UIImage imageNamed:@"profile_0006_Download"] forState:UIControlStateNormal];
  
        
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //文字字体
        UIFont *font = [UIFont fontWithName:@"Marker Felt" size:13.0];
        
        
        //创建替代cell默认contentView的imageView
        _replaceContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
        _replaceContentView.userInteractionEnabled = YES;
        UIImage *replaceBackgroundImage = [UIImage imageNamed:@"cellBackground"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(replaceBackgroundImage.size.height * 0.5, replaceBackgroundImage.size.width * 0.5, replaceBackgroundImage.size.height * 0.5, replaceBackgroundImage.size.width * 0.5);
        replaceBackgroundImage = [replaceBackgroundImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
        _replaceContentView.image = replaceBackgroundImage;
        [self.contentView addSubview:_replaceContentView];
        
        //创建书籍imageView
        self.bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 60, 80)];
        [_replaceContentView addSubview:_bookImageView];
        self.bookImageView.userInteractionEnabled = YES;

        //创建书名label
        self.bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bookImageView.frame) + 10, 4, _replaceContentView.width - (10+ 60+10+10), 24)];
        self.bookTitleLabel.textColor = [UIColor blackColor];
        self.bookTitleLabel.font = font;
        [_replaceContentView addSubview:_bookTitleLabel];
        

        //创建书作者label
        self.bookAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bookTitleLabel.x, CGRectGetMaxY(self.bookTitleLabel.frame) + 4, (self.bookTitleLabel.width - 10) * 0.5, self.bookTitleLabel.height)];
        self.bookAuthorLabel.font = font;
        self.bookAuthorLabel.adjustsFontSizeToFitWidth = YES;
        self.bookAuthorLabel.textColor = [UIColor brownColor];

        [_replaceContentView addSubview:_bookAuthorLabel];

        //创建书格式label
       
        self.bookSuffixLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bookTitleLabel.x, CGRectGetMaxY(self.bookAuthorLabel.frame) + 4, self.bookAuthorLabel.width * 0.5, self.bookTitleLabel.height)];
        self.bookSuffixLabel.font = font;
        self.bookSuffixLabel.textColor = [UIColor brownColor];
        self.bookSuffixLabel.textAlignment = NSTextAlignmentLeft;
        self.bookSuffixLabel.adjustsFontSizeToFitWidth = YES;
        [_replaceContentView addSubview:_bookSuffixLabel];

        //创建书文件大小label
        self.bookSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bookSuffixLabel.frame) , self.bookSuffixLabel.y, self.bookAuthorLabel.width * 0.5, self.bookTitleLabel.height)];
        self.bookSizeLabel.font = font;
        self.bookSizeLabel.textColor = [UIColor brownColor];

        self.bookSizeLabel.textAlignment = NSTextAlignmentCenter;
        [_replaceContentView addSubview:_bookSizeLabel];

        
        //创建书标签label
        self.bookTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bookAuthorLabel.frame) + 10, self.bookAuthorLabel.y, self.bookAuthorLabel.width, self.bookTitleLabel.height)];
        self.bookTagLabel.font = font;
        self.bookTagLabel.textColor = [UIColor brownColor];

        [_replaceContentView addSubview:_bookTagLabel];

        //创建书评分label
        self.bookRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bookTagLabel.x, CGRectGetMaxY(self.bookTagLabel.frame) + 4, self.bookTagLabel.width, self.bookTagLabel.height)];
        self.bookRatingLabel.font = font;
        self.bookRatingLabel.textColor = [UIColor brownColor];

        [_replaceContentView addSubview:self.bookRatingLabel];
        
        //cell底部条
        CGFloat bottomToolBarHeight = 34;
        UIImageView *bottomToolBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, _replaceContentView.height - bottomToolBarHeight, _replaceContentView.width, bottomToolBarHeight)];
        bottomToolBar.userInteractionEnabled = YES;

        
      
        //创建发送到kindle button
        self.bookSendToKindleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , _replaceContentView.width / 3, bottomToolBarHeight - 1)];
        [_bookSendToKindleButton setImage:[UIImage imageNamed:@"profile_0038_Cloud-Upload"] forState:UIControlStateNormal];

        [_bookSendToKindleButton setTitle:@"kindle" forState:UIControlStateNormal];
        _bookSendToKindleButton.titleLabel.font = font;
        [_bookSendToKindleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.bookSendToKindleButton addTarget:self action:@selector(sendToKindleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBar addSubview:_bookSendToKindleButton];

        
        //创建下载 button
        self.downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(_replaceContentView.width / 3, 0, _bookSendToKindleButton.width, _bookSendToKindleButton.height)];
        _downloadButton.titleLabel.font = font;
        [_downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBar addSubview:_downloadButton];

        
        //创建在amazon中查找button
        self.searchInAmazonButton = [[UIButton alloc] initWithFrame:CGRectMake(self.replaceContentView.width * 2 / 3, 0, _bookSendToKindleButton.width, _bookSendToKindleButton.height)];
        [self.searchInAmazonButton setImage:[UIImage imageNamed:@"profile_0043_Paperclip"] forState:UIControlStateNormal];
      
        [self.searchInAmazonButton setTitle:@"amazon" forState:UIControlStateNormal];
        
        self.searchInAmazonButton.titleLabel.font = font;


        [_searchInAmazonButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_searchInAmazonButton addTarget:self action:@selector(findInAmazon) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, bottomToolBar.height - 1, bottomToolBar.width, 1)];
        bottomViewLine.backgroundColor = [UIColor brownColor];
        
        [bottomToolBar addSubview:_searchInAmazonButton];
        [bottomToolBar addSubview:bottomViewLine];
    
        [_replaceContentView addSubview:bottomToolBar];
     

        
    }
    return self;
}




- (void)startDownload
{
    
    
    
    switch (_book.bookStatus) {
        case btBookStatusDownloaded:{
           
            [[NSNotificationCenter defaultCenter]postNotificationName:@"openDownloadedBook" object:_book];
            
        }
        break;
        case btBookStatusNone:{
            _downloadButton.enabled = NO;
            //进度条蒙版
            _hideView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, self.replaceContentView.height - self.bookSendToKindleButton.height)];
            _hideView.backgroundColor = [UIColor whiteColor];
            _hideView.alpha = 0.8;
            _hideView.tag = 100;
    
            //创建下载进度条
            self.progressView = [[ASProgressPopUpView alloc] init];
            [_progressView setProgress:0.0];
            [self.progressView showPopUpViewAnimated:YES];
            self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
            [self.progressView setPopUpViewAnimatedColors:@[[UIColor brownColor],[UIColor blueColor],[UIColor orangeColor]]];
            self.progressView.frame = CGRectMake(0, self.contentView.bounds.size.height * 0.5, UIScreenWidth - 60, 2);
            
            //创建取消按钮
            _cancelDownloadButton = [[UIButton alloc] init];
            _cancelDownloadButton.center = CGPointMake(UIScreenWidth - 45 , _hideView.height * 0.5 - 17);
            _cancelDownloadButton.width = 34;
            _cancelDownloadButton.height = 34;
            [_cancelDownloadButton setImage:[UIImage imageNamed:@"list-cancel-badge"] forState:UIControlStateNormal];
            [_cancelDownloadButton addTarget:self action:@selector(cancelDownloadTask) forControlEvents:UIControlEventTouchUpInside];
            [_hideView addSubview:self.progressView];
            [_hideView addSubview:self.cancelDownloadButton];
            
            [self.contentView addSubview:_hideView];

            
            //下载书籍
            
            NSString *bookBaseURL = [NSString stringWithFormat:@"http://15809m650x.iok.la%@",self.book.path];
//            NSString *bookBaseURL = [NSString stringWithFormat:@"http://localhost:8888%@",self.book.path];
            bookBaseURL = [bookBaseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *bookRequestURL = [NSURL URLWithString:bookBaseURL];
            
            NSURLRequest *bookRequest = [NSURLRequest requestWithURL:bookRequestURL cachePolicy:1 timeoutInterval:10];
            
            [self downloadBookWithRequest:bookRequest];

        }
        break;
    }

}




/**
 *  下载方法
 *
 *  @param request      url请求
 *  @param bookFullName 书籍全名
 *  @param substance    书籍来源
 */
- (void)downloadBookWithRequest:(NSURLRequest *)request
{
   //下载对应书籍
   
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //切换到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView setProgress: 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount  animated:YES] ;
            });
                //判断下载是否完成
            if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount == 1.0) {
                
                    _cancelDownloadButton.enabled = NO;
                   
                    
                    //downloadedBook表添加项
                    
                    //将已下载的书籍数据加入本地数据库表
                    
                    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[downloadBookPath stringByAppendingPathComponent:@"downloadBook.db"]];
                    [queue inDatabase:^(FMDatabase *db) {
                        if ([db open]) {
                            
                            NSString *sqlString = @"CREATE TABLE IF NOT EXISTS bt_book (bt_bookId VARCHAR PRIMARY KEY ,bt_title VARCHAR ,bt_suffix VARCHAR,bt_author VARCHAR NOT NULL DEFAULT '',bt_category VARCHAR NOT NULL DEFAULT '',bt_publisher VARCHAR NOT NULL DEFAULT '',bt_publish_time VARCHAR NOT NULL DEFAULT '',bt_size VARCHAR,bt_cover_path VARCHAR NOT NULL DEFAULT '',bt_tag VARCHAR NOT NULL DEFAULT '',bt_rating VARCHAR NOT NULL DEFAULT '',bt_path VARCHAR NOT NULL DEFAULT '');";
                            NSString *sqlString2 = [NSString stringWithFormat: @"INSERT INTO bt_book (bt_bookId,bt_title  ,bt_suffix ,bt_author ,bt_category ,bt_publisher ,bt_publish_time ,bt_size ,bt_cover_path,bt_tag,bt_rating,bt_path) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",self.book.bookId,self.book.title,self.book.suffix,self.book.author,self.book.category,self.book.publisher,self.book.publishTime,self.book.size,self.book.cover,self.book.tag,self.book.rating,self.book.path];
                            
                            [db executeUpdate:sqlString];
                            BOOL result = [db executeUpdate:sqlString2];
                            if (result) {
                                //关闭进度条
                                
                                
                                //切换到主线程
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_hideView removeFromSuperview];
                                    _downloadButton.enabled = YES;
                                    [_downloadButton setTitle:@" 打开" forState:UIControlStateNormal];
                                    [_downloadButton setImage:[UIImage imageNamed:@"mini_0000s_0007_Book"] forState:UIControlStateNormal];
                                    _book.bookStatus = btBookStatusDownloaded;
                                });
                            }
                        }
                        [db close];
                    }];
                }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *path = [downloadBookPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",self.book.title,self.book.suffix]];
            NSURL *url = [NSURL fileURLWithPath:path];
            return url;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                [MBProgressHUD showError:@"下载失败,请检查网络"];
                [self cancelDownloadTask];
                _downloadButton.enabled = YES;
            }
            
        }] ;
        
        [self.downloadTask resume];
        
        
 
    });
    
    
    
}

- (void)cancelDownloadTask{
    [self.downloadTask cancel];
    _book.bookStatus = btBookStatusNone;
    [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [_downloadButton setImage:[UIImage imageNamed:@"mini_0000s_0035_Download"] forState:UIControlStateNormal];
    [_hideView removeFromSuperview];
    
}


#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if (progress < 0.2) {
       
    } else if (progress > 0.4 && progress < 0.6) {
        s = @"half";
    }
    else if (progress >= 1.0) {
        s = @"complete";
    }
    return s;
}

- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return YES;
}

- (void)sendToKindleButtonClicked
{
    //向服务器发送邮件
   
    [MBProgressHUD showMessage:@"推送中..."];
    BmobUser *user = [BmobUser currentUser];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.book.path forKey:@"bt_path"];
    [params setObject:[user objectForKey:@"kindleEmail"] forKey:@"kindleEmail"];
    if ([self.book.suffix isEqualToString:@"pdf"] || [self.book.suffix isEqualToString:@"txt"]) {
        [params setObject:@"convert" forKey:@"convert"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:@"http://15809m650x.iok.la/BinderApi/sendMail.php" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"书籍推送成功"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"推送失败，请检查网络"];
            
        }];
    });
    
   
    
}

- (void)findInAmazon
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"findInAmazon" object:self.book];
    
    
}



@end
