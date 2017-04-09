//
//  BookBrowser+CoreDataProperties.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BookBrowser+CoreDataProperties.h"

@implementation BookBrowser (CoreDataProperties)

@dynamic data_chapters;
@dynamic currentPage;
@dynamic fontSize;
@dynamic totalPages;
@dynamic bookFullName;

+ (id)insertNewObjectInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"" inManagedObjectContext:context];
}
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:self.data_chapters forKey:@"data_chapters"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.data_chapters = [aDecoder decodeObjectForKey:@"data_chapters"];
        
    }
    return self;
}
@end
