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

- (IBAction)login:(id)sender {
    User *user = [[User alloc] init];
    user.email = [self.email.text copy];
    LOG(@"%@",user.email);
    user.password = [self.password.text copy];
    LOG(@"%@",user.password);
    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
    if ([logic login]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:user.email forKey:@"email"];
        [userDefaults setValue:user.password forKey:@"password"];
        [userDefaults setInteger:user.uid forKey:@"uid"];
        [userDefaults synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        
        MainViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"mainview3"];
        [self.navigationController pushViewController:controller animated:YES];
//        [self pushViewController:controller animated:YES];
//        [self prese]
//        [self presentViewController:controller animated:YES completion:nil];
    }
}
@end
