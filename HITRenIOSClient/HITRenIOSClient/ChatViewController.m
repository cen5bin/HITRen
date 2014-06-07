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
#import "UploadLogic.h"
#import "User.h"
#import "PersonInfoViewController.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
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
    
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    User *user = [MessageLogic user];
    _selfInfo = [appData readUserInfoForId:user.uid];
    
    if (_selfInfo.pic && _selfInfo.pic.length) {
        if ([[_selfInfo.pic substringToIndex:1] isEqualToString:@"h"])
            _selfImage = [UIImage imageNamed:_selfInfo.pic];
        else {
            _selfImage = [appData getImage:_selfInfo.pic];
            if (!_selfImage && ![_downloadingImageSet containsObject:_selfInfo.pic]) {
                [_downloadingImageSet addObject:_selfInfo.pic];
                [UploadLogic downloadImage:_selfInfo.pic from:NSStringFromClass(self.class)];
            }
        }
    }
    
    UserInfo *userInfo = self.userInfo;
    if (userInfo.pic && userInfo.pic.length) {
        if ([[userInfo.pic substringToIndex:1] isEqualToString:@"h"])
            _otherImage = [UIImage imageNamed:userInfo.pic];
        else {
            _otherImage = [appData getImage:userInfo.pic];
            if (!_otherImage && ![_downloadingImageSet containsObject:userInfo.pic]) {
                [_downloadingImageSet addObject:userInfo.pic];
                [UploadLogic downloadImage:userInfo.pic from:NSStringFromClass(self.class)];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _keyboardToolBarAtBottom.hidden = NO;
//    L([_keyboardToolBarAtBottom description]);
//    if (_keyboardToolBarAtBottom.superview) [_keyboardToolBarAtBottom removeFromSuperview];
//    CGRect rect = _keyboardToolBarAtBottom.frame;
//    CGRect rect1 = [self.view convertRect:self.view.frame toView:self.view.window];
//    rect.origin.y = rect1.size.height - rect.size.height;
//    _keyboardToolBarAtBottom.frame = rect;
//    [self.view addSubview:_keyboardToolBarAtBottom];
//    [self scrollToBottom];
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"empty.png"];
    NSString *filename = [notification.userInfo objectForKey:@"imagename"];
    [[AppData sharedInstance] storeImage:image withFilename: filename];
    [_downloadingImageSet removeObject:filename];
    if ([filename isEqualToString:_selfInfo.pic]) _selfImage = image;
    else if ([filename isEqualToString:self.userInfo.pic]) _otherImage = image;
    [self.tableView reloadData];
}



- (void)keyboardWillHide:(NSNotification *)notification {
    return;
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
    if (rect.origin.y >= self.view.frame.size.height) {
        _keyboardToolBar.hidden = YES;
        if (_keyboardToolBar.superview) [_keyboardToolBar removeFromSuperview];
        _keyboardToolBarIsDisappearing = NO;
        _keyboardToolBarAtBottom.hidden = NO;
//        [_keyboardToolBarAtBottom resignFirstResponder];
        [self.tableView reloadData];
        return;
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
    if (_keyboardToolBar.emotionButtonState) {
        [_keyboardToolBar resignFirstResponder];
        EmotionView *view = [EmotionView sharedInstance];
        view.keyboardToolBar = _keyboardToolBar;
        CGRect rect = view.frame;
        rect.origin = CGPointMake(0, 0);
        view.frame  = rect;
        [_keyboardToolBar.textView setInputView:view];
        [_keyboardToolBar becomeFirstResponder];
    }
    else {
        [self hideKeyboardToolBar];
        [_keyboardToolBar becomeFirstResponder];
//        [self performSelector:@selector(showKeyboardToolBar) withObject:nil afterDelay:0.0];
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
    cell.isReply = obj.isReply;
    [cell show];
    
    UIImage *tmp = cell.isReply?_selfImage:_otherImage;
    if (tmp)
        cell.pic.image = tmp;
    else cell.pic.image = [UIImage imageNamed:@"empty.png"];
//    
//    if (cell.isReply) {
//        
//    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)hideKeyboardToolBar {
    [_keyboardToolBar.textView setInputView:nil];
    [_keyboardToolBar becomeFirstResponder];
    [_keyboardToolBar resignFirstResponder];
    _keyboardToolBar.emotionButtonState = NO;
}

- (void)showKeyboardToolBar {
    [_keyboardToolBar becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideKeyboardToolBar];
    return;
    _keyboardToolBar.textView.inputView = nil;
    [_keyboardToolBar becomeFirstResponder];
//    _keyboardToolBar.hidden = YES;
    UIView *view = [EmotionView sharedInstance];
    if (view.superview) [view removeFromSuperview];
    if (_keyboardToolBar.superview) [_keyboardToolBar removeFromSuperview];
    if (!_keyboardToolBarIsDisappearing) {
        _keyboardToolBarIsDisappearing = YES;
        _keyboardToolBar.textView.inputView = nil;
        [_keyboardToolBar resignFirstResponder];
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
            [self hideKeyboardToolBar];
//            [_keyboardToolBar resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
//        else if (p.x >= CGRectGetMaxX(self.topBar.frame)-50) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
//            self.topBar.image = image;
//        }
    }

}


- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
}

- (IBAction)manButtonClicked:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;
    [self hideKeyboardToolBar];
    if (self.fromPersonInfoView) [self.navigationController popViewControllerAnimated:YES];
    else {
        PersonInfoViewController *controller = getViewControllerOfName(@"PersonInfo");
        controller.userInfo = self.userInfo;
        controller.fromChatView = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
}
@end
