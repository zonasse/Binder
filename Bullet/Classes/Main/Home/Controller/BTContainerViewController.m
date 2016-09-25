//
//  BTContainerViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/23.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTContainerViewController.h"

@interface BTContainerViewController ()

@end

@implementation BTContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://更多资讯
        {
            
        }
            break;
        case 1://小工具
        {
            
        }
            break;
        
        case 3://电子书格式
        {
            
        }
            break;
        case 4://关于作者
        {
            
        }
            break;
        case 5://找不到书？反馈
        {
            
        }
            break;
        case 6://设置
        {
            
        }
            break;
        case 7://注销
        {
            [BmobUser logout];
            //加载登录注册界面
            UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
            BTSignInViewController *signInVC = signInAndUpSB.instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = signInVC;
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
