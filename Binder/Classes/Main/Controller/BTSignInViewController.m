//
//  BTSignInViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/17.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//  登录界面

#import "BTSignInViewController.h"

@interface BTSignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signInButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation BTSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)signInButton:(id)sender {
    
    if (!self.emailTextField.text.length || !self.passwordTextField.text.length) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    
    if (kNetworkNotReachability) {
        [MBProgressHUD showError:@"网络故障，请重试"];
        return;
    }
    
    [MBProgressHUD showMessage:@"登录中"];
    [BmobUser loginInbackgroundWithAccount:self.emailTextField.text andPassword:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"登陆成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{    
                
                //加载KindleAssistant控制器
                //加载单项控制器
                 BTKindleAssistantFatherViewController *fatherVC = [[BTKindleAssistantFatherViewController alloc]init];

                UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
                BTProfileViewController *profileVC = [signInAndUpSB instantiateViewControllerWithIdentifier:@"profile"];
                
                ShareApp.drawerController = [[MMDrawerController alloc] initWithCenterViewController:fatherVC leftDrawerViewController:profileVC];
                ShareApp.drawerController.view.backgroundColor = [UIColor whiteColor];
                [ShareApp.drawerController setShowsShadow:YES]; // 是否显示阴影效果
                ShareApp.drawerController.maximumLeftDrawerWidth = UIScreenWidth * 7/8; // 左边拉开的最大宽度
                [ShareApp.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [ShareApp.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
  
                [UIApplication sharedApplication].keyWindow.rootViewController = ShareApp.drawerController  ;
                
            });
            
        }
        if (error.code == 101) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"账号或密码错误"];
        }
        
        
        
        if (error.code == 20002) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"无法连接到服务器"];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
