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
- (void)insertBrowserDataWithChapters:(NSArray *)chapters currentPage:(NSNumber *)currentPage totalPages:(NSNumber *)totalPages bookFullName:(NSString *)bookFullName;
- (void)readDataWithBookFullName:(NSString *)bookFullName;
@end
