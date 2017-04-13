//
//  BTBookBrowserTool.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBookBrowserTool : NSObject
@property (nonatomic,strong) NSManagedObjectContext *managedContext;
- (void)createCoreDataContent;

- (void)checkLocalCoreDataWithBookFullName:(NSString *)bookFullName;
- (void)modifyDataWithBookFullName:(NSString *)bookFullName currentChapterIndex:(NSNumber*)currentChapterIndex fontSize:(NSNumber*)fontSize;



@end
