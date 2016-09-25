//
//  BTSpecialBookAccountTableViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/16.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBargainPriceBookViewController.h"
@interface BTBargainPriceBookViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIButton *backItemCustomView;
@property (nonatomic,strong) UIButton *forwardItemCustomView;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation BTBargainPriceBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //定制UIToolBar
    UIToolbar *navToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, UIScreenWidth, 44)];
    navToolBar.backgroundColor = [UIColor blackColor];
    navToolBar.alpha = 0.8;
    //toolbar定制item
    
    //后退按钮
    _backItemCustomView = [[UIButton alloc] init];
    _backItemCustomView.frame = CGRectMake(0, 0, 34, 34);
    [_backItemCustomView setImage:[UIImage imageNamed:@"back"] forState:UIControlStateDisabled];
    [_backItemCustomView setImage:[UIImage imageNamed:@"back_highlighted"] forState:UIControlStateNormal];
    [_backItemCustomView addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    _backItemCustomView.enabled = NO;

    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backItemCustomView];
    
    //前进按钮
    _forwardItemCustomView = [[UIButton alloc] init];
    _forwardItemCustomView.frame = CGRectMake(0, 0, 34, 34);
    [_forwardItemCustomView setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateDisabled];
    [_forwardItemCustomView setImage:[UIImage imageNamed:@"forward _highlighted"] forState:UIControlStateNormal];
     [_forwardItemCustomView addTarget:self action:@selector(toForward) forControlEvents:UIControlEventTouchUpInside];
    _forwardItemCustomView.enabled = NO;

    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithCustomView:_forwardItemCustomView];
    
    
    //标题label
    UILabel *titleItemCustomView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 34)];
    titleItemCustomView.textAlignment = NSTextAlignmentCenter;
    titleItemCustomView.text = @"kindle特价书";
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleItemCustomView];
    
    //首页按钮

    UIButton *homeItemCustomView = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [homeItemCustomView setImage:[UIImage imageNamed:@"tabbar_home"] forState:UIControlStateNormal];
    [homeItemCustomView addTarget:self action:@selector(toHome) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeItemCustomView];
    
    // 关闭按钮
    UIButton *closeItemCustomView = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [closeItemCustomView setImage:[UIImage imageNamed:@"cancel_highlighted"] forState:UIControlStateNormal];
    [closeItemCustomView addTarget:self action:@selector(toClose) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeItemCustomView];
    
    
    [navToolBar setItems:@[backItem,forwardItem,titleItem,homeItem,closeItem]];
    
    [self.view addSubview:navToolBar];
    [self.view bringSubviewToFront:navToolBar];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
     _webView.frame = CGRectMake(0, CGRectGetMaxY(navToolBar.frame), UIScreenWidth, UIScreenHeight - navToolBar.height);
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] init];
    _indicatorView.center = CGPointMake(UIScreenWidth * 0.5, UIScreenHeight * 0.25);
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _indicatorView.width = 60;
    _indicatorView.height = 60;
    _indicatorView.hidesWhenStopped = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"http://t.bookdna.cn/"];
        NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
       
        [_webView loadHTMLString:htmlString baseURL:url];
    });
    
   
    


}

- (void)toBack
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (void)toForward
{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (void)toHome
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"http://t.bookdna.cn/"];
        NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        
        [_webView loadHTMLString:htmlString baseURL:url];
    });
}

- (void)toClose
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _backItemCustomView.enabled = _webView.canGoBack;
        _forwardItemCustomView.enabled = _webView.canGoForward;
    });
    [self.view addSubview:_indicatorView];
    [_indicatorView startAnimating];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
