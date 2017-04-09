//
//  BTAdviceViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/15.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTAdviceViewController.h"

@interface BTAdviceViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UILabel *authorOrOtherInfoPlaceholdLabel;

@property (nonatomic,strong) UITextField *bookNameTextField;
@property (nonatomic,strong) UITextView *authorOrOtherInfo;
@property (nonatomic,strong) UITextView *otherAdviceText;
@end

@implementation BTAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}



//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //拿到第一响应者
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            if (subView == _otherAdviceText) {
                //获取键盘的高度
                NSDictionary *userInfo = [aNotification userInfo];
                NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
                CGRect keyboardRect = [aValue CGRectValue];
                int kbHeight = keyboardRect.size.height;
                
                //计算出键盘顶端到otherAdviceText底端的距离
                CGFloat offset = CGRectGetMaxY(_otherAdviceText.frame) + 20 - self.view.height + kbHeight;
                double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                if (offset > 0) {
                    [UIView animateWithDuration:duration animations:^{
                        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height) ;
                    }];
                }

            }
        }
    }
    
    }

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

    


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"反馈单";
    
    //后退按钮
    UIButton * backItemCustomView = [[UIButton alloc] init];
    backItemCustomView.frame = CGRectMake(0, 0, 34, 34);
    [backItemCustomView setImage:[UIImage imageNamed:@"back"] forState:UIControlStateDisabled];
    [backItemCustomView setImage:[UIImage imageNamed:@"back_highlighted"] forState:UIControlStateNormal];
    [backItemCustomView addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    backItemCustomView.enabled = NO;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backItemCustomView];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    NSMutableDictionary *submitItemAttr = [NSMutableDictionary dictionary];
    submitItemAttr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [submitItem setTitleTextAttributes:submitItemAttr forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = submitItem;
    
    
    
    UILabel *cantFindBook = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10, UIScreenWidth - 20, 34)];
    cantFindBook.text = @"找不到书籍?";
    cantFindBook.font = [UIFont systemFontOfSize:14.0];
    cantFindBook.textAlignment = NSTextAlignmentLeft;
    cantFindBook.textColor = [UIColor brownColor];
    
    _bookNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(cantFindBook.frame) , cantFindBook.width, 34)];
    _bookNameTextField.placeholder = @" 书名";
    _bookNameTextField.font = [UIFont systemFontOfSize:12.0];
    [_bookNameTextField setBackground:[UIImage imageNamed:@"profile_0001_Shape-7"]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 20)];
    _bookNameTextField.leftView = paddingView;
    
    _bookNameTextField.leftViewMode = UITextFieldViewModeAlways;

    
    
    _authorOrOtherInfo = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_bookNameTextField.frame) + 10, cantFindBook.width, 100)];
    UIImageView *authorOrOtherInfoImageView = [[UIImageView alloc] initWithFrame:[_authorOrOtherInfo bounds]];
    _authorOrOtherInfo.tag = 100;
    _authorOrOtherInfo.delegate = self;
    authorOrOtherInfoImageView.image = [UIImage imageNamed:@"profile_0001_Shape-7"];
    
    [_authorOrOtherInfo addSubview:authorOrOtherInfoImageView];
    [_authorOrOtherInfo sendSubviewToBack:authorOrOtherInfoImageView];
    
    _authorOrOtherInfoPlaceholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, -2, 200, 34)];
    _authorOrOtherInfoPlaceholdLabel.text = @"作者、格式或其他信息";
    _authorOrOtherInfoPlaceholdLabel.textColor = [UIColor lightGrayColor];
    _authorOrOtherInfoPlaceholdLabel.font = [UIFont systemFontOfSize:12.0];
    [_authorOrOtherInfo addSubview:_authorOrOtherInfoPlaceholdLabel];
    

    
    
    UILabel *otherAdvice = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_authorOrOtherInfo.frame) + 10, cantFindBook.width, 34)];
    otherAdvice.text = @"其他建议";
    otherAdvice.font = [UIFont systemFontOfSize:14.0];
    
    otherAdvice.textAlignment = NSTextAlignmentLeft;
    otherAdvice.textColor = [UIColor brownColor];
    
    _otherAdviceText = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(otherAdvice.frame) , cantFindBook.width, 100)];
    UIImageView *otherAdviceTextImageView = [[UIImageView alloc] initWithFrame:[_otherAdviceText bounds]];
    _otherAdviceText.delegate = self;
    
    otherAdviceTextImageView.image = [UIImage imageNamed:@"profile_0001_Shape-7"];
    
    [_otherAdviceText addSubview:otherAdviceTextImageView];
    [_otherAdviceText sendSubviewToBack:otherAdviceTextImageView];
    
    
    
    [self.view addSubview:cantFindBook];
    [self.view addSubview:_bookNameTextField];
    [self.view addSubview:_authorOrOtherInfo];
    [self.view addSubview:otherAdvice];
    [self.view addSubview:_otherAdviceText];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)toBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    
//    if (textView.tag == 100) {
//        _authorOrOtherInfoPlaceholdLabel.hidden = YES;
//    }
//}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 100) {
        if (textView.text.length == 0) {
            _authorOrOtherInfoPlaceholdLabel.hidden = NO;

        }else{
            _authorOrOtherInfoPlaceholdLabel.hidden = YES;
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 100) {
        
        if (textView.text.length == 0) {
            _authorOrOtherInfoPlaceholdLabel.hidden = NO;
            
        }else{
            _authorOrOtherInfoPlaceholdLabel.hidden = YES;
        }
    }
}

- (void)submit
{
    if (_authorOrOtherInfo.text.length || _otherAdviceText.text.length ||_bookNameTextField.text.length) {
        [MBProgressHUD showMessage:@"处理中"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"提交成功,非常感谢您的支持"];
        });
        
    }else{
        [MBProgressHUD showError:@"请至少填写一项"];
        return;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
