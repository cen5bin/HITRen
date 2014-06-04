//
//  AddCalendarViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "AddCalendarViewController.h"
#import "SetRemindViewController.h"

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
    
    self.reminds = [[NSMutableArray alloc] init];
    
    _data = [[NSMutableArray alloc] initWithObjects:@"无",@"事件发生时",@"5分钟前",@"15分钟前",@"30分钟前",@"1小时前",@"2小时前",@"1天前",@"2天前", nil];
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

@end
