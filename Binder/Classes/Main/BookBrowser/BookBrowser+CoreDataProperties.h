//
//  BookBrowser+CoreDataProperties.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BookBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookBrowser (CoreDataProperties)<NSCoding>

@property (nullable, nonatomic, retain) NSData *data_chapters;
@property (nullable, nonatomic, retain) NSNumber *currentPage;
@property (nullable, nonatomic, retain) NSNumber *fontSize;
@property (nullable, nonatomic, retain) NSNumber *totalPages;
@property (nullable,nonatomic,copy) NSString *bookFullName;
@end

NS_ASSUME_NONNULL_END
