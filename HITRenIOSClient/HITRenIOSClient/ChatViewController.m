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
#import "MessageLogic.h"
#import "EmotionView.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:XMPP_CHATMESSAGE_RECEIVED object:nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.username.text = self.userInfo.username;
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData lastNoticeOfUid:[self.userInfo.uid intValue]];
    _datas = [[NSMutableArray alloc] initWithArray:notice.notices];
    _keyboardToolBar = getViewFromNib(@"keyboardtoolbar", self);
    _keyboardToolBar.hidden = YES;
    _keyboardToolBarAtBottom = getViewFromNib(@"keyboardtoolbar", self);
    _keyboardToolBar.delegate = self;
    _keyboardToolBarAtBottom.delegate = self;
    CGRect rect = _keyboardToolBarAtBottom.frame;
    CGRect rect1 = [self.view convertRect:self.view.frame toView:self.view.window];
    rect.origin.y = rect1.size.height - rect.size.height;
    _keyboardToolBarAtBottom.frame = rect;
    [self.view addSubview:_keyboardToolBarAtBottom];
    [self scrollToBottom];
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
        [self.tableView reloadData];
    }];

}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    if (rect.origin.y >= self.view.frame.size.height) return;
    else {
        _keyboardToolBarAtBottom.hidden = YES;
        _keyboardToolBar.hidden = NO;
        CGRect rect0 = _keyboardToolBar.frame;
        rect0.origin.y = rect.origin.y - _keyboardToolBar.frame.size.height;
        _keyboardToolBar.frame = rect0;
        if (!_keyboardToolBar.superview)
            [self.view.window addSubview:_keyboardToolBar];
        [_keyboardToolBar becomeFirstResponder];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

- (void)reloadData {
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData lastNoticeOfUid:[self.userInfo.uid intValue]];
    if (notice.notices.count > 10)
        _datas = [[NSMutableArray alloc] initWithArray:notice.notices];
    else {
        Notice *notice1 = [appData getNoticeOfUid:[self.userInfo.uid intValue] atIndex:[notice.index intValue]-1];
        _datas = [[NSMutableArray alloc] init];
        for (id obj in notice1.notices) [_datas addObject:obj];
        for (id obj in notice.notices) [_datas addObject:obj];
    }
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom {
    if (_datas.count == 0) return;
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:_datas.count-1 inSection:0]];
    rect = [self.tableView convertRect:rect toView:self.view.window];
    if (_keyboardToolBar.hidden) {
        CGFloat tmp = CGRectGetMaxY(rect) - _keyboardToolBarAtBottom.frame.origin.y;
        if (tmp < 0) return;
        CGPoint p = self.tableView.contentOffset;
        p.y += tmp;
        [self.tableView setContentOffset:p animated:NO];
    }
    else {
        CGFloat tmp = CGRectGetMaxY(rect) - _keyboardToolBar.frame.origin.y;
        if (tmp < 0) return;
        CGPoint p = self.tableView.contentOffset;
        p.y += tmp;
        [self.tableView setContentOffset:p animated:NO];
    }

}

- (void)sendText:(NSString *)text {
    [MessageLogic sendMessage:text toUid:[self.userInfo.uid intValue]];
    _keyboardToolBar.textView.text = @"";
    [self reloadData];
}

- (void)emotionButtonClicked {
    if (!_keyboardToolBar.emotionButtonState) return;
    
    _emotionView = [EmotionView sharedInstance];
    CGRect rect = _emotionView.frame;
    rect.origin.y = 0;//CGRectGetMaxY(_keyboardToolBar.frame);
    LOG(@"%f", rect.origin.y);
    _emotionView.frame = rect;
    if (_emotionView.superview) [_emotionView removeFromSuperview];
    [self.view.window addSubview:_emotionView];
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
    cell.isReply = obj.isReply;
    [cell show];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!_keyboardToolBarIsDisappearing) {
        _keyboardToolBarIsDisappearing = YES;
        [_keyboardToolBar resignFirstResponderNotHideAtOnce];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeObject *obj = [_datas objectAtIndex:indexPath.row];
    CGFloat tmp = 0;
    if (indexPath.row == _datas.count - 1 && _keyboardToolBar.hidden) tmp = _keyboardToolBarAtBottom.frame.size.height;
    return [ChatCell calculateCellHeight:[obj.content objectForKey:@"text"]] + tmp;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
            self.topBar.image = image;
            [_keyboardToolBar resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (p.x >= CGRectGetMaxX(self.topBar.frame)-50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;
        }
    }

}



@end
