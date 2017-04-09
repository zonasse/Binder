//
//  BTChapter.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTChapter : NSObject
//章节标题
@property(nonatomic,copy)NSString *title ;
@property(nonatomic)NSRange titleRange ;
//章节内容
@property(nonatomic)NSRange contentRange ;
//内容（包括title）
@property(nonatomic)NSRange allContentRange;
+ (instancetype)modelWithTitle:(NSString *)title
                    titleRange:(NSRange )titleRange
               allContentRange:(NSRange )allContentRange;
@end
