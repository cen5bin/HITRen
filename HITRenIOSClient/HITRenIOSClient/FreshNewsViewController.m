//
//  FreshNewsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FreshNewsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShortMessageCell.h"
#import "MessageLogic.h"
#import "UserSimpleLogic.h"
#import "Timeline.h"
#import "DataManager.h"
#import "AppData.h"
#import "Message.h"
#import "UserInfo.h"
#import "UploadLogic.h"
#import "LikedList.h"

@interface FreshNewsViewController ()

@end

@implementation FreshNewsViewController

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
//    _data = [[NSMutableArray alloc] initWithObjects:@"asd", @"aaa", nil];
    _data = [[NSMutableArray alloc] init];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.tableView.decelerationRate = 0.5;
    _currentPage = 0;
    _maxDataLoadedPage = 0;
    _backgroubdLoadData = NO;
    _backgroubdLoadWorking = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    
    AppData *appData = [AppData sharedInstance];
    if (appData.timeline.mids.count == 0) {
        _moreMessageCell = 0;
        _updateAtTop = YES;
        _currentPage = 0;
        UIView *view = [self getActivityIndicator];
        if (!view.superview)
            [self.tableView addSubview:[self getActivityIndicator]];
        [self.tableView setContentOffset:CGPointMake(0, -35) animated:NO];
        [self beginToDownloadTimeline];
    }
    else _moreMessageCell = 1;
    
//    [UploadLogic uploadImages:[NSArray arrayWithObjects:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"empty" ofType:@"png"]],[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]], [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]],nil]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count + _moreMessageCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ShortMessageCell";
    static NSString *CellIdentifier1 = @"MoreMessageCell";
    if (indexPath.row == _data.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        return cell;
    }
    
    ShortMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[ShortMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    Message *message = [_data objectAtIndex:indexPath.row];
    cell.textView.text = message.content;
    
    AppData *appData = [AppData sharedInstance];
    UserInfo *userInfo = [appData readUserInfoForId:[message.uid intValue]];
    if (userInfo)
        cell.username.text = userInfo.username;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    cell.time.text = [format stringFromDate:message.time];
    
    cell.delegate = self;
    LikedList *likedList = [appData getLikedListOfMid:[message.mid intValue]];
    cell.likedList = [[NSMutableArray alloc] init];
    for (NSNumber *uid in likedList.userList) {
        UserInfo *userInfo0 = [appData readUserInfoForId:[uid intValue]];
        if (userInfo0.username)
            [cell.likedList addObject:userInfo0.username];

    }
    User *user = [UserSimpleLogic user];
    if ([likedList.userList containsObject:[NSNumber numberWithInt:user.uid]])
        cell.liked = YES;
    else
        cell.liked = NO;
    [cell update];
    
    // 调整cell中各个view的frame
    CGRect rect = cell.textView.frame;
    CGFloat height = rect.size.height;
    rect.size.height = [self calculateTextViewHeight:message.content];
    cell.textView.frame = rect;
    CGFloat tmp = rect.size.height - height;
    rect = cell.bgView.frame;
    rect.size.height += tmp;
    cell.bgView.frame = rect;
    rect = cell.cellBar.frame;
    rect.origin.y += tmp;
    cell.cellBar.frame = rect;
    
    rect = cell.likedListView.frame;
    rect.origin.y += tmp;
    cell.likedListView.frame = rect;
    
    rect = cell.commentListView.frame;
    rect.origin.y += tmp;
    cell.commentListView.frame = rect;
    
    if (cell.likedList.count == 0) {
        if (cell.likedListView.hidden) return cell;
        cell.likedListView.hidden = YES;
        rect = cell.commentListView.frame;
        rect.origin.y -= LIKEDLISTVIEW_HEIGHT;
        cell.commentListView.frame = rect;
        rect = cell.bgView.frame;
        rect.size.height -= LIKEDLISTVIEW_HEIGHT;
        cell.bgView.frame = rect;
    }
    else {
        if (!cell.likedListView.hidden) return cell;
        cell.likedListView.hidden = NO;
        rect = cell.commentListView.frame;
        rect.origin.y += LIKEDLISTVIEW_HEIGHT;
        cell.commentListView.frame = rect;
        rect = cell.bgView.frame;
        rect.size.height += LIKEDLISTVIEW_HEIGHT;
        cell.bgView.frame = rect;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _data.count) return 50;
    CGFloat ret = 0;
    Message *message = [_data objectAtIndex:indexPath.row];
    ret = SHORTMESSAGRCELL_HEIGHT + [self calculateTextViewHeight:message.content] - TEXTVIEW_HEIGHT;
    AppData *appData = [AppData sharedInstance];
    LikedList *likedList = [appData getLikedListOfMid:[message.mid intValue]];
    if (likedList.userList.count == 0)
        ret -= LIKEDLISTVIEW_HEIGHT;
    return ret;
}

