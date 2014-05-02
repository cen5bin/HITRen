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
#import "Timeline.h"
#import "DataManager.h"
#import "AppData.h"
#import "Message.h"

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
    _currentPage = 0;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    AppData *appData = [AppData sharedInstance];
//    if (appData.timeline.mids.count == 0) {
//        _updateAtTop = YES;
//        _currentPage = 0;
//        UIView *view = [self getActivityIndicator];
//        if (!view.superview)
//            [self.tableView addSubview:[self getActivityIndicator]];
//        [self.tableView setContentOffset:CGPointMake(0, -35) animated:NO];
//        [self beginToDownloadTimeline];
//    }
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
    CGRect rect = cell.textView.frame;
    CGFloat height = rect.size.height;
    rect.size.height = [self calculateTextViewHeight:message.content];
    cell.textView.frame = rect;
    CGFloat tmp = rect.size.height - height;
    rect = cell.bgView.frame;
    rect.size.height += tmp;
    cell.bgView.frame = rect;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _data.count) return 50;
    Message *message = [_data objectAtIndex:indexPath.row];
    return SHORTMESSAGRCELL_HEIGHT + [self calculateTextViewHeight:message.content] - TEXTVIEW_HEIGHT;
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
    }
}

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
    FUNC_END();
}

- (void)hideTopActivityIndicator {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _activityIndicator.hidden = YES;
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
    NSMutableArray *messageNeedDownload = [appData messagesNeedDownload];
    L([messageNeedDownload description]);
    [MessageLogic downloadMessages:messageNeedDownload];
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _timelineDownloading = NO;
}

- (void)messageDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"message download succ");
    else L(@"message download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    for (NSString *key in [[data allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSDictionary *obj = [data objectForKey:key];
        Message *message = [appData messgeForId:[key intValue]];
        if ([[obj objectForKey:@"seq"] intValue] == [message.seq intValue]) continue;
        message.seq = [obj objectForKey:@"seq"];
        message.mid = [obj objectForKey:@"mid"];
        message.content = [obj objectForKey:@"content"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        message.time = [format dateFromString:[obj objectForKey:@"time"]];
        message.type = [obj objectForKey:@"type"];
        message.sharedCount = [obj objectForKey:@"sharedcount"];
        message.likedList = [obj objectForKey:@"likedlist"];
        message.uid = [obj objectForKey:@"uid"];
        [_data insertObject:message atIndex:0];
        
    }
    [AppData saveData];
    if (_updateAtTop) {
        [self hideTopActivityIndicator];
//        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [_activityIndicator stopAnimating];
//        _activityIndicator.hidden = YES;
    }
    _updateAtTop = NO;
    _moreMessageCell = 1;
    [self.tableView reloadData];
//    L([notification.userInfo description]);
}



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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


