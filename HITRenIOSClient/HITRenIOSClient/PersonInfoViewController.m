//
//  PersonInfoViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UserInfo.h"
#import "AppData.h"
#import "UploadLogic.h"
#import <QuartzCore/QuartzCore.h>
#import "ChatViewController.h"
#import "RelationshipLogic.h"
#import "ChooseGroupViewController.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

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
    _cells = [NSMutableArray arrayWithObjects:self.usernameCell, self.sexCell, self.birthdayCell, self.hometownCell, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.usernameLabel.text = self.userInfo.username;
    self.sexLabel.text = [self.userInfo.sex intValue] == 1?@"♂":@"♀";
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd";
    self.birthdayLabel.text = [formater stringFromDate:self.userInfo.birthday];
    self.hometownLabel.text = self.userInfo.hometown;
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    
    self.sendMessageButton.layer.cornerRadius = 5;
    self.concernButton.layer.cornerRadius = 5;
    
    self.concerned = [RelationshipLogic uidIsConcerned:[self.userInfo.uid intValue]];
    [self updateConcernButton];
    
    _choosingGroup = NO;
}

- (void)updateConcernButton {
    [self.concernButton setTitle:self.concerned?@"取消关注":@"关注Ta" forState:UIControlStateNormal];
    self.concernButton.backgroundColor = self.concerned ? [UIColor darkGrayColor] : GREEN_BUTTON_BACKGROUNF;

}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_CONCERNUSER])
        [self userDidConcerned:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DELETECONCERNEDUSER])
        [self userDidDisConncerned:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCONTACT])
        [self contactDidDownload:notification];
}

- (void)contactDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    
    if ([[dic objectForKey:@"SUC"] boolValue]) {
        [RelationshipLogic unPackRelationshipInfoData:[dic objectForKey:@"DATA"]];
        self.concerned = [RelationshipLogic uidIsConcerned:[self.userInfo.uid intValue]];
        [self updateConcernButton];

    }

}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    self.pic.image = image;
    [self.tableView reloadData];
}

- (void)userDidConcerned:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) {
        self.concerned = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:CONCERNEDINFO_CHANGED object:nil userInfo:@{@"uid":self.userInfo.uid, @"concerned":[NSNumber numberWithBool:YES]}];
    }
    [self updateConcernButton];
    
}

- (void)userDidDisConncerned:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) {
        self.concerned = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:CONCERNEDINFO_CHANGED object:nil userInfo:@{@"uid":self.userInfo.uid, @"concerned":[NSNumber numberWithBool:NO]}];
    }
    [self updateConcernButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
    UserInfo *userInfo = self.userInfo;
    AppData *appData = [AppData sharedInstance];
    if (userInfo.pic && ![userInfo.pic isEqualToString:@""]) {
        if (!userInfo.pic||!userInfo.pic.length)
            self.pic.image = [UIImage imageNamed:@"empty.png"];
        else if ([[userInfo.pic substringToIndex:1] isEqualToString:@"h"])
            self.pic.image = [UIImage imageNamed:userInfo.pic];
        else {
            UIImage *image = [appData getImage:userInfo.pic];
            if (image)self.pic.image = image;
            else if (![_downloadingImageSet containsObject:userInfo.pic]) {
                [_downloadingImageSet addObject:userInfo.pic];
                [UploadLogic downloadImage:userInfo.pic from:NSStringFromClass(self.class)];
            }
        }
    }
    if (_choosingGroup) {
        _choosingGroup = NO;
        [RelationshipLogic concernUser:[self.userInfo.uid intValue] inGroup:[ChooseGroupViewController choosedGroupName] fromClass:NSStringFromClass(self.class)];
        //        if ([RelationshipLogic concernUser:[_writerInfoView.userInfo.uid intValue] inGroup:[ChooseGroupViewController choosedGroupName]]) {
        //            _writerInfoView.concerned = YES;
        //            [_writerInfoView updateConcernedButton];
        //        }
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_managing) return;
    _managing = NO;
    NSString *choosedGname = [ChooseGroupViewController choosedGroupName];
    NSString *originGname = [RelationshipLogic gnameOfUid:[self.userInfo.uid intValue]];
    if ([choosedGname isEqualToString:originGname]) return;
    [RelationshipLogic moveUser:[self.userInfo.uid intValue] fromGroup: originGname toGroups:[NSArray arrayWithObjects:choosedGname, nil]];
//    [RelationshipLogic mo]
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cells objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
}

- (IBAction)moreButtonClicked:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"移动到分组", nil, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        _managing = YES;
        UIViewController *controller = getViewControllerOfName(@"ChooseGroup");
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)buttonTouchDown:(id)sender {
    if (sender == self.sendMessageButton) {
        self.sendMessageButton.backgroundColor = BLUE_BUTTON_BACKGROUNF1;
    }
    else if (sender == self.concernButton) {
        self.concernButton.backgroundColor = GREEN_BUTTON_BACKGROUNF1;
    }
}

- (void)clearButton {
    self.sendMessageButton.backgroundColor = BLUE_BUTTON_BACKGROUNF;
    self.concernButton.backgroundColor = GREEN_BUTTON_BACKGROUNF;
}

- (IBAction)buttonClicked:(id)sender {
    if (sender == self.sendMessageButton) {
        if (self.fromChatView) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        ChatViewController *controller = getViewControllerOfName(@"ChatView");
        controller.userInfo = self.userInfo;
        controller.fromPersonInfoView = YES;
        self.sendMessageButton.backgroundColor = BLUE_BUTTON_BACKGROUNF1;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (sender == self.concernButton) {
        if (self.concerned) {
            [RelationshipLogic asyncDeleteConcernedUser:[self.userInfo.uid intValue] fromClass:NSStringFromClass(self.class)];
            }
        else {
            self.concernButton.backgroundColor = GREEN_BUTTON_BACKGROUNF1;
            UIViewController *controller = getViewControllerOfName(@"ChooseGroup");
            _choosingGroup = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
    [self performSelector:@selector(clearButton) withObject:nil afterDelay:0.1];
}
@end
