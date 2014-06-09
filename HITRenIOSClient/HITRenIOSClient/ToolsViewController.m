//
//  ToolsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ToolsViewController.h"
#import "AppData.h"

@interface ToolsViewController ()

@end

@implementation ToolsViewController

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
    FUNC_START();
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:self.secondHandCell, self.lookForCell, nil];
    _data = [[NSMutableArray alloc] initWithObjects:section0, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BACKGROUND_COLOR;//[UIColor colo]
    FUNC_END();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [[_data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIViewController *controller = nil;
    AppData *appData = [AppData sharedInstance];
    if (cell == self.secondHandCell) {
        NSString *name = @"SecondHand";
        if ([appData.viewControllerDic objectForKey:name])
            controller = [appData.viewControllerDic objectForKey:name];
        else {
            controller = getViewControllerOfName(@"SecondHand");
            [appData.viewControllerDic setObject:controller forKey:name];
        }
    }
    else {
        NSString *name = @"FindThings";
        if ([appData.viewControllerDic objectForKey:name])
            controller = [appData.viewControllerDic objectForKey:name];
        else {
            controller = getViewControllerOfName(name);
            [appData.viewControllerDic setObject:controller forKey:name];
        }
//[[NSNotificationCenter defaultCenter] removeobs]
//        controller = getViewControllerOfName(@"FindThings");
    }
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
