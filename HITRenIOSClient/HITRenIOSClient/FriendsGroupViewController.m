//
//  FriendsGroupViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FriendsGroupViewController.h"
#import "User.h"
#import "RelationshipLogic.h"
#import "RelationShip.h"
#import "FriendsListViewController.h"



@interface FriendsGroupViewController ()

@end

@implementation FriendsGroupViewController

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
    _groups = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    FUNC_START();
    [super viewDidAppear:animated];
    [NSThread detachNewThreadSelector:@selector(startActivityIndicator) toTarget:self withObject:nil];
    
    User *user = [RelationshipLogic user];
//    user.uid = 33;//[[userDefaults objectForKey:@"uid"] intValue];

    if ([RelationshipLogic downloadInfo]) {
        _groups = user.relationShip.concerList;
        [self.tableView reloadData];
        for (id data in _groups) L([data objectForKey:@"gname"]);
        [self.activityIndicator stopAnimating];
    }
    FUNC_END();
}

- (void)startActivityIndicator {
    [self.activityIndicator startAnimating];
}

- (void)downloadGroupsInfo {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"groupcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSDictionary *dic = [_groups objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"gname"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d个好友", [[dic objectForKey:@"userlist"] count]];
//    cell.accessoryView.alpha = 0.5;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int index = [self.tableView indexPathForCell:sender].row;
    FriendsListViewController *controller = segue.destinationViewController;
    controller.uids = [[_groups objectAtIndex:index] objectForKey:@"userlist"];
    controller.gname = [[_groups objectAtIndex:index] objectForKey:@"gname"];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
