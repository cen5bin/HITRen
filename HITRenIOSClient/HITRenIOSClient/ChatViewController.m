//
//  ChatViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-26.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "AppData.h"
#import "Notice.h"
#import "NoticeObject.h"
#import "UserInfo.h"
#import "KeyboardToolBar.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.username.text = self.userInfo.username;
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData lastNoticeOfUid:[self.userInfo.uid intValue]];
    _datas = [[NSMutableArray alloc] initWithArray:notice.notices];
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"keyboardtoolbar" owner:self options:nil];
    _keyboardToolBar = getViewFromNib(@"keyboardtoolbar", self);
    _keyboardToolBarAtBottom = getViewFromNib(@"keyboardtoolbar", self);
    _keyboardToolBar.delegate = self;
    _keyboardToolBarAtBottom.delegate = self;
    CGRect rect = _keyboardToolBarAtBottom.frame;
    LOG(@"%f", self.view.frame.size.height);
    CGRect rect1 = [self.view convertRect:self.view.frame toView:self.view.window];
    rect.origin.y = rect1.size.height - rect.size.height;
    _keyboardToolBarAtBottom.frame = rect;
    [self.view addSubview:_keyboardToolBarAtBottom];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect rect1 = _keyboardToolBar.frame;
        rect1.origin.y = _keyboardToolBarAtBottom.frame.origin.y;//rect.origin.y - rect1.size.height;
        _keyboardToolBar.frame = rect1;
    } completion:^(BOOL finished){
        _keyboardToolBar.hidden = YES;
        if (_keyboardToolBar.superview) [_keyboardToolBar removeFromSuperview];
        _keyboardToolBarIsDisappearing = NO;
        _keyboardToolBarAtBottom.hidden = NO;
    }];

}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    if (rect.origin.y >= self.view.frame.size.height) {
    }
    else {
        _keyboardToolBarAtBottom.hidden = YES;
        _keyboardToolBar.hidden = NO;
        CGRect rect0 = _keyboardToolBar.frame;
        rect0.origin.y = rect.origin.y - _keyboardToolBar.frame.size.height;
        _keyboardToolBar.frame = rect0;
        if (!_keyboardToolBar.superview)
            [self.view.window addSubview:_keyboardToolBar];
        [_keyboardToolBar becomeFirstResponder];
    }
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
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NoticeObject *obj = [_datas objectAtIndex:indexPath.row];
    cell.text = [obj.content objectForKey:@"text"];
    [cell show];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!_keyboardToolBarIsDisappearing) {
        L(@"asd");
        _keyboardToolBarIsDisappearing = YES;
        [_keyboardToolBar resignFirstResponderNotHideAtOnce];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeObject *obj = [_datas objectAtIndex:indexPath.row];
    return [ChatCell calculateCellHeight:[obj.content objectForKey:@"text"]];
}



@end
