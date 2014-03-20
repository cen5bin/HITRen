//
//  PersonViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "PersonViewController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.tableView.backgroundView = nil;
    self.email.enabled = NO;
    
    NSMutableArray *section0 = [[NSMutableArray alloc] initWithObjects:self.headCell,self.usernameCell,self.sexCell, self.birthdayCell, self.hometownCell, nil];
    NSMutableArray *section1 = [[NSMutableArray alloc] initWithObjects:self.jwcIDCell, self.jwcPasswordCell, nil];
    LOG(@"section0 %d", [section0 count]);
    _tableCells = [[NSMutableArray alloc] initWithObjects:section0, section1, nil];
    LOG(@"%d", [[_tableCells objectAtIndex:0] count]);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.email.text = [userDefaults objectForKey:@"email"];

    FUNC_END();
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
    if (section == 1)
        return @"教务处账号绑定";
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *view0 = (UITableViewHeaderFooterView *)view;
    view0.textLabel.font = [UIFont systemFontOfSize:14];
    view0.textLabel.textColor = [UIColor darkGrayColor];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    FUNC_START();
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];

    CGSize size = [value CGRectValue].size;
    LOG(@"%f", size.height);
    FUNC_END();
}

- (void)keyboardWillHide:(NSNotification *)notification {
    FUNC_START();
    FUNC_END();
}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    FUNC_START();
    L(@"changed");
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
    
    LOG(@"rect1 %f %f %f %f", rect1.origin.x, rect1.origin.y, rect1.size.width, rect1.size.height);
    LOG(@"rect %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

    if (CGRectIntersectsRect(rect1, rect)) {
        LOG(@"rect minY:%f", CGRectGetMinY(rect));
        LOG(@"rect1 maxY:%f", CGRectGetMaxY(rect1));
        CGFloat height = -CGRectGetMinY(rect)+CGRectGetMaxY(rect1)+self.tableView.contentOffset.y+20;
        CGSize size = self.tableView.contentSize;
        size.height += height;
        self.tableView.contentSize = size;
        self.tableView.contentOffset = CGPointMake(0, height+20);
        
        LOG(@"%f", self.tableView.contentOffset.y);
    }
//    self.tableView.contentOffset = CGPointMake(0, -100);
    FUNC_END();
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end