//
//  BTBookBrowser.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTBook;
@interface BTBookBrowser : NSObject

/**
 *  章节
 */
@property (nonatomic,strong) NSArray  *chapters;
/**
 *  字体大小
 */
@property (nonatomic,assign) CGFloat  fontSize;
/**
 *  总页数
 */
@property (nonatomic,assign) int  totalPages;
/**
 *  当前页数
 */
@property (nonatomic,assign) int  currentPage;
/**
 *  当前打开的书
 */
@property (nonatomic,strong) BTBook  *book;
- (instancetype)initWithBook:(BTBook *)book;
@end

