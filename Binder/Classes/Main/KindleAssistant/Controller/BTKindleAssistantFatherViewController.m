//
//  BTKindleAssistantFatherViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/24.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTKindleAssistantFatherViewController.h"
#import "BTKindleAssistantViewController.h"
#import "BTBaseWebViewController.h"


@interface BTKindleAssistantFatherViewController ()<UIActionSheetDelegate>
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UINavigationController *kindleVCNAV;

@end

@implementation BTKindleAssistantFatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  
    
    
    BTKindleAssistantViewController *kindleVC = [[BTKindleAssistantViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _kindleVCNAV = [[UINavigationController alloc ]initWithRootViewController:kindleVC];
    _kindleVCNAV.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-35);
    [self addChildViewController:_kindleVCNAV];
    [self.view addSubview:_kindleVCNAV.view];
    
    //设置底部菜单栏
    
    
    CGFloat bottomViewHeight = 35;
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight - bottomViewHeight + 1, UIScreenWidth , bottomViewHeight)];
//    _bottomView.center = CGPointMake(UIScreenWidth * 0.5, UIScreenHeight - 0.5 * bottomViewHeight );
//    _bottomView.width = UIScreenWidth - 30 * 2;
//    _bottomView.height = bottomViewHeight;
    
    [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBackground"]]];
    
    
    UIButton *rssSendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width * 0.5 - 0.5 , bottomViewHeight)];
    [rssSendButton setTitle:@" RSS推送" forState:UIControlStateNormal];
    rssSendButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:12.0];
    [rssSendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rssSendButton addTarget:self action:@selector(rssSend) forControlEvents:UIControlEventTouchUpInside];
    [rssSendButton setImage:[UIImage imageNamed:@"cellBottom_0000_Street-Sign-[address,direction,location,road-sign,signpost,street-sign]"] forState:UIControlStateNormal];
    
    
    UIView *line = [[UIView alloc ] initWithFrame:CGRectMake(_bottomView.width * 0.5 - 0.5 , 0, 1, bottomViewHeight)];
    line.backgroundColor = [UIColor blackColor];
    
    UIButton *kindleBargainPriceButton = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.width * 0.5 +0.5, 0, _bottomView.width * 0.5 -0.5 , bottomViewHeight)];
    [kindleBargainPriceButton setTitle:@" kindle特价书" forState:UIControlStateNormal];
    kindleBargainPriceButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:12.0];

    [kindleBargainPriceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [kindleBargainPriceButton addTarget:self action:@selector(showKindleBargainPriceBookViewController) forControlEvents:UIControlEventTouchUpInside];
    [kindleBargainPriceButton setImage:[UIImage imageNamed:@"cellBottom_0001_Money-[account,balance,cash,coin,currency,dollar,financial,money,shopping]"] forState:UIControlStateNormal];
    
    [_bottomView addSubview:rssSendButton];
    [_bottomView addSubview:kindleBargainPriceButton];
    [_bottomView addSubview:line];
    
    [self.view addSubview:_bottomView];
    
    
    //监听搜索栏是否开始搜索
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBottomView) name:@"searchStart" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeBottomView) name:@"searchStopped" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showKindleBargainPriceBookViewController
{
    [self showWebViewControllerWithURLString:@"http://t.bookdna.cn/" title:@"kindle特价书"];
    
    
//    [UIApplication sharedApplication].keyWindow.rootViewController = bargainPriceBookNAV;
}

- (void)rssSend
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择RSS推送站点" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"狗耳朵",@"Kindle4rss",@"hikindle", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)changeBottomView
{
    _bottomView.hidden = YES;
    _kindleVCNAV.view.height = CGRectGetHeight(self.view.frame);
}

- (void)resumeBottomView
{
    _bottomView.hidden = NO;
    _kindleVCNAV.view.height = CGRectGetHeight(self.view.frame)-35;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self showWebViewControllerWithURLString:@"http://www.dogear.cn" title:@"狗耳朵"];

        }
            break;
        case 1:
        {
            [self showWebViewControllerWithURLString:@"https://kindle4rss.com" title:@"Kindle4rss"];

        }
            break;
        case 2:
        {
            [self showWebViewControllerWithURLString:@"http://www.hikindle.com/" title:@"hikindle"];

        }
            break;
        default:
            break;
    }
}

- (void)showWebViewControllerWithURLString:(NSString *)urlString title:(NSString *)title
{
    BTBaseWebViewController *baseWebViewVC = [[BTBaseWebViewController alloc] init];
    [baseWebViewVC loadWithURLString:urlString title:title isRequest:NO];
    [self presentViewController:baseWebViewVC animated:YES completion:^{
        
    }];
}

@end
