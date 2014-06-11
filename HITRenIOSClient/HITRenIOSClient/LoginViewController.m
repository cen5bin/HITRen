//
//  LoginViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-25.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "LoginViewController.h"
#import "UserSimpleLogic.h"
#import "User.h"
#import "AppData.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self.navigationController setNavigationBarHidden:YES];
//    return;
//    [DBController sharedInstance];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [userDefaults objectForKey:@"email"];
    NSString *password = [userDefaults objectForKey:@"password"];
    
    if (!email || [email isEqualToString:@""]||!password || [password isEqualToString:@""])
        return;
    User* user = [UserSimpleLogic user];
    user.email = email;
    user.password = password;
    
    if ([UserSimpleLogic login]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:user.email forKey:@"email"];
        [userDefaults setValue:user.password forKey:@"password"];
        [userDefaults setInteger:user.uid forKey:@"uid"];
        LOG(@"fuck uid %d", user.uid);
        [userDefaults synchronize];
        
        AppData *appData = [AppData sharedInstance];
        NSString *name = @"mainview3";
        MainViewController *controller = nil;
        if (![appData.viewControllerDic objectForKey:name]) {
            controller = getViewControllerOfName(@"mainview3");
            [appData.viewControllerDic setObject:controller forKey:name];
        }
        else controller = [appData.viewControllerDic objectForKey:name];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
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

- (IBAction)login:(id)sender {
    User *user = [UserSimpleLogic user];
    user.email = self.email.text;
    user.password = self.password.text;
//    UserSimpleLogic *logic = [[UserSimpleLogic alloc] init];
    if ([UserSimpleLogic login]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:user.email forKey:@"email"];
        [userDefaults setValue:user.password forKey:@"password"];
        [userDefaults setInteger:user.uid forKey:@"uid"];
//        LOG(@"fuck uid %d", user.uid);
        [userDefaults synchronize];
        [self.email resignFirstResponder];
        [self.password resignFirstResponder];
        MainViewController *controller = getViewControllerOfName(@"mainview3");
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
