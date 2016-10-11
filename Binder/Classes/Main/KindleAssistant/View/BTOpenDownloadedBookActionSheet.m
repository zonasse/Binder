//
//  BTOpenDownloadedBookActionSheet.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/10.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTOpenDownloadedBookActionSheet.h"

@implementation BTOpenDownloadedBookActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBook:(BTBook *)book
{
    _book = book;
    self.title = [NSString stringWithFormat:@"%@ : %@",_book.title,_book.suffix];
}

@end
