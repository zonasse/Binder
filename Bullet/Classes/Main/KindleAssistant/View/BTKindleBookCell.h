//
//  BTKindleBookCell.h
//  Bullet
//
//  Created by 钟奇龙 on 16/8/28.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBook.h"
@interface BTKindleBookCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier;

@property (nonatomic,strong) BTBook  *book;



@end
