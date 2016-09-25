//
//  BTSearchViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/3.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTSearchViewController.h"
@interface BTSearchViewController ()
@property(nonatomic,weak)UIView* containerView;
@end

@implementation BTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UISwitch*st = [UISwitch new];
//    
//    [self.containerView insertSubview:st atIndex:0];
//    
//    st.center = self.view.center;
}

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
   
    self = [super initWithSearchResultsController:searchResultsController];
    if (self) {
        [self setup];
        
    }
    return self;
}



- (void)setup

{
    
    self.searchBar.placeholder=@"搜索书籍";
    
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"BT_Text-Field"] forState:UIControlStateNormal];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"cellBackground"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.searchBar setImage:<#(nullable UIImage *)#> forSearchBarIcon:<#(UISearchBarIcon)#> state:<#(UIControlState)#>];
//    [self.searchBar setBackgroundColor:[UIColor colorWithRed:233/256.0 green:206/256.0 blue:160/256.0 alpha:0]];
    
//    self.searchBar.tintColor=(225,225,225);
    
//    self.searchBar.barTintColor=HCQ_VIEW_BACKGROUND_COLOR;
    
    // Get the instance of the UITextField of the search bar
    
//    UITextField*searchField = [self.searchBar valueForKey:@"_searchField"];
    
    // Change the search bar placeholder text color
    
//    [searchField setValue:self.searchBar.tintColor forKeyPath:@"_placeholderLabel.textColor"];
//    
//    [[[self.searchBar.subviews.firstObject subviews]firstObject]removeFromSuperview];
    
    [self.searchBar setValue:@"取消"forKey:@"_cancelButtonText"];
    
        
}


- (UIView*)containerView

{
    
    if(!_containerView) {
        
        _containerView=self.view.subviews.firstObject;
        
//        _containerView.backgroundColor = HCQ_VIEW_BACKGROUND_COLOR;
        
    }
    
    return _containerView;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
