//
//  ManageGroupViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ManageGroupViewController.h"
#import "RelationShip.h"
#import "RelationshipLogic.h"
#import "MyActivityIndicatorView.h"
#import "TextBox.h"

@interface ManageGroupViewController ()

@end

@implementation ManageGroupViewController

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
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", ASYNCDATALOADED, CLASS_NAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:notificationName object:nil];
    self.tableView.editing = YES;
    _myActivityIndicator = getViewFromNib(@"MyActivityIndicatorView", self);
    _tappedViews = [[NSMutableDictionary alloc] init];
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
    [self hideTopActivityIndicator];
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
    if ([gname isEqualToString:@"default"]) gname = @"默认分组(不可修改)";
    cell.textLabel.text = gname;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    if (![_tappedViews objectForKey:indexPath]&&indexPath.row) {
        CGRect rect = cell.contentView.frame;
//        rect.origin.x += 50;
//        rect.size.width -= 50;
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [view addGestureRecognizer:gesture];
        [cell.contentView addSubview:view];
        [_tappedViews setObject:view forKey:indexPath];
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    TextBox *textBox = getViewFromNib(@"textbox", self);
    textBox.textLabel.text = @"请输入新的分组名称:";
    textBox.delegate = self;
    
    for (NSIndexPath *indexPath in [_tappedViews allKeys]) {
        if (gesture.view == [_tappedViews objectForKey:indexPath]) {
            NSString *gname = [[_data objectAtIndex:indexPath.row] objectForKey:@"gname"];
            textBox.textView.text = gname;
            _gname = gname;
            [textBox.textView setSelectedRange:NSMakeRange(0, gname.length)];
            break;
        }
    }
    _modify = YES;
    [textBox showInView:self.view];
//    NSString *gname = @"asd";//[[_data objectAtIndex:indexPath.row] objectForKey:@"gname"];
//    textBox.textView.text = gname;
//    [textBox.textView setSelectedRange:NSMakeRange(0, gname.length)];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deletingGroup = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"删除该分组后，分组内好友会被移动到默认分组" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) return;
//    TextBox *textBox = getViewFromNib(@"textbox", self);
//    textBox.textLabel.text = @"请输入新的分组名称:";
//    textBox.delegate = self;
//    [textBox showInView:self.view];
//    NSString *gname = [[_data objectAtIndex:indexPath.row] objectForKey:@"gname"];
//    textBox.textView.text = gname;
//    [textBox.textView setSelectedRange:NSMakeRange(0, gname.length)];
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_myActivityIndicator hide];
        _myActivityIndicator.textLabel.text = @"正在删除";
        [_myActivityIndicator showInView:self.view];
        if ([RelationshipLogic deleteGroup:_deletingGroup])
            [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
        else L(@"delete error");
//        view.hidden = YES;
    }
    else {
        L(@"取消");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.view.frame)-len / 2, len, len, len);
    }
    _activityIndicator.hidden = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}



- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
            TextBox *textBox = getViewFromNib(@"textbox", self);
            textBox.textLabel.text = @"请输入分组名称:";
            textBox.delegate = self;
            _modify = NO;
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
        if (!_modify) {
            if ([RelationshipLogic addGroup:gname])
                [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
        }
        else {
            if ([RelationshipLogic renameGroup:_gname newName:gname])
                [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
        }
    }
}

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base3" ofType:@"png"]];
    self.topBar.image = image;
}

- (UIView *)getMyActivityIndicatorView:(NSString *)text {
    if (!_myActivityIndicator) {
        _myActivityIndicator = getViewFromNib(@"MyActivityIndicatorView", self);
//        _myActivityIndicator.center =  self.view.center;
        CGRect rect = _myActivityIndicator.frame;
        rect.origin.y = 150;
        rect.origin.x = 0;//CGRectGetMidX(self.view.frame) - rect.size.width/2;
        _myActivityIndicator.frame = rect;
    }
    _myActivityIndicator.hidden = NO;
    
    if (text) _myActivityIndicator.textLabel.text = text;
//    UIView *view = [[UIView alloc] initWithFrame:self.view.window.frame];
//    view.backgroundColor = [UIColor blackColor];
//    view.alpha = 0.5;
    return _myActivityIndicator;
}

@end
