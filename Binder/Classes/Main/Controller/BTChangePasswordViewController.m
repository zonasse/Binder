//
//  BTChangePasswordViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/10.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTChangePasswordViewController.h"

@interface BTChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation BTChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)FindPassword:(id)sender {
    
    
    if (!self.emailText.text.length ) {
        [MBProgressHUD showError:@"邮箱不能为空"];
        return;
    }
    
    if (kNetworkNotReachability) {
        [MBProgressHUD showError:@"网络故障，请重试"];
        return;
    }
    
    NSRegularExpression *emailRegular = [NSRegularExpression regularExpressionWithPattern:@"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * emailCheckResult = [emailRegular matchesInString:self.emailText.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.emailText.text.length)];
    
    if (!emailCheckResult.count)
    {
        [MBProgressHUD showError:@"邮箱格式错误"];
        return;
    }

    
        //找回密码
        [BmobUser requestPasswordResetInBackgroundWithEmail:_emailText.text];
        [MBProgressHUD showSuccess:@"验证信息已发送至您的验证邮箱中"];


        //修改密码
//        BmobUser *user = [BmobUser getCurrentUser];
//        [user updateCurrentUserPasswordWithOldPassword:@"old password" newPassword:@"new password" block:^(BOOL isSuccessful, NSError *error) {
//            if (isSuccessful) {
//                //用新密码登录
//                [BmobUser loginInbackgroundWithAccount:@"name" andPassword:@"new password" block:^(BmobUser *user, NSError *error) {
//                    if (error) {
//                        NSLog(@"login error:%@",error);
//                    } else {
//                        NSLog(@"user:%@",user);
//                    }
//                }];
//            } else {
//                NSLog(@"change password error:%@",error);
//            }
//        }];
    
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
