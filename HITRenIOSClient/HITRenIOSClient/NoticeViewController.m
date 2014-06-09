//
//  MessageViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "AppData.h"
#import "Notice.h"
#import "NoticeObject.h"
#import "NoticeViewBar.h"
#import <QuartzCore/QuartzCore.h>
#import "Message.h"
#import "Comment.h"
#import "LikedList.h"
#import "MessageDetailViewController.h"
#import "UserInfo.h"
#import "MessageLogic.h"
#import "ChatViewController.h"
#import "ContactView.h"
#import "UploadLogic.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

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
    
    self.flag = 0;
    AppData *appData = [AppData sharedInstance];
    
    _notices = appData.noticeLine;
    
    self.noticeViewBar.layer.borderWidth = 0.5;
    self.noticeViewBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    CGRect rect = self.scrollView.frame;
    self.scrollView.contentSize = CGSizeMake(rect.size.width * 3, rect.size.height);
    
    self.contactView.parentController = self;
    
    
    _noDataLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 30)];
    _noDataLabel1.text = @"暂时没有动态";
    _noDataLabel1.textAlignment = NSTextAlignmentCenter;
    _noDataLabel1.textColor = [UIColor lightGrayColor];
    
    _noDataLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 30)];
    _noDataLabel2.text = @"暂时没有对话";
    _noDataLabel2.textAlignment = NSTextAlignmentCenter;
    _noDataLabel2.textColor = [UIColor lightGrayColor];
    
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:XMPP_DATA_RECEIVED object:nil];
    
    FUNC_END();
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData activitiesAtIndex:0];
    NSArray *array = notice.notices;
    _activies = [[NSMutableArray alloc] init];
    for (id obj in array)
        [_activies insertObject:obj atIndex:0];

    [self.activityTableView reloadData];
    [self.noticeTableView reloadData];
    [self.contactView willLoad];
}

- (void)reloadData {
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData activitiesAtIndex:0];
    NSArray *array = notice.notices;
    _activies = [[NSMutableArray alloc] init];
    for (id obj in array)
        [_activies insertObject:obj atIndex:0];
    
    [self.activityTableView reloadData];
    [self.noticeTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.activityTableView) {
        int ret = _activies.count;
        if (!ret) {
            if (!_noDataLabel1.superview)
                [tableView addSubview:_noDataLabel1];
        }
        else if (_noDataLabel1.superview) [_noDataLabel1 removeFromSuperview];
        return _activies.count;
    }
    if (tableView == self.noticeTableView) {
        int ret = _notices.count;
        if (!ret) {
            if (!_noDataLabel2.superview)
                [tableView addSubview:_noDataLabel2];
        }
        else if (_noDataLabel2.superview) [_noDataLabel2 removeFromSuperview];

        return _notices.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndicator = @"NoticeCell";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndicator forIndexPath:indexPath];
    if (!cell)
        cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndicator];
    cell.contentView.layer.borderWidth = 0.5;
    CGFloat tmp = 220;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    
    AppData *appData = [AppData sharedInstance];
    
    UserInfo *userInfo = nil;
    if (tableView == self.activityTableView) {
        NoticeObject *object = [_activies objectAtIndex:indexPath.row];
        NSDictionary *dic = object.content;
        if (object.type == 1) {
            cell.username.text = [[dic objectForKey:@"by"] objectForKey:@"name"];
            int uid = [[[dic objectForKey:@"by"] objectForKey:@"uid"] intValue];
            userInfo = [appData readUserInfoForId:uid];
        }
        cell.lastNotice.text = [AppData stringOfNoticeObject:object];
    }
    else if (tableView == self.noticeTableView) {
        int uid = [[_notices objectAtIndex:indexPath.row] intValue];
        userInfo = [appData readUserInfoForId:uid];
        cell.username.text = userInfo.username;
        Notice *notice = [appData lastNoticeOfUid:uid];
        NoticeObject *obj = [notice.notices lastObject];
        L([obj.content description]);
        cell.lastNotice.text = [obj.content objectForKey:@"text"];
    }
    if (userInfo.pic && ![userInfo.pic isEqualToString:@""]) {
        if (!userInfo.pic||!userInfo.pic.length)
            cell.pic.image = [UIImage imageNamed:@"empty.png"];
        else if ([[userInfo.pic substringToIndex:1] isEqualToString:@"h"])
            cell.pic.image = [UIImage imageNamed:userInfo.pic];
        else {
            UIImage *image = [appData getImage:userInfo.pic];
            if (image) cell.pic.image = image;
            else if (![_downloadingImageSet containsObject:userInfo.pic]) {
                [_downloadingImageSet addObject:userInfo.pic];
                [UploadLogic downloadImage:userInfo.pic from:NSStringFromClass(self.class)];
            }
        }
    }

    
