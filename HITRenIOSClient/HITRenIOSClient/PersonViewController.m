//
//  PersonViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "PersonViewController.h"
#import "User.h"
#import "HometownPicker.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidFinishLoading:) name:ASYNCDATALOADED object:nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.tableView.backgroundView = nil;
    self.email.enabled = NO;
    
    
    NSMutableArray *section0 = [[NSMutableArray alloc] initWithObjects:self.headCell,self.usernameCell,self.sexCell, self.birthdayCell, self.hometownCell, nil];
    NSMutableArray *section1 = [[NSMutableArray alloc] initWithObjects:self.friendsManageCell, nil];
    NSMutableArray *section2 = [[NSMutableArray alloc] initWithObjects:self.jwcIDCell, self.jwcPasswordCell, nil];
    
    _tableCells = [[NSMutableArray alloc] initWithObjects:section0, section1, section2, nil];
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.email.text = [userDefaults objectForKey:@"email"];

    FUNC_END();
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize size = self.view.frame.size;
    size.height += 75;
    self.tableView.contentSize = size;
    
    if (!self.fromRegister) {
        [UserSimpleLogic downloadInfo];
    }
    
    User *user = [UserSimpleLogic user];
    if (user.birthday)
        [self.birthday setTitle:user.birthday forState:UIControlStateNormal];
    if (user.hometown)
        [self.hometown setTitle:user.hometown forState:UIControlStateNormal];
    if (user.username)
        self.username.text = user.username;
    if (user.sex)
        [self performSelector:@selector(doHighLight:) withObject:user.sex == 2?self.femaleButton:self.maleButton afterDelay:0.0];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    FUNC_START();
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.topBar.frame, [touch locationInView:self.view])) {
        CGPoint point = [touch locationInView:self.topBar];
        if (point.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me2" ofType:@"png"]];
            self.topBar.image = image;
            UINavigationController *navigateController = self.navigationController;

            [self.navigationController popViewControllerAnimated:NO];
            if (self.fromRegister) {
                L(@"got it");
                FreshNewsViewController *controller = getViewControllerOfName(@"mainview3");
                [navigateController pushViewController:controller animated:YES];
            }
        }
        else if (point.x > self.view.frame.size.width - 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me1" ofType:@"png"]];
            self.topBar.image = image;
            [self hidePicker];
            User *user = [UserSimpleLogic user];
            if (_hometownChanged) user.hometown = self.hometown.titleLabel.text;
            if (_birthdayChanged) user.birthday = self.birthday.titleLabel.text;
            if (self.username.text && self.username.text.length) user.username = self.username.text;
            if (self.maleButton.highlighted) user.sex = 1;
            else if (self.femaleButton.highlighted) user.sex = 2;
            
            [UserSimpleLogic updateInfo];
            
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"me" ofType:@"png"]];
            self.topBar.image = image;
        }
        
    }
    FUNC_END();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_tableCells objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[_tableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_tableCells objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2)
        return @"教务处账号绑定";
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *view0 = (UITableViewHeaderFooterView *)view;
    view0.textLabel.font = [UIFont systemFontOfSize:14];
    view0.textLabel.textColor = [UIColor darkGrayColor];
}



