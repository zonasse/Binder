//
//  BTKindleBookCell.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/28.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTKindleBookCell.h"
#import <MessageUI/MFMessageComposeViewController.h>
@interface BTKindleBookCell ()<ASProgressPopUpViewDataSource,UIAlertViewDelegate>
//cell内部子控件
@property(nonatomic,strong)UIImageView *replaceContentView;
@property(nonatomic,strong)UIImageView *bookImageView;
@property(nonatomic,strong)UILabel *bookTitleLabel;
@property(nonatomic,strong)UILabel *bookAuthorLabel;
@property(nonatomic,strong)UILabel *bookPublisherLabel;
@property(nonatomic,strong)UILabel *bookSizeLabel;
@property(nonnull,strong)UILabel *bookSuffixLabel;
@property(nonatomic,strong)UILabel *bookPublishTimeLabel;
@property(nonatomic,strong)UIButton *bookSendToKindleButton;
@property(nonatomic,strong)UIButton *downloadButton;
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
         [_bookImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"openEgg"]];
    }
   
    
    
    
    _bookTitleLabel.text = book.title;
    _bookAuthorLabel.text = [NSString stringWithFormat:@"作者:%@", _book.author? _book.author:@"未知"];
    _bookPublisherLabel.text = [NSString stringWithFormat:@"出版社:%@", _book.publisher? _book.publisher:@"未知"];
    _bookSizeLabel.text = book.size;
    _bookSuffixLabel.text = _book.suffix;
    _bookPublishTimeLabel.text = [NSString stringWithFormat:@"发行:%@",_book.publishTime?_book.publishTime:@"未知"];
    
    [_bookSendToKindleButton setTitle:@"发送到kindle" forState:UIControlStateNormal];
    [_bookSendToKindleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置下载按钮
    if(_book.bookStatus == btBookStatusDownloaded)
    {
        //已下载
        [_downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"buttonNormal"] forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"buttonHighlighted"] forState:UIControlStateHighlighted];
    
    }else if(_book.bookStatus == btBookStatusNone){
        [_progressView setProgress:0.0];
        //没有下载
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"buttonNormal"] forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"buttonDown"] forState:UIControlStateHighlighted];
        
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //文字字体
        UIFont *font = [UIFont fontWithName:@"Marker Felt" size:12.0];
        
        
        //创建替代cell默认contentView的imageView
        _replaceContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 88)];
        _replaceContentView.userInteractionEnabled = YES;
        UIImage *replaceBackgroundImage = [UIImage imageNamed:@"cellBackground"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(replaceBackgroundImage.size.height * 0.5, replaceBackgroundImage.size.width * 0.5, replaceBackgroundImage.size.height * 0.5, replaceBackgroundImage.size.width * 0.5);
        replaceBackgroundImage = [replaceBackgroundImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
        _replaceContentView.image = replaceBackgroundImage;
        [self.contentView addSubview:_replaceContentView];
        
        //创建书籍imageView
        self.bookImageView = [[UIImageView alloc] init];
        [_replaceContentView addSubview:_bookImageView];
        [self.bookImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookImageViewClicked)]];
        self.bookImageView.userInteractionEnabled = YES;
        [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_replaceContentView.mas_top).with.offset(4);
            make.left.equalTo(_replaceContentView.mas_left).with.offset(10);
            make.bottom.equalTo(_replaceContentView.mas_bottom).with.offset(-4);
            make.width.mas_equalTo(60);
            
        }];
        //创建书名label
        self.bookTitleLabel = [[UILabel alloc] init];
        self.bookTitleLabel.font = font;
        [_replaceContentView addSubview:_bookTitleLabel];
        [self.bookTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookImageView.mas_top);
            make.left.equalTo(_bookImageView.mas_right).with.offset(20);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@100);
            
        }];
        //创建书作者label
        self.bookAuthorLabel = [[UILabel alloc] init];
        self.bookAuthorLabel.font = [font fontWithSize:10.0];
        [_replaceContentView addSubview:_bookAuthorLabel];
        [self.bookAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookTitleLabel.mas_bottom);
            make.left.equalTo(_bookTitleLabel.mas_left);
            make.height.equalTo(_bookTitleLabel.mas_height);
            make.width.equalTo(_bookTitleLabel.mas_width);
            
        }];
        //创建书评价label
        self.bookPublisherLabel = [[UILabel alloc] init];
        self.bookPublisherLabel.font = [font fontWithSize:10.0];
        [_replaceContentView addSubview:_bookPublisherLabel];
        [self.bookPublisherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookAuthorLabel.mas_bottom);
            make.left.equalTo(_bookTitleLabel.mas_left);
            make.height.equalTo(_bookTitleLabel.mas_height);
            make.width.equalTo(_bookTitleLabel.mas_width);
            
        }];
        //创建书文件大小label
        self.bookSizeLabel = [[UILabel alloc] init];
        self.bookSizeLabel.font = font;
        [_replaceContentView addSubview:_bookSizeLabel];
        [self.bookSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookPublisherLabel.mas_bottom);
            make.left.equalTo(_bookPublisherLabel.mas_left);
            make.height.equalTo(_bookPublisherLabel.mas_height);
            make.width.mas_equalTo(@50);
            
        }];
        //创建书格式label
        self.bookSuffixLabel = [[UILabel alloc] init];
        self.bookSuffixLabel.font = font;
        [_replaceContentView addSubview:_bookSuffixLabel];
        [self.bookSuffixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookPublisherLabel.mas_bottom);
            make.left.equalTo(_bookSizeLabel.mas_right).with.offset(5);
            make.height.equalTo(_bookPublisherLabel.mas_height);
            make.width.mas_equalTo(@50);
        }];
        
        
        //创建书来源label
        self.bookPublishTimeLabel = [[UILabel alloc] init];
        self.bookPublishTimeLabel.font = font;
        [_replaceContentView addSubview:_bookPublishTimeLabel];
        [self.bookPublishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookImageView.mas_top);
            make.right.equalTo(_replaceContentView.mas_right).with.offset(-5);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@100);
            
        }];
        
        //创建发送到kindle button
        self.bookSendToKindleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bookSendToKindleButton.titleLabel.font = font;
        [_bookSendToKindleButton setBackgroundImage:[UIImage imageNamed:@"buttonNormal"] forState:UIControlStateNormal];
        [_bookSendToKindleButton setBackgroundImage:[UIImage imageNamed:@"buttonHighlighted"] forState:UIControlStateHighlighted];
        [self.bookSendToKindleButton addTarget:self action:@selector(sendToKindleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_replaceContentView addSubview:_bookSendToKindleButton];
        [self.bookSendToKindleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookPublishTimeLabel.mas_bottom);
            make.right.equalTo(_bookPublishTimeLabel.mas_right);
            make.height.equalTo(_bookPublishTimeLabel.mas_height).with.offset(10);
            make.width.equalTo(_bookPublishTimeLabel.mas_width);
            
        }];
        //创建下载 button
        self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.downloadButton addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
        [_replaceContentView addSubview:_downloadButton];
        [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookSendToKindleButton.mas_bottom);
            make.right.equalTo(_bookSendToKindleButton.mas_right);
            make.height.equalTo(_bookSendToKindleButton.mas_height);
            make.width.equalTo(_bookSendToKindleButton.mas_width);
            
        }];
        
        
       
        
       

        
    }
    return self;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier
{
    BTKindleBookCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)startDownload
{
    
    
    
    switch (_book.bookStatus) {
        case btBookStatusDownloaded:{
           
            [[NSNotificationCenter defaultCenter]postNotificationName:@"openDownloadedBook" object:_book];
            
        }
        break;
        case btBookStatusNone:{
            
            
            //监测网络
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前使用3G/4G移动数据，请注意流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续下载", nil];
                        alertView.delegate = self;
                        return ;
                    }
                        break;
                    case AFNetworkReachabilityStatusUnknown:
                    case AFNetworkReachabilityStatusNotReachable:
                        [MBProgressHUD showError:@"下载失败，当前无可用网络"];
                        return;
                        break;
                    default:
                        break;
                }
            }];
         
            
            //进度条蒙版
            _hideView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, UIScreenWidth, self.replaceContentView.height)];
            _hideView.backgroundColor = [UIColor blackColor];
            _hideView.alpha = 0.5;
            
            //创建下载进度条
            self.progressView = [[ASProgressPopUpView alloc] init];
            [self.progressView showPopUpViewAnimated:YES];
            self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
            [self.progressView setPopUpViewAnimatedColors:@[[UIColor yellowColor],[UIColor greenColor],[UIColor orangeColor]]];
            self.progressView.frame = CGRectMake(0, self.contentView.bounds.size.height * 0.5, UIScreenWidth - 60, 2);
            
            //创建取消按钮
            _cancelDownloadButton = [[UIButton alloc] init];
            _cancelDownloadButton.center = CGPointMake(UIScreenWidth - 45 , 25);
            _cancelDownloadButton.width = 34;
            _cancelDownloadButton.height = 34;
            [_cancelDownloadButton setImage:[UIImage imageNamed:@"list-cancel-badge"] forState:UIControlStateNormal];
            [_cancelDownloadButton addTarget:self action:@selector(cancelDownloadTask) forControlEvents:UIControlEventTouchUpInside];
            [_hideView addSubview:self.progressView];
            [_hideView addSubview:self.cancelDownloadButton];
            
            [self.contentView addSubview:_hideView];

            
            //下载书籍
            
            NSString *bookBaseURL = [NSString stringWithFormat:@"http:// 15809m650x.iok.la%@",self.book.path];
            bookBaseURL = [bookBaseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *bookRequestURL = [NSURL URLWithString:bookBaseURL];
            
            NSURLRequest *bookRequest = [NSURLRequest requestWithURL:bookRequestURL cachePolicy:1 timeoutInterval:20];
            
            [self downloadBookWithRequest:bookRequest];

        }
        break;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //下载书籍
        NSString *bookBaseURL = [NSString stringWithFormat:@"http://15809m650x.iok.la%@",self.book.path];
        bookBaseURL = [bookBaseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *bookRequestURL = [NSURL URLWithString:bookBaseURL];
        
        NSURLRequest *bookRequest = [NSURLRequest requestWithURL:bookRequestURL cachePolicy:1 timeoutInterval:20];
        
        [self downloadBookWithRequest:bookRequest];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //切换到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView setProgress:downloadProgress.completedUnitCount/downloadProgress.totalUnitCount animated:YES] ;
            });
                //判断下载是否完成
                NSLog(@"%f",1.0 *downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
                if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount  == 1.0) {
                    
                    _cancelDownloadButton.enabled = NO;
                   
                    
                    //downloadedBook表添加项
                    
                    //将已下载的书籍数据加入本地数据库表
                    
                    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[downloadBookPath stringByAppendingPathComponent:@"downloadBook.db"]];
                    [queue inDatabase:^(FMDatabase *db) {
                        if ([db open]) {
                            
                            NSString *sqlString = @"CREATE TABLE IF NOT EXISTS bt_book (bt_bookId VARCHAR PRIMARY KEY ,bt_title VARCHAR ,bt_suffix VARCHAR,bt_author VARCHAR NOT NULL DEFAULT '',bt_category VARCHAR NOT NULL DEFAULT '',bt_publisher VARCHAR NOT NULL DEFAULT '',bt_publish_time VARCHAR NOT NULL DEFAULT '',bt_size VARCHAR,bt_cover_path VARCHAR NOT NULL DEFAULT '',bt_tag VARCHAR NOT NULL DEFAULT '',bt_rating VARCHAR NOT NULL DEFAULT '');";
                            NSString *sqlString2 = [NSString stringWithFormat: @"INSERT INTO bt_book (bt_bookId,bt_title  ,bt_suffix ,bt_author ,bt_category ,bt_publisher ,bt_publish_time ,bt_size ,bt_cover_path,bt_tag,bt_rating) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",self.book.bookId,self.book.title,self.book.suffix,self.book.author,self.book.category,self.book.publisher,self.book.publishTime,self.book.size,self.book.cover,self.book.tag,self.book.rating];
                            
                            [db executeUpdate:sqlString];
                            BOOL result = [db executeUpdate:sqlString2];
                            if (result) {
                                //关闭进度条
                                
                                
                                //切换到主线程
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_hideView removeFromSuperview];
                                    [_downloadButton setTitle:@"打开" forState:UIControlStateNormal];
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
            NSLog(@"%@",error.localizedDescription);
        }] ;
        
        [self.downloadTask resume];
        
        
 
    });
    
    
    
}

- (void)cancelDownloadTask{
    [self.downloadTask cancel];
    _book.bookStatus = btBookStatusNone;
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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendToKindle" object:self.book];
    
}

- (void)bookImageViewClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBookDetailView" object:self.book];
}

@end
