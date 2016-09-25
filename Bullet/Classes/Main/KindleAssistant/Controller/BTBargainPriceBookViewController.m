//
//  BTSpecialBookAccountTableViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/16.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBargainPriceBookViewController.h"
@interface BTBargainPriceBookViewController ()

@end

@implementation BTBargainPriceBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.title = @"Kindle特价书";
    //正则表达式语句
    NSError *error;
    NSURL *url = [NSURL URLWithString:@"http://t.bookdna.cn/"];
    NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [webView loadHTMLString:htmlString baseURL:url];
    
    
    [self.view addSubview:webView];
}



- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
