//
//  FriendInfoViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FriendInfoViewController.h"

@interface FriendInfoViewController ()

@end

@implementation FriendInfoViewController

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
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    
    _cells = [[NSMutableArray alloc] initWithObjects:self.mainCell, self.usernameCell, self.sexCell, self.birthdayCell, self.hometownCell, nil];
    
    self.email.text = [self.data objectForKey:@"email"];
    self.username.text = [self.data objectForKey:@"name"];
    if (![[self.data allKeys] containsObject:@"sex"])
        self.sex.text = @"未设置";
    else
        self.sex.text = ([[self.data objectForKey:@"sex"] intValue] == 1)?@"♂":@"♀";
    if (![[self.data allKeys] containsObject:@"birthday"])
        self.birthday.text = @"未设置";
    else
        self.birthday.text = [self.data objectForKey:@"birthday"];
    if (![[self.data allKeys] containsObject:@"hometown"])
        self.birthday.text = @"未设置";
    else
        self.birthday.text = [self.data objectForKey:@"hometown"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cells objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_cells objectAtIndex:indexPath.row];
    return cell.bounds.size.height;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
            self.topBar.image = image;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
