//
//  RegisterViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "PersonViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (IBAction)signUp:(id)sender {
    if (self.email.text == nil || [self.email.text isEqualToString:@""]) {
        alert(@"错误", @"邮箱不能为空", self);
        return;
    }
    if (self.password.text == nil || self.password.text.length < 6) {
        alert(@"错误", @"密码不得小于6位", self);
        return;
    }
    if ([self.email.text rangeOfString:@"@"].location == NSNotFound) {
        alert(@"错误", @"邮箱格式不正确", self);
        return;
    }
    User *user = [UserSimpleLogic user];
    user.email = self.email.text;
    user.password = self.password.text;
    if ([UserSimpleLogic signUp]) {
        PersonViewController *controller = getViewControllerOfName(@"mainview5");
        controller.fromRegister = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:user.email forKey:@"email"];
        [userDefaults setObject:user.password forKey:@"password"];
        [userDefaults synchronize];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else {
        alert(@"错误", @"注册失败，请重试", self);
        self.email.text = @"";
        self.password.text = @"";
    }
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    FUNC_START();
//    L(@"segue");
//    FUNC_END();
//}

- (IBAction)comeBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
