//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import "LoginViewController.h"
#import "ICConfig.h"
#import "UIView+IC.h"
#import "AFWCommonUtils.h"
#import "UIColor+IC.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginUITextField.h"

static const float sidePadding = 30;

@interface LoginViewController ()
@property(nonatomic, strong) LoginUITextField *usernameTextField;
@property(nonatomic, strong) LoginUITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusBarHeight = rect.size.height;

//    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    navTitleLabel.text = @"登录";
//    navTitleLabel.textAlignment = NSTextAlignmentCenter;
//    navTitleLabel.font = [UIFont systemFontOfSize:18];
//    navTitleLabel.asCenterX = SCREEN_WIDTH / 2;
//    navTitleLabel.asCenterY = statusBarHeight + navTitleLabel.asHeight / 2;
//    [self.view addSubview:navTitleLabel];
//    [AFWCommonUtils addLineToView:self.view Horizontal:YES Position:CGPointMake(0, statusBarHeight + navTitleLabel.asHeight - 0.5) Length:SCREEN_WIDTH Height:0.5 Color:[UIColor colorWithHexRGB:@"dddddd"] ALPHA:1];

    float usernameTextLabelY = 250;
    if (!IS_IPHONE_4_OR_LESS) {
        UIImage *logoImage = [UIImage imageNamed:@"logo2"];
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
        CGFloat logoWidth = 70;
        logoImageView.frame = CGRectMake(0, 70, logoWidth, logoWidth);
        logoImageView.asCenterX = SCREEN_WIDTH / 2;
        [self.view addSubview:logoImageView];

        UILabel *logoTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoImageView.asBottom + 8, 50, 20)];
        logoTextLabel.text = @"灵感笔记";
        logoTextLabel.font = [UIFont systemFontOfSize:13];
        [logoTextLabel sizeToFit];
        logoTextLabel.asCenterX = SCREEN_WIDTH / 2;
        [self.view addSubview:logoTextLabel];
    } else {
        usernameTextLabelY = 80;
    }

    UIImage *usernameImage = [UIImage imageNamed:@"st_login_icon_account"];
    UIImageView *usernameImageView = [[UIImageView alloc] initWithImage:usernameImage];
    usernameImageView.frame = CGRectMake(30, usernameTextLabelY, usernameImageView.asWidth, usernameImageView.asHeight);
    [self.view addSubview:usernameImageView];

    _usernameTextField = [[LoginUITextField alloc] initWithFrame:CGRectMake(usernameImageView.asRight + 15, usernameTextLabelY, 200, usernameImageView.asHeight)];
    _usernameTextField.placeholder = @"请输入手机号";

    [self.view addSubview:_usernameTextField];
    [AFWCommonUtils addLineToView:self.view Horizontal:YES Position:CGPointMake(sidePadding, _usernameTextField.asBottom + 10) Length:(SCREEN_WIDTH - 2 * sidePadding) Height:0.5 Color:[UIColor colorWithHexRGB:@"dddddd"] ALPHA:1];

    UIImage *passwordImage = [UIImage imageNamed:@"st_login_icon_password"];
    UIImageView *passwordImageView = [[UIImageView alloc] initWithImage:passwordImage];
    passwordImageView.frame = CGRectMake(30, usernameTextLabelY + 40, passwordImageView.asWidth, passwordImageView.asHeight);
    [self.view addSubview:passwordImageView];


    _passwordTextField = [[LoginUITextField alloc] initWithFrame:CGRectMake(_usernameTextField.asLeft, usernameTextLabelY + 40, 200, passwordImageView.asHeight)];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"请输入密码";
    //[_passwordTextField setValue:placeHolderTextFont forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_passwordTextField];
    [AFWCommonUtils addLineToView:self.view Horizontal:YES Position:CGPointMake(sidePadding, _passwordTextField.asBottom + 10) Length:(SCREEN_WIDTH - 2 * sidePadding) Height:0.5 Color:[UIColor colorWithHexRGB:@"dddddd"] ALPHA:1];

    UILabel *forgetPwdTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _passwordTextField.asBottom + 15, 100, 20)];
    forgetPwdTextLabel.text = @"忘记密码";
    forgetPwdTextLabel.asRight = SCREEN_WIDTH - sidePadding;
    forgetPwdTextLabel.textAlignment = NSTextAlignmentRight;
    forgetPwdTextLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:forgetPwdTextLabel];

    UIColor *whiteColor = [UIColor whiteColor];
    UIColor *btnBgColor = [UIColor colorWithHexRGB:@"4A90E2"];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, forgetPwdTextLabel.asBottom + 25, (SCREEN_WIDTH - 2 * sidePadding), 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    loginBtn.asCenterX = SCREEN_WIDTH / 2;
    loginBtn.backgroundColor = btnBgColor;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, loginBtn.asBottom + 20, (SCREEN_WIDTH - 2 * sidePadding), 40)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    registerBtn.asCenterX = SCREEN_WIDTH / 2;
    registerBtn.backgroundColor = btnBgColor;
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat openIdY = SCREEN_HEIGHT - 120;
    [AFWCommonUtils addLineToView:self.view Horizontal:YES Position:CGPointMake(sidePadding, openIdY) Length:(SCREEN_WIDTH - 2 * sidePadding) Height:0.5 Color:[UIColor colorWithHexRGB:@"dddddd"] ALPHA:1];
    UILabel *openIdTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, registerBtn.asBottom + 20, 200, 20)];
    openIdTextLabel.text = @" 或用其他账号登录 ";
    [openIdTextLabel sizeToFit];
    openIdTextLabel.asCenterX = SCREEN_WIDTH / 2;
    openIdTextLabel.asCenterY = openIdY;
    openIdTextLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:openIdTextLabel];

    UIImage *qqImage = [UIImage imageNamed:@"login_btn_qq_nor"];
    UIImageView *qqImageView = [[UIImageView alloc] initWithImage:qqImage];
    CGFloat imageWidth = qqImageView.asWidth;
    CGFloat distance = (SCREEN_WIDTH - 3 * imageWidth) / 4;
    qqImageView.frame = CGRectMake(distance, openIdTextLabel.asBottom + 30, imageWidth, imageWidth);
    [self.view addSubview:qqImageView];

    UIImage *sinaImage = [UIImage imageNamed:@"login_btn_sina_nor"];
    UIImageView *sinaImageView = [[UIImageView alloc] initWithImage:sinaImage];
    sinaImageView.frame = CGRectMake(80, openIdTextLabel.asBottom + 30, imageWidth, imageWidth);
    sinaImageView.asCenterX = SCREEN_WIDTH / 2;
    [self.view addSubview:sinaImageView];

    UIImage *wechatImage = [UIImage imageNamed:@"login_btn_wechat_nor"];
    UIImageView *wechatImageView = [[UIImageView alloc] initWithImage:wechatImage];
    wechatImageView.frame = CGRectMake(140, openIdTextLabel.asBottom + 30, imageWidth, imageWidth);
    wechatImageView.asRight = SCREEN_WIDTH - distance;
    [self.view addSubview:wechatImageView];
}

- (void)clickBtn:(id)sender
{
    long i = [sender tag];
    NSLog(@"drag in side %ld", i);
}

- (void)loginBtnClick:(id)sender
{
    long i = [sender tag];
    NSLog(@"drag in side %ld", i);
    if (!_usernameTextField.text || _usernameTextField.text.length == 0) {
        // 用户名为空Toast

        return;
    } else if (!_passwordTextField.text || _passwordTextField.text.length == 0) {
        // 密码为空Toast

        return;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [manager GET:@"http://localhost:8080/user/login.do?username=wangzhaojun&password=123456"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *model = responseObject;
             NSString *code = [model objectForKey:@"code"];
             NSLog(@"code %@", code);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

@end