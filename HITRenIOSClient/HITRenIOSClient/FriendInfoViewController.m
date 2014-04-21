//
//  FriendInfoViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "GroupChooserViewController.h"
#import "RelationshipLogic.h"

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
        else if (p.x >= self.view.frame.size.width - 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;

            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:@"复制到分组", @"移动到分组", @"从分组删除", @"拉入黑名单",nil, nil];
            [sheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    LOG(@"%d", buttonIndex);
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
    if (buttonIndex == 0 || buttonIndex == 5) return;
    if (buttonIndex == 4) {
        return;
    }
    GroupChooserViewController *controller = getViewControllerOfName(@"GroupChooser");
    controller.flag = buttonIndex;
    controller.uid = [[self.data objectForKey:@"uid"] intValue];
    controller.gname = self.gname;
    if (buttonIndex == 3) {
        controller.groups = [self calGroupsOfUser:controller.uid include:YES];
    }
    else {
        controller.groups = [self calGroupsOfUser:controller.uid include:NO];
    }
    
    [self.navigationController pushViewController:controller animated:YES];

}

- (NSMutableArray *)calGroupsOfUser:(int)uid include:(BOOL) include{
    FUNC_START();
    User *user = [RelationshipLogic user];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if ([RelationshipLogic downloadInfo]) {
        for (NSDictionary *dic in user.relationShip.concerList)
            if ([[dic objectForKey:@"userlist"] containsObject:[NSNumber numberWithInt:uid]] ^ (!include))
                [res addObject:[dic objectForKey:@"gname"]];
    }
    FUNC_END();
    return res;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
