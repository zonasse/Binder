//
//  Chapter.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Chapter : NSObject<NSCoding>

@property (nonatomic, assign) NSRange allContentRange;
@property (nonatomic, assign) NSRange contentRange;
//标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSRange titleRange;
// Insert code here to declare functionality of your managed object subclass
+ (instancetype)modelWithTitle:(NSString *)title
                    titleRange:(NSRange )titleRange
               allContentRange:(NSRange )allContentRange ;
@end


