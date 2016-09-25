//
//  BTBook.h
//  Bullet
//
//  Created by 钟奇龙 on 16/8/28.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//



#import <Foundation/Foundation.h>


typedef enum btBookDownloadStatus
{
    btBookStatusDownloaded = 1,//已经下载
    btBookStatusNone = 0//没有下载
    
}btBookStatus;

@interface BTBook : NSObject
//id
@property (nonatomic,copy) NSString *bookId;
//书名
@property (nonatomic,copy) NSString *title;
//作者
@property (nonatomic,copy) NSString *author;
//大小
@property (nonatomic,copy) NSString *size;
//图片
@property (nonatomic,copy) NSString *cover;
//后缀
@property (nonatomic,copy) NSString *suffix;
//下载路径
@property (nonatomic,copy) NSString *path;
//书籍简单描述
@property (nonatomic,copy) NSString *category;
//出版社
@property (nonatomic,copy) NSString *publisher;
//出版时间
@property (nonatomic,copy) NSString *publishTime;


@property (nonatomic,assign) btBookStatus bookStatus;

//@property (nonatomic,copy) NSString *bookDescription;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
