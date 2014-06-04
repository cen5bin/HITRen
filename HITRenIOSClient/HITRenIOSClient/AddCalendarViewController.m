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
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SetRemindViewController *controller = getViewControllerOfName(@"SetRemind");
        controller.reminds = self.reminds;
        [self.navigationController pushViewController:controller animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        id obj = [_cells objectAtIndex:indexPath.row];
        if (obj == self.eventCell) [self.textView becomeFirstResponder];
        
    }
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
