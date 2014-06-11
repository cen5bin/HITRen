//
//  CalendarViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "CalendarViewController.h"
#import "AppData.h"
#import "CalendarCell.h"
#import "EventLine.h"
#import "Event.h"
#import "EventLogic.h"
#import "AddCalendarViewController.h"
//#import <QuartzCore/QuartzCore.h>

@interface CalendarViewController ()

@end

@implementation CalendarViewController

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
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", ASYNCDATALOADED, CLASS_NAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:notificationName object:nil];
    _currentPage = 0;
    _maxLoadedPage = 0;
    _data = [[NSMutableArray alloc] init];
//    NSArray *tmp = [[AppData sharedInstance] getEventInPage:0];
//    for (Event *event in tmp)
//    if (![_data containsObject:event.eid])
//        [_data addObject:event.eid];
//    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [EventLogic downloadEventLinefrom:CLASS_NAME];
    AppData *appData = [AppData sharedInstance];
    int count = appData.eventLine.eids.count;
    if (count > PAGE_EVENT_COUNT) count = PAGE_EVENT_COUNT;
    _data = [NSMutableArray arrayWithArray:[appData.eventLine.eids subarrayWithRange:NSMakeRange(0, count)]];
    NSArray *tmp = [appData getSortedEvents:_data];
    _data = [[NSMutableArray alloc] init];
    for (Event *event in tmp)
        [_data addObject:event.eid];
    [self.tableView reloadData];
}

- (void)dataDidDownload:(NSNotification *)notification {
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADEVENTLINE])
        [self eventLineDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADEVENTSINFO])
        [self eventInfosDidDownload:notification];
}

- (void)eventLineDidDownload:(NSNotification *)notification {
    _currentPage = 0;
    NSDictionary *dic = notification.userInfo;
    if ([dic objectForKey:@"SUC"]) L(@"downlaod eventline succ");
    else L(@"download eventline fail");
    if ([[dic objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        L(@"newest");
        [self.tableView reloadData];
        return;
    }
    AppData *appData = [AppData sharedInstance];
    NSDictionary *data = [dic objectForKey:@"DATA"];
    L([data description]);
    appData.eventLine.seq = [data objectForKey:@"seq"];
    appData.eventLine.eids = [NSMutableArray arrayWithArray: [[[data objectForKey:@"eids"] reverseObjectEnumerator] allObjects]];
    [appData.eventLine update];
    [AppData saveData];
    L([appData.eventLine.eids description]);
    
    int count = appData.eventLine.eids.count;
    if (count > PAGE_EVENT_COUNT) count = PAGE_EVENT_COUNT;
    _data = [NSMutableArray arrayWithArray:[appData.eventLine.eids subarrayWithRange:NSMakeRange(0, count)]];
//    count = _data.count;
//    if (count > PAGE_EVENT_COUNT) count = PAGE_EVENT_COUNT;
//    for (int i = 0; i < count; i++)
//        if (![tmp containsObject:[_data objectAtIndex:i]]) [tmp addObject:[_data objectAtIndex:i]];
    [EventLogic downloadEventInfos:_data from:CLASS_NAME];
}

- (void)eventInfosDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([dic objectForKey:@"SUC"]) L(@"download event infos succ");
    else L(@"download event infos fail");
    NSDictionary *data = [dic objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm";
    for (NSString *eid in [data allKeys]) {
        Event *event = [appData getEventOfEid:eid];
        if (!event) event = [appData newEvent];
        NSDictionary *tmp = [data objectForKey:eid];
        
        event.eid = [tmp objectForKey:@"eid"];
        event.place = [tmp objectForKey:@"place"];
        event.desc = [tmp objectForKey:@"description"];
        event.remindTimes = [tmp objectForKey:@"reminds"];
        event.seq = [tmp objectForKey:@"seq"];
        event.time = [formater dateFromString:[tmp objectForKey:@"time"]];
        [event update];
    }
    
    [AppData saveData];
    NSArray *tmp = [appData getSortedEvents:_data];
    _data = [[NSMutableArray alloc] init];
    for (Event *event in tmp)
        [_data addObject:event.eid];
    [self.tableView reloadData];
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

- (void)workAtIndexpath:(NSIndexPath *)indexPath {
    
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
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CalendarCell";
    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSString *eid = [_data objectAtIndex:indexPath.row];
    AppData *appData = [AppData sharedInstance];
    Event *event = [appData getEventOfEid:eid];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm";
    cell.timeLabel.text = [formater stringFromDate:event.time];
    cell.placeLabel.text = event.place;
    cell.detailLabel.text = event.desc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *eid = [_data objectAtIndex:indexPath.row];
    AddCalendarViewController *controller = getViewControllerOfName(@"AddCalendar");
    controller.eid = eid;
    controller.edit = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self.view];
//    if (CGRectContainsPoint(self.topBar.frame, p)) {
//        if (p.x <= 50) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
//            self.topBar.image = image;
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
}


- (IBAction)addCalendar:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar1" ofType:@"png"]];
    self.topBar.image = image;
    AddCalendarViewController *controller = getViewControllerOfName(@"AddCalendar");
    controller.eid = nil;
    [self.navigationController pushViewController:controller animated:YES];
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
}

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar0" ofType:@"png"]];
    self.topBar.image = image;

}
@end