- (CGFloat)calculateTextViewHeight:(NSString *)string {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(TEXTVIEW_WIDTH-5, FLT_MAX)];
    return size.height + 8;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (p.y < -35) {
        UIView *view = [self getActivityIndicator];
        if (!view.superview)
            [scrollView addSubview:[self getActivityIndicator]];
        [self beginToDownloadTimeline];
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
        [self workAtIndexpath:indexPath];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    [self workAtIndexpath:indexPath];
}

// 到达indexPath时处理的工作
- (void)workAtIndexpath:(NSIndexPath *)indexPath {
    LOG(@"current %d max %d", _currentPage, _maxDataLoadedPage);
    int row = indexPath.row;
    int tmp = row / PAGE_MESSAGE_COUNT;
    AppData *appData = [AppData sharedInstance];
    if (_currentPage != tmp) {
        int len = PAGE_MESSAGE_COUNT;
        if (appData.timeline.mids.count - tmp * PAGE_MESSAGE_COUNT < PAGE_MESSAGE_COUNT)
            len = appData.timeline.mids.count - tmp * PAGE_MESSAGE_COUNT;
        [MessageLogic downloadLikedList:[appData.timeline.mids subarrayWithRange:NSMakeRange(tmp*PAGE_MESSAGE_COUNT, len)]];
    }
    _currentPage = tmp;//row / PAGE_MESSAGE_COUNT;
    if (_currentPage < _maxDataLoadedPage) return;
    if (_backgroubdLoadWorking) return;
    _backgroubdLoadWorking = YES;
    
    
    if (_data.count - row < 15) {
        L(@"< 15");
        NSArray *messageNeedDownload = [appData messagesNeedDownloadFromIndex:_data.count];
        if (messageNeedDownload.count == 0) {
            NSArray *messages = [appData getMessagesInPage:_currentPage + 1];
            for (id message in messages)
                [_data addObject:message];
            [self.tableView reloadData];
            _backgroubdLoadWorking = NO;
            _maxDataLoadedPage = _currentPage + 1;
        }
        else {
            _backgroubdLoadData = YES;
            _backgroubdLoadDataAtIndex = -1;
            L([messageNeedDownload description]);
            [MessageLogic downloadMessages:messageNeedDownload];
        }
        return;
    }
    else if (row % PAGE_MESSAGE_COUNT < PAGE_MESSAGE_COUNT * 2 / 3) {
        _backgroubdLoadWorking = NO;
        return;
    }
    L(@"work1");
    Message *message1 = [_data objectAtIndex:_currentPage * PAGE_MESSAGE_COUNT];
    Message *message2 = [_data objectAtIndex:_currentPage * PAGE_MESSAGE_COUNT + 1];
    
    int index1 = [appData.timeline.mids indexOfObject:message1.mid];
    int index2 = [appData.timeline.mids indexOfObject:message2.mid];
    if (index2 - index1 == 1) return;
    NSArray *messageNeedDownload = [appData messagesNeedDownloadFromIndex:index1+1];
    if (messageNeedDownload.count == 0) {
        NSArray *messages = [appData getMessagesInPage:_currentPage + 1];
        for (Message *message in messages) {
            if ([message2.mid isEqualToNumber:message.mid]) break;
            [_data addObject:message];
        }
        [self.tableView reloadData];
        _backgroubdLoadWorking = NO;
        _maxDataLoadedPage = _currentPage + 1;
    }
    else {
        _backgroubdLoadData = YES;
        _backgroubdLoadDataAtIndex = _currentPage * PAGE_MESSAGE_COUNT + 1;
        [MessageLogic downloadMessages:messageNeedDownload];
    }
    

}

