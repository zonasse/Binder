//
//  BTProfileViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/9/21.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTProfileViewController.h"
@interface BTProfileViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *accountCell;
//@property (weak, nonatomic) IBOutlet UILabel *userEmail;
//@property (weak, nonatomic) IBOutlet UILabel *kindleEmail;
//- (IBAction)changeKindleEmail:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *kindleEmailCellLabel;


@property (nonatomic,strong) UIView *cover;
//@property (nonatomic,strong) BTContainerViewController *containerVC;
@end

@implementation BTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
//    _containerVC = [SB instantiateViewControllerWithIdentifier:@"containerVC"];
//    _containerVC.view.height = 264;
//    [self.containerView addSubview:_containerVC.view];
    
    BmobUser *user = [BmobUser currentUser];
    _accountCell.textLabel.text = user.email;
    _accountCell.textLabel.textColor = [UIColor colorWithRed:228/256.0 green:181/256.0 blue:15/256.0 alpha:1.0];
    
    _kindleEmailCellLabel.text = [user objectForKey:@"kindleEmail"];
    _kindleEmailCellLabel.adjustsFontSizeToFitWidth = YES;

    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入要更改的kindle邮箱地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
    }else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0://推送需知
            {
                _cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
                _cover.backgroundColor = [UIColor lightGrayColor];
                _cover.alpha = 0.95;
                
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, UIScreenWidth - 20, UIScreenHeight - 20 - 88) ];
//                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                
                textView.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"guide.txt" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
                textView.editable = NO;
                
                UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(textView.frame) + 10, UIScreenWidth - 120, 44)];
                closeButton.backgroundColor = [UIColor colorWithRed:237/256.0 green:215/256.0 blue:176/256.0 alpha:1.0];
                
                [closeButton setTitle:@"确定" forState:UIControlStateNormal];
                [closeButton addTarget:self action:@selector(closeCover) forControlEvents:UIControlEventTouchUpInside];
                
                [_cover addSubview:textView];
                [_cover addSubview:closeButton];
                
                [ShareApp.window addSubview:_cover];
                
            }
                break;
            case 1://小工具
            {
                
            }
                break;
                
            case 2://找不到书？反馈
            {
                
            }
                break;
            case 3://关于作者
            {
                
            }
                break;
            case 4://设置
            {
                
            }
                break;
                
            case 5://注销
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 1;
                [alertView show];
                
                
                
            }
                break;
            default:
                break;
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
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
                    _kindleEmailCellLabel.text = [NSString stringWithFormat:@"kindle邮箱:%@",[user objectForKey:@"kindleEmail"]];
                }else{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"更改失败，请稍后重试"];
                }
            }];
        }
    }else if (alertView.tag == 1)
    {
        if (buttonIndex == 1) {
            [BmobUser logout];
            //加载登录注册界面
            UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
            BTSignInViewController *signInVC = signInAndUpSB.instantiateInitialViewController;
            [ShareApp.window.rootViewController presentViewController:signInVC animated:YES completion:^{
                
            }];
        }
    }
    
   
    
    
 
}

- (void)closeCover
{
    [_cover removeFromSuperview];
}

@end
