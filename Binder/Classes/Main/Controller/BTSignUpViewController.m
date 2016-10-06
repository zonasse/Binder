//
//  BTSignUpViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/17.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//  注册界面

#import "BTSignUpViewController.h"
@interface BTSignUpViewController ()
- (IBAction)cancelButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
- (IBAction)signUpButton:(id)sender;
@property (nonatomic,strong) BmobUser *user;
@end

@implementation BTSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)signUpButton:(id)sender {
    
    if(kNetworkNotReachability)
    {
        [MBProgressHUD showError:@"当前网络故障，请重试"];
        return;
    }
    
    if ( !self.passwordTextField.text.length || !self.emailTextField.text.length) {
        [MBProgressHUD showError:@"邮箱或密码不能为空"];
        return;
    }
    
  
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [MBProgressHUD showError:@"前后密码不一致"];
        return;
    }
    
    NSRegularExpression *passwordRegular = [NSRegularExpression regularExpressionWithPattern:@"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *passwordCheckResult = [passwordRegular matchesInString:self.passwordTextField.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.passwordTextField.text.length)];
    
    NSRegularExpression *emailRegular = [NSRegularExpression regularExpressionWithPattern:@"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * emailCheckResult = [emailRegular matchesInString:self.emailTextField.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.emailTextField.text.length)];
    
    
    
    if (!passwordCheckResult.count){
            [MBProgressHUD showError:@"密码强度太低"];
            return;
    }else if (!emailCheckResult.count)
    {
        [MBProgressHUD showError:@"邮箱格式错误"];
        return;
    }
    
    
    self.user = [[BmobUser alloc] init];
    [self.user setUsername:self.emailTextField.text];
    [self.user setPassword:self.passwordTextField.text];
    [self.user setEmail:self.emailTextField.text];
    
    
    [self.emailTextField.text enumerateSubstringsInRange:NSMakeRange(0, self.emailTextField.text.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        [self.user setObject:[NSString stringWithFormat:@"%@@kindle.cn",substring] forKey:@"kindleEmail"];
        *stop = YES;
    }];
    
    [MBProgressHUD showMessage:@"处理中..."];

    
    __unsafe_unretained typeof (self)weakSelf = self;
    [self.user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD hideHUD];
            //跳转到验证邮箱控制器
            UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
            BTVerifyEmailViewController *verifyVC = [signInAndUpSB instantiateViewControllerWithIdentifier:@"verify"];
            [weakSelf presentViewController:verifyVC animated:YES completion:^{
                        
            }];
            

        }else{
            
            if (error.code == 202) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"邮箱已经被注册"];
            }else if(error.code == 203)
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"邮箱已经被注册"];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"处理信息失败，请检查网络设置或重试"];
            }
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
