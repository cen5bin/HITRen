//
//  FriendsListViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FriendsListViewController.h"
#import "RelationshipLogic.h"
#import "FriendInfoViewController.h"

@interface FriendsListViewController ()

@end

@implementation FriendCell



@end

@implementation FriendsListViewController

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
    [self.activityIndicator startAnimating];
}

- (void)startActivityIndicator {
    [self.activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSThread detachNewThreadSelector:@selector(startActivityIndicator) toTarget:self withObject:nil];
    if (self.uids && self.uids.count)
    _friends = [RelationshipLogic downloadFriendsInfo:self.uids];
    if (!_friends) _friends = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendcell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSDictionary *dic = [_friends objectAtIndex:indexPath.row];
    cell.userame.text = [dic objectForKey:@"name"];
    if (![[dic allKeys] containsObject:@"sex"])
        cell.sex.text = @"未设置";
    else cell.sex.text = ([[dic objectForKey:@"sex"] intValue] == 1)?@"♂":@"♀";
//    NSDictionary *dic = [_friends objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dic objectForKey:@"name"];
    //    cell.accessoryView.alpha = 0.5;
    return cell;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int index = [self.tableView indexPathForCell:sender].row;
    FriendInfoViewController *controller = segue.destinationViewController;
    NSDictionary *dic = [_friends objectAtIndex:index];
    controller.data = dic;
    controller.gname = self.gname;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