- (void)keyboardWillHide:(NSNotification *)notification {
    FUNC_START();
    FUNC_END();
}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    FUNC_START();
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    CGRect rect1;
    if (self.username.isFirstResponder)
        rect1 = [self.usernameCell convertRect:self.username.frame toView:self.view.window];
    else if (self.jwcID.isFirstResponder)
        rect1 = [self.jwcIDCell convertRect:self.jwcID.frame toView:self.view.window];
    else if (self.jwcPassword.isFirstResponder)
        rect1 = [self.jwcPasswordCell convertRect:self.jwcPassword.frame toView:self.view.window];
    else {
        FUNC_END();
        return;
    }

    if (CGRectIntersectsRect(rect1, rect)) {
        CGFloat height = -CGRectGetMinY(rect)+CGRectGetMaxY(rect1)+self.tableView.contentOffset.y+20;
        CGSize size = self.tableView.contentSize;
        size.height += height;
        self.tableView.contentSize = size;
        self.tableView.contentOffset = CGPointMake(0, height+20);
        
    }

    FUNC_END();
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    L([sender description]);
    if (sender == self.maleButton) {
        L(@"male");
        [self performSelector:@selector(doHighLight:) withObject:self.maleButton afterDelay:0.0];
        [self performSelector:@selector(unDoHighLight:) withObject:self.femaleButton afterDelay:0.0];
    }
    else if (sender == self.femaleButton) {
        L(@"female");
        [self performSelector:@selector(doHighLight:) withObject:self.femaleButton afterDelay:0.0];
        [self performSelector:@selector(unDoHighLight:) withObject:self.maleButton afterDelay:0.0];
    }
    else if (sender == self.birthday) {
        L(@"birthday");
        [self resignAll];
        if (_datePicker && _datePicker.superview) return;
        if (_hometownPicker && _hometownPicker.superview) [_hometownPicker removeFromSuperview];
        if (!_datePicker) {
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), 0, 0)];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            [_datePicker addTarget:self action:@selector(dateValueChanged) forControlEvents:UIControlEventValueChanged];
        }
        _datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), 0, 0);
        [self.view addSubview:_datePicker];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            CGRect rect = _datePicker.frame;
            rect.origin.y -= rect.size.height;
            _datePicker.frame = rect;
        } completion:^(BOOL finished) {}];
    }
    else if (sender == self.hometown) {
        L(@"hometown");
        [self resignAll];
        if (_hometownPicker && _hometownPicker.superview) return;
        if (_datePicker && _datePicker.superview) [_datePicker removeFromSuperview];
        if (!_hometownPicker) {
            _hometownPicker = [[HometownPicker alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), 320, 216)];
            
            [_hometownPicker addTarget:self action:@selector(hometownValueChanged)];
        }
        _hometownPicker.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), 320, 216);
        [self.view addSubview:_hometownPicker];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            CGRect rect = _hometownPicker.frame;
            rect.origin.y -= rect.size.height;
            _hometownPicker.frame = rect;
        } completion:^(BOOL finished) {
            User *user = [UserSimpleLogic user];
            if (!user.hometown) {
                [self.hometown setTitle:@"北京 北京市" forState:UIControlStateNormal];
                _hometownChanged = YES;
            }
        }];
    }
}

- (void)doHighLight:(UIButton *)b {
    b.highlighted = YES;
}

- (void)unDoHighLight:(UIButton *)b {
    b.highlighted = NO;
}

- (void)hometownValueChanged{
    NSMutableDictionary *dic = _hometownPicker.hometown;
//    self.hometown.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"province"], [dic objectForKey:@"city"]];
    [self.hometown setTitle:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"province"], [dic objectForKey:@"city"]] forState:UIControlStateNormal];
    _hometownChanged = YES;
}
- (void)dateValueChanged {
    FUNC_START();
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    [self.birthday setTitle:[formater stringFromDate:_datePicker.date] forState:UIControlStateNormal];
    _birthdayChanged = YES;
    FUNC_END();
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hidePicker];
    [self resignAll];
}

- (void)resignAll {
    [self.username resignFirstResponder];
    [self.jwcID resignFirstResponder];
    [self.jwcPassword resignFirstResponder];
}

- (void)hidePicker {
    if (_datePicker && _datePicker.superview) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            CGRect rect = _datePicker.frame;
            rect.origin.y += rect.size.height;
            _datePicker.frame = rect;
        } completion:^(BOOL finished){
            [_datePicker removeFromSuperview];
        }];
    }
    
    if (_hometownPicker && _hometownPicker.superview) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            CGRect rect = _hometownPicker.frame;
            rect.origin.y += rect.size.height;
            _hometownPicker.frame = rect;
        } completion:^(BOOL finished){
            [_hometownPicker removeFromSuperview];
        }];
    }

}

- (void)dataDidFinishLoading:(NSNotification*)notification {
    if ([notification.object isEqual:ASYNC_EVENT_UPDATEUSETINFO])
        [UserSimpleLogic updateInfoFinished:notification.userInfo];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
@end
