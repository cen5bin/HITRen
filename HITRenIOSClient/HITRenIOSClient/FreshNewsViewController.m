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
    _data = [[NSMutableArray alloc] initWithObjects:@"asd", @"aaa", nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    AppData *appData = [AppData sharedInstance];
    [MessageLogic downloadMessages:appData.timeline.mids];
     L([appData.timeline.mids description]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ShortMessageCell";
    ShortMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[ShortMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];


    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    return 100;
//}

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

- (void)timelineDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        L(@"local timeline newest");
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        _timelineDownloading = NO;
        return;
    }
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSArray *mids = [data objectForKey:@"mids"];
    int seq = [[data objectForKey:@"seq"] intValue];
    AppData *appData = [AppData sharedInstance];
    for (int i = 0; i < mids.count; i++) {
        if ([appData.timeline.mids containsObject:[mids objectAtIndex:i]]) break;
        [appData.timeline.mids insertObject:[mids objectAtIndex:i] atIndex:0];
    }
    [appData.timeline update];
    appData.timeline.seq = [NSNumber numberWithInt:seq];
    [AppData saveData];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _timelineDownloading = NO;
}

- (void)messageDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"message download succ");
    else L(@"message download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    for (NSString *key in [data allKeys]) {
        L([[data objectForKey:key] objectForKey:@"content"]);
    }
//    L([notification.userInfo description]);
}

- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.view.frame)-len / 2, -len, len, len);
    }
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


