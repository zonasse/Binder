//
//  BTBookBrowserViewController.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTBookBrowser;
@interface BTBookBrowserViewController : UIViewController
@property (nonatomic,strong) BTBookBrowser  *browser;
/**
 *  CoreData相关属性
 */
@property (nonatomic,strong) NSManagedObjectContext  *managerObjectContext;
@property (nonatomic,strong) NSManagedObjectModel  *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
- (void)saveContext;
@end
