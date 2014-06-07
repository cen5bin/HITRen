//
//  ChooseGroupViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ChooseGroupViewController.h"
#import "TextBox.h"
#import "MyActivityIndicatorView.h"
#import "RelationshipLogic.h"
#import "RelationShip.h"
#import "User.h"

@interface ChooseGroupViewController ()

@end

static NSString *choosedGroupName = nil;
@implementation ChooseGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (NSString *)choosedGroupName {
    return choosedGroupName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
//    self.tableView.editing = YES;
    _myActivityIndicator = getViewFromNib(@"MyActivityIndicatorView", self);
    _selectedIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    UIView *view = [self getActivityIndicator];
    //    if (!view.superview)
    //        [self.view addSubview:view];
    _myActivityIndicator.textLabel.text = @"正在加载";
    [_myActivityIndicator showInView:self.view];
    [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCONTACT])
        [self contactDidDownload:notification];
}

- (void)loadData {
    User *user = [RelationshipLogic user];
    _data = [[NSMutableArray alloc] init];
    for (NSDictionary *tmp in user.relationShip.concerList) {
        if ([[tmp objectForKey:@"gname"] isEqualToString:@"ALL"]) continue;
        [_data addObject:tmp];
    }
    //    _data = [[NSMutableArray alloc] initWithArray:user.relationShip.concerList];
    
    [self.tableView reloadData];
}
- (void)contactDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    
    if ([[dic objectForKey:@"SUC"] boolValue]) {
        [RelationshipLogic unPackRelationshipInfoData:[dic objectForKey:@"DATA"]];
        
    }
    [self loadData];
    [_myActivityIndicator hide];
//    [self hideTopActivityIndicator];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifirt = @"GroupNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifirt forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifirt];
    NSString *gname = [[_data objectAtIndex:indexPath.row] objectForKey:@"gname"];
    if ([gname isEqualToString:@"default"]) gname = @"默认分组";
    cell.textLabel.text = gname;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    if (indexPath.row == _selectedIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    choosedGroupName = [[_data objectAtIndex:indexPath.row] objectForKey:@"gname"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    [tableView reloadData];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        else if (p.x > CGRectGetMaxX(self.topBar.frame)-50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base5" ofType:@"png"]];
            self.topBar.image = image;
            //            UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
            //            view.backgroundColor = [UIColor blackColor];
            //            view.alpha = 0.6;
            //            [self.view addSubview:view];
            TextBox *textBox = getViewFromNib(@"textbox", self);
            textBox.textLabel.text = @"请输入分组名称:";
            textBox.delegate = self;
            [textBox showInView:self.view];
            [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
        }
    }
    
}

- (void)textBox:(TextBox *)textBox buttonClickedAtIndex:(int)index {
    if (index == 0) {
        NSString *gname = textBox.textView.text;
        for (NSDictionary *dic in _data) {
            if ([[dic objectForKey:@"gname"] isEqualToString:gname]) {
                alert(@"错误", @"该分组名称已存在", self);
                return;
            }
        }
        [textBox hide];
        [_myActivityIndicator hide];
        [_myActivityIndicator showInView:self.view];
        if ([RelationshipLogic addGroup:gname])
            [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
    }
}

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base3" ofType:@"png"]];
    self.topBar.image = image;
}

@end