//- (void)backgroundLoadData {
//    AppData *appData = [AppData sharedInstance];
//    NSArray *messageNeedDownload = [appData messagesNeedDownloadFromIndex:_data.count];
//    if (messageNeedDownload.count == 0) {
//        NSArray *messages = [appData getMessagesInPage:_currentPage + 1];
//        for (id message in messages)
//            [_data addObject:message];
//        [self.tableView reloadData];
//    }
//    else {
//        [MessageLogic downloadMessages:messageNeedDownload];
//    }
//}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (p.y < -35)
    [scrollView setContentOffset:CGPointMake(0, -35) animated:NO];
}

- (void)beginToDownloadTimeline {
    if (_timelineDownloading) return;
    _timelineDownloading = YES;
    [MessageLogic downloadTimeline];
}

- (void)dataDidDownload:(NSNotification *)notification {
    FUNC_START();
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADTIMELINE])
        [self timelineDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADMESSAGES])
        [self messageDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADUSERINFOS])
        [self userInfoDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADLIKEDLIST])
        [self likedListDidDownload:notification];
    FUNC_END();
}

- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)timelineDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        L(@"local timeline newest");
        [self hideTopActivityIndicator];
//        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        _timelineDownloading = NO;
        return;
    }
    _maxDataLoadedPage = 0;
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSArray *mids = [data objectForKey:@"mids"];
    int seq = [[data objectForKey:@"seq"] intValue];
    AppData *appData = [AppData sharedInstance];
    for (int i = mids.count - 1, j = 0; i >= 0; i--, j++) {
        if ([appData.timeline.mids containsObject:[mids objectAtIndex:i]]) break;
        if (!j || j < appData.timeline.mids.count)
            [appData.timeline.mids insertObject:[mids objectAtIndex:i] atIndex:j];
        else [appData.timeline.mids addObject:[mids objectAtIndex:i]];
    }
    [appData.timeline update];
    appData.timeline.seq = [NSNumber numberWithInt:seq];
    [AppData saveData];
    NSArray *messageNeedDownload = [appData messagesNeedDownload];
    [MessageLogic downloadMessages:messageNeedDownload];
    [MessageLogic downloadLikedList:[appData.timeline.mids subarrayWithRange:NSMakeRange(0, PAGE_MESSAGE_COUNT)]];
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _timelineDownloading = NO;
}

- (void)likedListDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"likedlist download succ");
    else L(@"likedlist download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    for (NSNumber *mid in [data allKeys]) {
        NSDictionary *dic = [data objectForKey:mid];
        LikedList *likedList = [appData getLikedListOfMid:[mid intValue]];
        likedList.seq = [dic objectForKey:@"seq"];
        likedList.userList = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"list"]];
        [likedList update];
    }
    [AppData saveData];
    [self.tableView reloadData];
}

