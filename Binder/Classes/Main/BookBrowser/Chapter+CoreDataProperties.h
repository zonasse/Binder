//
//  Chapter+CoreDataProperties.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chapter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *allContentRange;
@property (nullable, nonatomic, retain) NSString *contentRange;
//标题
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *titleRange;

@end

NS_ASSUME_NONNULL_END