//    int uid = [[_data objectAtIndex:indexPath.row] intValue];
//    AppData *appData = [AppData sharedInstance];
//    Notice *notice = [appData lastNoticeOfUid:uid];
//    NoticeObject *object = [notice.notices lastObject];
//    NSDictionary *dic = object.content;
//    if (object.type == 1) {
//        cell.username.text = [[dic objectForKey:@"by"] objectForKey:@"name"];
//    }
//    cell.lastNotice.text = [appData lastNoticeStringOfUid:uid];
   
    return cell;
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self.activityTableView reloadData];
    [self.noticeTableView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (scrollView == self.scrollView) {
//        if (scrollView.contentOffset.x > 320 && scrollView.contentOffset.x < 640)
//            [self.contactView willLoad];
//        LOG(@"%f", scrollView.contentOffset.x);
        if (p.x <= 0) {p.x = 0;         [scrollView setContentOffset:p animated:NO];}
        else if (p.x>=640) {p.x = 640;         [scrollView setContentOffset:p animated:NO];}
        CGRect rect = self.colorView.frame;
        rect.origin.x = p.x / 3;
        self.colorView.frame = rect;
//        [scrollView setContentOffset:p animated:NO];
//        scrollView.contentOffset = p;
        return;
    }
    if (p.y < 0) p.y = 0;
    else if (p.y > scrollView.contentSize.height - scrollView.frame.size.height)
        p.y = scrollView.contentSize.height - scrollView.frame.size.height;
    if (p.y < 0) p.y = 0;
    scrollView.contentOffset = p;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x >=640)
            [self.contactView willLoad];
        [self scrollToIndex:scrollView.contentOffset.x/320];
        //        LOG(@"%f", scrollView.contentOffset.x);
        return;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.activityTableView) {
        NoticeObject *object = [_activies objectAtIndex:indexPath.row];
        NSDictionary *dic = object.content;
        NSDictionary *m = [dic objectForKey:@"message"];
        int mid = [[m objectForKey:@"mid"] intValue];
        [self showMessageDetailViewOfMid:mid];
    }
    else if (tableView == self.noticeTableView) {
        ChatViewController *controller = getViewControllerOfName(@"ChatView");
        AppData *appData = [AppData sharedInstance];
        int uid = [[appData.noticeLine objectAtIndex:indexPath.row] intValue];
        UserInfo *userInfo = [appData readUserInfoForId:uid];
        controller.userInfo = userInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 展示某条状态的详细信息
- (void)showMessageDetailViewOfMid:(int)mid {
    AppData *appData = [AppData sharedInstance];
    MessageDetailViewController *controller = getViewControllerOfName(@"MessageDetail");
    Message *message = [appData readMessageForId:mid];
    controller.message = message;
    LikedList *likedList = [appData getLikedListOfMid:mid];
    controller.likedList = [[NSMutableArray alloc] init];
    for (int i = likedList.userList.count - 1; i >= 0; i--)
    {
        NSNumber *uid = [likedList.userList objectAtIndex:i];
        UserInfo *userInfo0 = [appData readUserInfoForId:[uid intValue]];
        if (userInfo0.username)
            [controller.likedList addObject:userInfo0.username];
    }
    Comment *comment = [appData getCommentOfMid:mid];
    controller.commentList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in comment.commentList) {
        int uid = [[dic objectForKey:@"uid"] intValue];
        int reuid = [[dic objectForKey:@"reuid"] intValue];
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        UserInfo *userInfo1 = [appData readUserInfoForId:uid];
        if (!userInfo1) continue;
        [tmp setObject:userInfo1.username forKey:@"user"];
        if (reuid != -1) {
            UserInfo *userInfo2 = [appData readUserInfoForId:reuid];
            if (!userInfo2) continue;
            [tmp setObject:userInfo2.username forKey:@"reuser"];
        }
        [tmp setObject:[dic objectForKey:@"content"] forKey:@"content"];
        [controller.commentList addObject:tmp];
    }
    User *user = [MessageLogic user];
    if ([likedList.userList containsObject:[NSNumber numberWithInt:user.uid]])
        controller.liked = YES;
    else controller.liked = NO;
    [controller update];
    [controller updateCommentList];
    
    
    [self.navigationController pushViewController:controller animated:YES];
    

}

- (void)scrollToIndex:(int)index {
    static NSArray *array = nil;
    if (!array) array = [NSArray arrayWithObjects:self.activityButton,self.noticeButton,self.contactButton, nil];
    CGPoint p = self.scrollView.contentOffset;
    p.x = 320 * index;
    CGRect rect = [[array objectAtIndex:index] frame];
    CGRect rect1 = self.colorView.frame;
    rect1.origin.x = rect.origin.x;
    rect1.size.width = rect.size.width;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.colorView.frame = rect1;
    } completion:nil];
    
    [self.scrollView setContentOffset:p animated:YES];
}

- (IBAction)activityButtonClicked:(id)sender {
    [self scrollToIndex:0];
}

- (IBAction)noticeButtonClicked:(id)sender {
    [self scrollToIndex:1];
}

- (IBAction)contactButtonClicked:(id)sender {
    [self scrollToIndex:2];
}
@end
