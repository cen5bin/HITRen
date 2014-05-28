//
//  ToolsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ToolsViewController.h"

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

@end
