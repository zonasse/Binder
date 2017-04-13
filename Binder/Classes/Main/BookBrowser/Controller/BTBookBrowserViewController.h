//
//  BTBookBrowserViewController.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTBook;
@class BookBrowser;
@class BTBookBrowserTool;
@interface BTBookBrowserViewController : UIViewController

@property(nonatomic,strong) BTBook *book;
@property(nonatomic,strong) BTBookBrowserTool *tool;
@property(nonatomic,strong) BookBrowser *browser;
@property(nonatomic,strong) NSArray *chapters;
/**
 *  CoreData相关属性
 */
@property (nonatomic,strong) NSManagedObjectContext  *managerObjectContext;
@property (nonatomic,strong) NSManagedObjectModel  *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
//- (void)saveContext;
@end