- (void)messageDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"message download succ");
    else L(@"message download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    AppData *appData = [AppData sharedInstance];
    int nowCount = _data.count;
    for (NSString *key in [[data allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSDictionary *obj = [data objectForKey:key];
        Message *message = [appData messgeForId:[key intValue]];
        if ([[obj objectForKey:@"seq"] intValue] == [message.seq intValue]) continue;
        message.seq = [obj objectForKey:@"seq"];
        message.mid = [obj objectForKey:@"mid"];
        message.content = [obj objectForKey:@"content"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        message.time = [format dateFromString:[obj objectForKey:@"time"]];
        message.type = [obj objectForKey:@"type"];
        message.sharedCount = [obj objectForKey:@"sharedcount"];
        message.likedList = [obj objectForKey:@"likedlist"];
        message.uid = [obj objectForKey:@"uid"];
        if (!_backgroubdLoadData)
        [_data insertObject:message atIndex:0];
        else {
            if (_backgroubdLoadDataAtIndex == -1)
                [_data insertObject:message atIndex:nowCount];
            else [_data insertObject:message atIndex:_backgroubdLoadDataAtIndex];
        }
        if (![uids containsObject:message.uid])
            [uids addObject:message.uid];
    }
    [AppData saveData];
    
    NSArray *userInfoNeedDownload = [appData userInfosNeedDownload:uids];
    if (userInfoNeedDownload.count) {
        [UserSimpleLogic downloadUseInfos:userInfoNeedDownload];
    }
    
    if (_updateAtTop) {
        [self performSelector:@selector(hideTopActivityIndicator) withObject:nil afterDelay:0.0];
//        [self hideTopActivityIndicator];
    }
    _updateAtTop = NO;
    _moreMessageCell = 1;
//    if (!_backgroubdLoadData)
    [self.tableView reloadData];
    if (_backgroubdLoadData) {
        _backgroubdLoadWorking = NO;
        _maxDataLoadedPage = _currentPage + 1;
        _backgroubdLoadData = NO;
    }
//    L([notification.userInfo description]);
}

- (void)userInfoDidDownload:(NSNotification *)notification {
    FUNC_START();
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"userInfo download succ");
    else L(@"userInfo download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    for (NSNumber *key in [data allKeys]) {
        UserInfo *userInfo = [appData userInfoForId:[key intValue]];
        NSDictionary *ui = [data objectForKey:key];
        if ([userInfo.seq isEqualToNumber:[ui objectForKey:@"seq"]]) continue;
        userInfo.uid = [ui objectForKey:@"uid"];
        userInfo.username = [ui objectForKey:@"name"];
        userInfo.birthday = [ui objectForKey:@"birthday"];
        userInfo.sex = [ui objectForKey:@"sex"];
        userInfo.hometown = [ui objectForKey:@"hometown"];
        userInfo.seq = [ui objectForKey:@"seq"];
    }
    [AppData saveData];
    [self.tableView reloadData];
    FUNC_END();
}

// 位于顶部的更新标志
- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.view.frame)-len / 2, -len, len, len);
    }
    _activityIndicator.hidden = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}

- (void)likeMessage:(id)sender {
//    return;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    Message *message = [_data objectAtIndex:indexPath.row];
    [MessageLogic likeMessage:[message.mid intValue]];
    LikedList *likedList = [[AppData sharedInstance] getLikedListOfMid:[message.mid intValue]];
    User *user = [MessageLogic user];
    [likedList.userList addObject:[NSNumber numberWithInt:user.uid]];
    [likedList update];
    [AppData saveData];
    [self.tableView reloadData];
    
//    ShortMessageCell *cell = (ShortMessageCell *)sender;
    
//    L([indexPath description]);
}

- (void)dislikeMessage:(id)sender {
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    Message *message = [_data objectAtIndex:indexPath.row];
    [MessageLogic dislikeMessage:[message.mid intValue]];
    LikedList *likedList = [[AppData sharedInstance] getLikedListOfMid:[message.mid intValue]];
    User *user = [MessageLogic user];
    if ([likedList.userList containsObject:[NSNumber numberWithInt:user.uid]])
        [likedList.userList removeObject:[NSNumber numberWithInt:user.uid]];
    [likedList update];
    [AppData saveData];
    [self.tableView reloadData];

}

- (void)commentMessage:(id)sender {
    
}

- (void)shareMessage:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


