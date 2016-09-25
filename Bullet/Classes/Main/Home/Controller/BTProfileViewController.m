//
//  BTProfileViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/21.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTProfileViewController.h"
#import "BTContainerViewController.h"
@interface BTProfileViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *kindleEmail;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)changeKindleEmail:(id)sender;

@property (nonatomic,strong) BTContainerViewController *containerVC;
@end

@implementation BTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
    _containerVC = [SB instantiateViewControllerWithIdentifier:@"containerVC"];
    _containerVC.view.height = 308;
    [self.containerView addSubview:_containerVC.view];
    
    BmobUser *user = [BmobUser currentUser];
    self.userEmail.text = [NSString stringWithFormat:@"当前登录:%@",user.email];
    self.kindleEmail.text = [NSString stringWithFormat:@"kindle邮箱:%@",[user objectForKey:@"kindleEmail"]];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)changeKindleEmail:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入默认kindle邮箱地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (kNetworkNotReachability) {
            [MBProgressHUD showError:@"网络故障,请稍后重试"];
            return;
        }
        BmobUser *user = [BmobUser currentUser];
        [user setObject: [alertView textFieldAtIndex:0].text forKey:@"kindleEmail"];
         [MBProgressHUD showMessage:@"更改中..."];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
           
            
            if (isSuccessful) {
                [MBProgressHUD hideHUD];

                [MBProgressHUD showSuccess:@"更改成功"];
                self.kindleEmail.text = [user objectForKey:@"kindleEmail"];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"更改失败，请稍后重试"];
            }
        }];
    }
}

@end
