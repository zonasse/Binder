//
//  BTVerifyEmailViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/18.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTVerifyEmailViewController.h"
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
    
    if(kNetworkNotReachability)
    {
        [MBProgressHUD showError:@"当前网络故障，请重试"];
        return;
    }
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
    
    if(kNetworkNotReachability)
    {
        [MBProgressHUD showError:@"当前网络故障，请重试"];
        return;
    }
    
    [MBProgressHUD showMessage:@"处理中..."];
   [_user userEmailVerified:^(BOOL isSuccessful, NSError *error) {
       if (isSuccessful) {
           [MBProgressHUD hideHUD];
           [MBProgressHUD showSuccess:@"注册成功"];
          
           BTKindleAssistantFatherViewController *fatherVC = [[BTKindleAssistantFatherViewController alloc]init];

           
           UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
           BTProfileViewController *profileVC = [signInAndUpSB instantiateViewControllerWithIdentifier:@"profile"];
           UINavigationController *profileVCNAV = [[UINavigationController alloc] initWithRootViewController:profileVC];
           
           
 
           ShareApp.drawerController = [[MMDrawerController alloc] initWithCenterViewController:fatherVC leftDrawerViewController:profileVCNAV];
           ShareApp.drawerController.view.backgroundColor = [UIColor whiteColor];
           [ShareApp.drawerController setShowsShadow:YES]; // 是否显示阴影效果
           ShareApp.drawerController.maximumLeftDrawerWidth = UIScreenWidth * 7/8; // 左边拉开的最大宽度
           [ShareApp.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
           [ShareApp.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
           [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
           
           [UIApplication sharedApplication].keyWindow.rootViewController = ShareApp.drawerController  ;
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
