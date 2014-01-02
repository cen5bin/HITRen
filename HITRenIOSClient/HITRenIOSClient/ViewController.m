//
//  ViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ViewController.h"
#import "TestHttpTransfer.h"
#import "TestUserSimpleLogic.h"
#import "TestMessageLogic.h"
#import "TestRelationship.h"
#include "User.h"
#import "UserSimpleLogic.h"
#import "RelationShip.h"
#import "RelationshipLogic.h"
#import "MessageLogic.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    testAsyncRequest();
//    testUserSimpleLogic();
//    testSendShortMessage();
//    registerSomeUsers();
    testSendShortMessageToGroups();
//    for (int i = 40; i < 50; i++)
//        testConcernUser(i);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender {
    User *user = [[User alloc] init];
    user.email = self.email.text;
    user.password = self.password.text;
    UserSimpleLogic *logic = [[UserSimpleLogic alloc] initWithUser:user];
    [logic login];
}
@end
