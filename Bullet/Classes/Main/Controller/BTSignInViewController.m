//
//  BTSignInViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/17.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//  登录界面

#import "BTSignInViewController.h"
#import "BTTabBarViewController.h"
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signInButton:(id)sender {
    
    if (!self.emailTextField.text.length || !self.passwordTextField.text.length) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中"];
    [BmobUser loginInbackgroundWithAccount:self.emailTextField.text andPassword:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"登陆成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                //检测网络
                [[AFNetworkReachabilityManager sharedManager] startMonitoring];
                
                //加载单项控制器
                BTKindleAssistantViewController *kdVC = [[BTKindleAssistantViewController alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *kindleAssiantVCNAV = [[UINavigationController alloc] initWithRootViewController:kdVC];
                
                UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
                BTProfileViewController *profileVC = [signInAndUpSB instantiateViewControllerWithIdentifier:@"profile"];
                
                MMDrawerController *rootController = [[MMDrawerController alloc] initWithCenterViewController:kindleAssiantVCNAV leftDrawerViewController:profileVC];
 
                [UIApplication sharedApplication].keyWindow.rootViewController = rootController;
            });
            
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"账号或密码错误"];
            }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
