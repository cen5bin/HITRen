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
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(timelineDidDownload:) name:ASYNCDATALOADED object:nil];
//    self.tableView.pagingEnabled = NO;
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

- (void)timelineDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) {
        L(@"download timeline succ");
    }
    else L(@"download timeline fail");
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        _timelineDownloading = NO;
        return;
    }
    NSArray *mids = [ret objectForKey:@"DATA"];
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _timelineDownloading = NO;
    
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


