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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    testAsyncRequest();
//    testUserSimpleLogic();
    testSendShortMessage();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
