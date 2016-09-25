//
//  BTVerifyEmailViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/18.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTVerifyEmailViewController.h"
#import "BTTabBarViewController.h"
@interface BTVerifyEmailViewController ()

@property (nonatomic,weak) IBOutlet UILabel *informLabel;
@property (nonatomic,weak) IBOutlet UIButton *resendButton;
@property (nonatomic,weak) IBOutlet UIButton *verifiedButton;
@property (nonatomic,strong) BmobUser *user;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger time;
@end

@implementation BTVerifyEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _user = [BmobUser currentUser];
    

    self.informLabel.text = [NSString stringWithFormat:@"激活邮件已发送至%@",_user.email];
    self.informLabel.adjustsFontSizeToFitWidth = YES;
    

    
    self.time = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(deCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [self.resendButton addTarget:self action:@selector(resendEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.verifiedButton addTarget:self action:@selector(verifiedEmail) forControlEvents:UIControlEventTouchUpInside];

}

- (void)deCount
{
    if (self.time > 0) {
            self.resendButton.enabled = NO;
        [self.resendButton setTitle:[NSString stringWithFormat:@"未收到？重新发送(%d)",self.time] forState:UIControlStateNormal];
       
        [self.resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.time--;
    }else{
        self.time = 60;
        [self.timer invalidate];
        self.timer = nil;
        self.resendButton.enabled = YES;
        [self.resendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.resendButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }
    
}

- (void)resendEmail
{
    
    __unsafe_unretained typeof (self)weakSelf = self;
    [MBProgressHUD showMessage:@"处理中..."];
    [_user verifyEmailInBackgroundWithEmailAddress:_user.email block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"邮件已发送"];
                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(deCount) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop]addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
            });
           
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"重新发送失败，请检查网络"];
            });
            
            
        }
    }];
}

- (void)verifiedEmail
{
    [MBProgressHUD showMessage:@"处理中..."];
   [_user userEmailVerified:^(BOOL isSuccessful, NSError *error) {
       if (isSuccessful) {
           [MBProgressHUD hideHUD];
           [MBProgressHUD showSuccess:@"注册成功"];
           
           
           //检测网络
           [[AFNetworkReachabilityManager sharedManager] startMonitoring];
           
           //加载单项控制器
           BTKindleAssistantViewController *kdVC = [[BTKindleAssistantViewController alloc] initWithStyle:UITableViewStyleGrouped];
           UINavigationController *kindleAssiantVCNAV = [[UINavigationController alloc] initWithRootViewController:kdVC];
           
           UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
           BTProfileViewController *profileVC = [signInAndUpSB instantiateViewControllerWithIdentifier:@"profile"];
           
           MMDrawerController *rootController = [[MMDrawerController alloc] initWithCenterViewController:kindleAssiantVCNAV leftDrawerViewController:profileVC];
           
           [UIApplication sharedApplication].keyWindow.rootViewController = rootController;
       }else{
           [MBProgressHUD hideHUD];
           [MBProgressHUD showError:@"尚未收到激活信息，请稍后重试"];
           
       }
   }];
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

@end
