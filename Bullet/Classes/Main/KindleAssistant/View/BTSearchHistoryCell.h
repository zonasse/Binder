//
//  BTSearchHistoryCell.h
//  Bullet
//
//  Created by 钟奇龙 on 16/9/25.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTSearchHistoryCellDelegate <NSObject>

- (void)deleteHistoryCellWithTag:(NSUInteger)tag;

@end

@interface BTSearchHistoryCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier;
@property (nonatomic,strong) NSString *historyName;
@property (nonatomic,assign) id<BTSearchHistoryCellDelegate> delegate;


@end
