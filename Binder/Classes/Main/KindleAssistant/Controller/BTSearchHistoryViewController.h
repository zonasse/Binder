//
//  BTSearchHistoryViewController.h
//  Bullet
//
//  Created by 钟奇龙 on 16/9/19.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTSearchHistoryViewControllerDelegate <NSObject>

- (void)searchHistoryCellDidClicked:(NSString *)cellText;

@end

@interface BTSearchHistoryViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *searchHistoryArray;
@property (nonatomic,assign) id<BTSearchHistoryViewControllerDelegate>  delegate;

@end
