//
//  MainViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-25.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    LOG(@"%@", [self.topToolBar description]);
    LOG(@"%@", [self.btmToolBar description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    FUNC_START();
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.btmToolBar.frame, point)) {
        int index = [self.btmToolBar calIndex:point];
        UIViewController *controller = getViewControllerOfName([NSString stringWithFormat:@"mainview%d", index]);
        UINavigationController *navigateController = self.navigationController;
        if (index != 5)
            [self.navigationController popViewControllerAnimated:NO];
        [navigateController pushViewController:controller animated:NO];
    }
    
    FUNC_END();
}

@end
