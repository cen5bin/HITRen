//
//  AddCalendarViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "AddCalendarViewController.h"
#import "SetRemindViewController.h"
#import "AppData.h"
#import "Event.h"
#import "EventLogic.h"
#import "User.h"

@interface AddCalendarViewController ()

@end

@implementation AddCalendarViewController

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
    _cells = [NSMutableArray arrayWithObjects:self.timeCell,self.placeCell,self.eventCell, nil];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    _times = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:5],[NSNumber numberWithInt:15],[NSNumber numberWithInt:30],[NSNumber numberWithInt:60],[NSNumber numberWithInt:120],[NSNumber numberWithInt:1440],[NSNumber numberWithInt:2880], nil];
    _data = [[NSMutableArray alloc] initWithObjects:@"无",@"事件发生时",@"5分钟前",@"15分钟前",@"30分钟前",@"1小时前",@"2小时前",@"1天前",@"2天前", nil];
    
    self.reminds = [[NSMutableArray alloc] init];
    
    if (self.eid) {
        AppData *appData = [AppData sharedInstance];
        Event *event = [appData getEventOfEid:self.eid];
        if (!event) return;
        self.placeField.text = event.place;
        for (NSNumber *remind in event.remindTimes) {
            int index = [_times indexOfObject:remind];
            if (!index)continue;
            [self.reminds addObject:[NSNumber numberWithInt:index]];
        }
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm";
        self.timeField.text = [formater stringFromDate:event.time];
        self.textView.text = event.desc;
    }
    
        

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return _cells.count;
    return self.reminds.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return [_cells objectAtIndex:indexPath.row];
    static NSString *CellIdentifer = @"RemindCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    if (indexPath.row == 0)
        cell.textLabel.text = @"添加提醒";
    else {
        NSString *string = [_data objectAtIndex:[[self.reminds objectAtIndex:indexPath.row - 1] intValue]];
        cell.textLabel.text = [NSString stringWithFormat:@"提醒%d: %@", indexPath.row, string];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIView *view = [_cells objectAtIndex:indexPath.row];
        return view.frame.size.height;
    }
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SetRemindViewController *controller = getViewControllerOfName(@"SetRemind");
        controller.reminds = self.reminds;
        if (indexPath.row != 0)
            controller.selectedIndex = [[self.reminds objectAtIndex:indexPath.row-1] intValue];
        else controller.selectedIndex = 0;
        [self.navigationController pushViewController:controller animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        id obj = [_cells objectAtIndex:indexPath.row];
        if (obj == self.eventCell) [self.textView becomeFirstResponder];
        if (obj == self.placeCell) [self.placeField becomeFirstResponder];
        else if (obj == self.timeCell) [self showDataPicker];
        
    }
    
}

- (void)dateValueChanged {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.timeField.text = [formater stringFromDate:_datePicker.date];
}

- (void)resignAll {
    [self.textView resignFirstResponder];
    [self.placeField resignFirstResponder];
}

- (void)showDataPicker {
    [self resignAll];
    if (_datePicker && _datePicker.superview) return;
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), 0, 0)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [_datePicker addTarget:self action:@selector(dateValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    if (!self.timeField.text || [self.timeField.text isEqualToString:@""]) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.timeField.text = [formater stringFromDate:[NSDate date]];
    }
    else {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        _datePicker.date = [formater dateFromString:self.timeField.text];
    }
    
    _datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), 0, 0);
    [self.view addSubview:_datePicker];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        CGRect rect = _datePicker.frame;
        rect.origin.y -= rect.size.height;
        _datePicker.frame = rect;
    } completion:^(BOOL finished) {}];
}

- (void)hideDatePicker {
    if (!_datePicker || !_datePicker.superview) return;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        CGRect rect = _datePicker.frame;
        rect.origin.y += rect.size.height;
        _datePicker.frame = rect;
    } completion:^(BOOL finished) {[_datePicker removeFromSuperview];}];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
    [self.placeField resignFirstResponder];
    [self hideDatePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)releaseEvent:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;
    AppData *appData = [AppData sharedInstance];
    Event *event = [appData newEvent];
    if (!self.eid)
        event.eid = [self makeEid];
    else event.eid = self.eid;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm";
    event.time = [formater dateFromString:self.timeField.text];
    event.desc = self.textView.text;
    event.place = self.placeField.text;
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (NSNumber *index in self.reminds)
        [tmp addObject:[_times objectAtIndex:[index intValue]]];
    event.remindTimes = tmp;
    [event update];
    [AppData saveData];
    NSDictionary *dic = @{@"eid":event.eid, @"time":self.timeField.text, @"place":event.place, @"description":event.desc, @"reminds":tmp};
    [EventLogic uploadEvent:dic from:CLASS_NAME];
    [self.navigationController popViewControllerAnimated:YES];
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
 }

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
}

- (NSString *)makeEid {
    static int rand = 1;
    User *user = [EventLogic user];
    int uid = user.uid;
    NSDate *date = [NSDate date];
    double tmp = [date timeIntervalSince1970];
    NSString *string = [NSString stringWithFormat:@"%03d%010d%.0lf",rand % 1000,uid, (tmp*100)];
    rand++;
    return string;
}
@end
