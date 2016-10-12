//
//  BTBookLibraryViewController.h
//  Binder
//
//  Created by 钟奇龙 on 16/10/4.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BTBookLibraryViewControllerDelegate <NSObject>

- (void)bookLibraryVCDidDismissed;

@end

@interface BTBookLibraryViewController : UIViewController
@property (nonatomic,assign) id<BTBookLibraryViewControllerDelegate> delegate;

@end
