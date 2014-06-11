//
//  MainViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-2-25.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MainViewController.h"
#import "MenuView.h"
#import "AppData.h"

@interface MainViewController ()

@end

static NSMutableDictionary *dic = nil;

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(asyncDataLoaded:) name:ASYNCDATALOADED object:nil];
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
        
        UIViewController *controller;
        AppData *appData = [AppData sharedInstance];
        NSString *name = [NSString stringWithFormat:@"mainview%d", index];
        if ([appData.viewControllerDic objectForKey:name])
            controller = [appData.viewControllerDic objectForKey:name];
        else {
            controller = getViewControllerOfName(name);
            [appData.viewControllerDic setObject:controller forKey:name];
//            [dic setObject:controller forKey:[NSString stringWithFormat:@"mainview%d", index]];
        }
        UINavigationController *navigateController = self.navigationController;
        if (index != 5)
            [self.navigationController popViewControllerAnimated:NO];
        [navigateController pushViewController:controller animated:NO];
    }
//    else if (CGRectContainsPoint(self.topToolBar.frame, point)) {
//        if (point.x <= 50) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar2" ofType:@"png"]];
//            self.topToolBar.image = image;
////            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else if (point.x > CGRectGetMaxX(self.topToolBar.frame) - 50)
//            [self showMenu];
//    }
    FUNC_END();
}

- (void)showMenu {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar1" ofType:@"png"]];
    self.topToolBar.image = image;
    const int menuWidth = 120;
    if (!_menuView) {
        _menuView = [[MenuView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.topToolBar.frame)-menuWidth, CGRectGetMaxY(self.topToolBar.frame), menuWidth, 100)];
        _menuView.delegate = self;
    }
    if (!_menuView.superview)
        [self.view addSubview:_menuView];
}

- (void)hideMenu {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar0" ofType:@"png"]];
    self.topToolBar.image = image;
    if (!_menuView || !_menuView.superview) return;
    [_menuView removeFromSuperview];
}

- (void)asyncDataLoaded:(NSNotification *)notification {
    L(notification.object);
    L([notification.userInfo description]);
}

//- (void)menuDidChooseAtIndex:(int)index {
//    if (index == 0) {
//        UIViewController *controller = getViewControllerOfName(@"SendShortMessage");
//        [self presentViewController:controller animated:YES completion:^(void){}];
//        [self hideMenu];
//    }
//        
//}

@end
