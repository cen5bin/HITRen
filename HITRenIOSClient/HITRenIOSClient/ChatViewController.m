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
#import "DateCell.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
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
//    [self reloadData];
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
        [self reloadData];
//        [self.tableView reloadData];
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
        [self reloadData];
//        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

- (void)reloadData {
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData lastNoticeOfUid:[self.userInfo.uid intValue]];
    int count = _keyboardToolBar.hidden?10:5;
    if (notice.notices.count > count)
        _datas = [[NSMutableArray alloc] initWithArray:notice.notices];
    else {
        Notice *notice1 = [appData getNoticeOfUid:[self.userInfo.uid intValue] atIndex:[notice.index intValue]-1];
        _datas = [[NSMutableArray alloc] init];
        for (id obj in notice1.notices) [_datas addObject:obj];
        for (id obj in notice.notices) [_datas addObject:obj];
    }
    if (_datas.count > count)
        _datas = [NSMutableArray arrayWithArray: [_datas subarrayWithRange:NSMakeRange(_datas.count-count, count)]];
    [self addDate];
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)reloadRecord {
    int count = 0;
    for (id obj in _datas)
        if ([obj isKindOfClass:[NoticeObject class]]) count++;
    int num = count / PAGE_NOTICE_COUNT;
    if (count % PAGE_NOTICE_COUNT) num++;
    AppData *appData = [AppData sharedInstance];
    Notice *notice = [appData lastNoticeOfUid:[self.userInfo.uid intValue]];
    Notice *notice1 = [appData getNoticeOfUid:[self.userInfo.uid intValue] atIndex:[notice.index intValue]-num];
    int count1 = notice.notices.count;
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (id obj in notice1.notices) {
        count1--;
        [tmp addObject:obj];
        if (count1 == 0) break;
    }
//        else break;
    for (id obj in _datas)
        if ([obj isKindOfClass:[NoticeObject class]])
            [tmp addObject:obj];
    _datas = tmp;
    [self addDate];
    [self.tableView reloadData];
    [self performSelector:@selector(resetTableView) withObject:nil afterDelay:0.3];
    
//    _loadingRecord = NO;
}

- (void)resetTableView {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    UIView *view = [self getActivityIndicator];
    view.hidden = YES;
    [view removeFromSuperview];
}

- (void)addDate {
    NSArray *tmp = [NSArray arrayWithArray:_datas];
    _datas = [[NSMutableArray alloc] init];
    NSDate *date = nil;
    int count = 0;
    for (NoticeObject *obj in tmp) {
        if (date == nil) {
            date = obj.date;
            [_datas addObject:date];
            [_datas addObject:obj];
            count = 0;
            continue;
        }
        if ([obj.date timeIntervalSinceDate:date] < 60) {
            count++;
            if (count == 5) {
                [_datas addObject:obj.date];
                count = 0;
                date = obj.date;
            }
            [_datas addObject:obj];
        }
        else {
            [_datas addObject:obj.date];
            [_datas addObject:obj];
            date = obj.date;
        }
    }

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
    static NSString *CellIdentifier1 = @"DateCell";
    id obj = [_datas objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NoticeObject class]]) {
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
        return cell;
    }
    else {
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        if (!cell) cell = [[DateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        cell.dateLabel.text = [formater stringFromDate:obj];
        return cell;
    }
}

- (void)lockLoadingRecord {
    _loadingRecord = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (p.y < - 35) {
        if (_loadingRecord) return;
        _loadingRecord = YES;
        UIView *view = [self getActivityIndicator];
        if (view.superview) return;
//        if (!view.superview)
        [self.tableView addSubview:view];
        view.hidden = NO;
        [self performSelector:@selector(reloadRecord) withObject:nil afterDelay:0.1];
//        [self reloadRecord];
        [self performSelector:@selector(lockLoadingRecord) withObject:nil afterDelay:5];
    }
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
    id obj = [_datas objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NoticeObject class]]) {
        CGFloat tmp = 0;
        if (indexPath.row == _datas.count - 1 && _keyboardToolBar.hidden) tmp = _keyboardToolBarAtBottom.frame.size.height;
        return [ChatCell calculateCellHeight:[((NoticeObject *)obj).content objectForKey:@"text"]] + tmp;
    }
    else return 20;
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

- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.view.frame)-len / 2, -len, len, len);
    }
    _activityIndicator.hidden = YES;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}

@end
