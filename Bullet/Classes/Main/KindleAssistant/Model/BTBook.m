//
//  BTBook.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/28.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBook.h"

@implementation BTBook

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.bookId = dict[@"bt_bookId"];
        self.title = dict[@"bt_title"];
        self.author = dict[@"bt_author"];
        self.size = dict[@"bt_size"];
        self.size = [NSString stringWithFormat:@"%.1fMB",self.size.intValue/(1024*1024.0)];
        if ([dict[@"bt_cover_path"] length] > 25) {
            self.cover = [dict[@"bt_cover_path"] substringFromIndex:25.0];
        }else{
            self.cover = dict[@"bt_cover_path"];
        }
        
        
        self.suffix = dict[@"bt_suffix"];
      
        self.path = dict[@"bt_path"];
    
        self.publisher = dict[@"bt_publisher"];
        self.publishTime = [dict[@"bt_publish_time"] substringToIndex:10.0];
        self.category = dict[@"bt_category"];
        
        
        
        //看书籍是否已下载
        FMDatabase *downloadBookDatabase = [FMDatabase databaseWithPath:[downloadBookPath stringByAppendingPathComponent:@"downloadBook.db"]];
        if ([downloadBookDatabase open]) {
            //用bt_bookId查找
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM bt_book WHERE bt_bookId = '%@'",self.bookId];
            if ([[downloadBookDatabase executeQuery:sqlStr] next]) {
                self.bookStatus = btBookStatusDownloaded;
            }else{
                self.bookStatus = btBookStatusNone;
            }
            
        }
        [downloadBookDatabase close];
        
        
    }
    return self;
}





@end
