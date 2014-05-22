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
    Notice *notice = [appData activitiesAtIndex:0];
    _activies = [[NSMutableArray alloc] initWithArray:notice.notices];
    _notices = appData.noticeLine;
    
//    if (self.flag == 1)
//        _data = appData.noticeLine;
//    else if (self.flag == 0){
//       
//    }
    
    self.noticeViewBar.layer.borderWidth = 0.5;
    self.noticeViewBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    CGRect rect = self.scrollView.frame;
    self.scrollView.contentSize = CGSizeMake(rect.size.width * 2, rect.size.height);
    
    FUNC_END();
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
    if (tableView == self.activityTableView) return _activies.count;
    if (tableView == self.noticeTableView) return _notices.count;
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
    
    
    if (tableView == self.activityTableView) {
        NoticeObject *object = [_activies objectAtIndex:indexPath.row];
        NSDictionary *dic = object.content;
        if (object.type == 1) {
            cell.username.text = [[dic objectForKey:@"by"] objectForKey:@"name"];
        }
        cell.lastNotice.text = [AppData stringOfNoticeObject:object];
    }
    else if (tableView == self.noticeTableView) {
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (scrollView == self.scrollView) {
//        int page = floor((p.x - self.view.frame.size.width / 2) / self.view.frame.size.width) + 1;
        return;
    }
    if (p.y < 0) p.y = 0;
    else if (p.y > scrollView.contentSize.height - scrollView.frame.size.height)
        p.y = scrollView.contentSize.height - scrollView.frame.size.height;
    if (p.y < 0) p.y = 0;
    scrollView.contentOffset = p;
}



- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    static BOOL working = NO;
    if (working) return;
    working = YES;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        L(@"left");
        if (self.flag == 1) return;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            CGRect frame = self.view.frame;
            CGRect rect1 = self.activityTableView.frame;
            CGRect rect2 = self.noticeTableView.frame;
            rect1.origin.x -= CGRectGetWidth(frame);
            rect2.origin.x -= CGRectGetWidth(frame);
            self.activityTableView.frame = rect1;
            self.noticeTableView.frame = rect2;
        } completion:^(BOOL finished){
            self.flag = 1;
            working = NO;
        }];
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        L(@"right");
        if (self.flag == 0) return;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            CGRect frame = self.view.frame;
            CGRect rect1 = self.activityTableView.frame;
            CGRect rect2 = self.noticeTableView.frame;
            rect1.origin.x += CGRectGetWidth(frame);
            rect2.origin.x += CGRectGetWidth(frame);
            self.activityTableView.frame = rect1;
            self.noticeTableView.frame = rect2;
        } completion:^(BOOL finished){
            self.flag = 0;
            working = NO;
        }];

    }
}
@end
