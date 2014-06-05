//
//  FreshNewsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-3-4.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FreshNewsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShortMessageCell.h"
#import "MessageLogic.h"
#import "UserSimpleLogic.h"
#import "Timeline.h"
#import "DataManager.h"
#import "AppData.h"
#import "Message.h"
#import "UserInfo.h"
#import "UploadLogic.h"
#import "LikedList.h"
#import "KeyboardToolBar.h"
#import "Comment.h"
#import "CommentListView.h"
#import "MessageDetailViewController.h"
#import "LoadingImageView.h"
#import "EmotionView.h"
#import "FreshNewsMenu.h"
#import "EmotionTextView.h"

@interface FreshNewsViewController ()

@end

@implementation FreshNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    _data = [[NSMutableArray alloc] initWithObjects:@"asd", @"aaa", nil];
    _data = [[NSMutableArray alloc] init];
    _comments = [[NSMutableDictionary alloc] init];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.tableView.decelerationRate = 0.5;
    _currentPage = 0;
    _maxDataLoadedPage = 0;
    _backgroubdLoadData = NO;
    _backgroubdLoadWorking = NO;
    
    
    
//    return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"keyboardtoolbar" owner:self options:nil];
    _keyboardToolBar = [nibViews objectAtIndex:0];
    _keyboardToolBar.delegate = self;
    
    AppData *appData = [AppData sharedInstance];
    if (appData.timeline.mids.count == 0) {
        _moreMessageCell = 0;
        _updateAtTop = YES;
        _currentPage = 0;
        UIView *view = [self getActivityIndicator];
        if (!view.superview)
            [self.tableView addSubview:[self getActivityIndicator]];
        [self.tableView setContentOffset:CGPointMake(0, -35) animated:NO];
        [self beginToDownloadTimeline];
    }
    else {
        _currentPage = 0;
        _data = [[NSMutableArray alloc] init];
        NSArray *array = [[NSMutableArray alloc] initWithArray:[appData getMessagesInPage:0]];
        for (Message *message in array)
            [_data addObject:message.mid];
        _data = [[NSMutableArray alloc] initWithArray:[[[_data sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects]];

        _moreMessageCell = 1;
    }
    _reuid = -1;
    
    _loadDetail = NO;
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    _menu = getViewFromNib(@"freshnewsmenu", self);
    CGRect rect = _menu.frame;
    rect.origin.y = CGRectGetMaxY(self.topToolBar.frame) -2;
    rect.origin.x = CGRectGetMaxX(self.view.frame) - rect.size.width -2;
    _menu.frame = rect;
    [self.view addSubview:_menu];
    _menu.hidden = YES;
    _menu.delegate = self;
//    [UploadLogic downloadImage:@"bubble2.png"];
//    [UploadLogic uploadImages:[NSArray arrayWithObjects:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"empty" ofType:@"png"]],[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]], [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]],nil]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    FUNC_START();
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topToolBar.frame, point)) {
        if (point.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar2" ofType:@"png"]];
            self.topToolBar.image = image;
        }
        else if (point.x > CGRectGetMaxX(self.topToolBar.frame) - 50)
            [self menuButtonClicked];
    }
    else if (CGRectContainsPoint(self.btmToolBar.frame, point)) {
        int index = [self.btmToolBar calIndex:point];
        UIViewController *controller = getViewControllerOfName([NSString stringWithFormat:@"mainview%d", index]);
        UINavigationController *navigateController = self.navigationController;
        if (index != 5)
            [self.navigationController popViewControllerAnimated:NO];
        [navigateController pushViewController:controller animated:NO];
    }

    FUNC_END();
}

- (void)menuButtonClicked {
    if (!_menu.hidden) [self hideMenu];
    else [self showMenu];
//    showed = !showed;
}
- (void)showMenu {
    static BOOL isWorking = NO;
    if (isWorking) return;
    isWorking = YES;
    
    _menu.hidden = NO;
    _menu.alpha = 0;
    self.topToolBar.image = [UIImage imageNamed:@"topbar1.png"];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{_menu.alpha = 1; } completion:^(BOOL finished){ isWorking = NO;}];
}

- (void)hideMenu {
    static BOOL isWorking = NO;
    if (isWorking) return;
    isWorking = YES;
    self.topToolBar.image = [UIImage imageNamed:@"topbar0.png"];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{_menu.alpha = 0; } completion:^(BOOL finished){_menu.alpha = 1; _menu.hidden = YES; isWorking = NO;}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FUNC_START();
    FUNC_END();
}

- (void)keyboardFrameDidChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    if (rect.origin.y >= self.view.frame.size.height) {
        _keyboardToolBar.hidden = YES;
        if (_keyboardToolBar.superview) [_keyboardToolBar removeFromSuperview];
    }
    else {
        _keyboardToolBar.hidden = NO;
        CGRect rect0 = _keyboardToolBar.frame;
        rect0.origin.y = rect.origin.y - _keyboardToolBar.frame.size.height;
        _keyboardToolBar.frame = rect0;
        if (!_keyboardToolBar.superview)
            [self.view.window addSubview:_keyboardToolBar];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_loadDetail) {
        [self.tableView reloadData];
        _loadDetail = NO;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    return;
    EmotionTextView *textView = [[EmotionTextView alloc] initWithFrame:CGRectMake(0, 100, 176, 0)];
    textView.text = @"你";
    textView.len = 30;
    textView.font = [UIFont boldSystemFontOfSize:16];
    CGRect rect = textView.frame;
    [textView work];
    rect.size.height = textView.height;
    textView.frame = rect;
//    [textView drawRect:textView.frame];
//    textView.backgroundColor = [UIColor blackColor];
//    [textView setNeedsDisplay];
    [self.view.window addSubview:textView];
    LOG(@"%f", textView.height);

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count + _moreMessageCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ShortMessageCell";
    static NSString *CellIdentifier1 = @"MoreMessageCell";
    if (indexPath.row == _data.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        return cell;
    }
    
    ShortMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[ShortMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    AppData *appData = [AppData sharedInstance];
    Message *message =  [appData getMessageOfMid: [[_data objectAtIndex:indexPath.row] intValue]];
    cell.textView.text = message.content;
    
    
    UserInfo *userInfo = [appData readUserInfoForId:[message.uid intValue]];
    if (userInfo)
        cell.username.text = userInfo.username;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    cell.time.text = [format stringFromDate:message.time];
    
    cell.delegate = self;
    {
        CGRect rect = cell.imageContainer.frame;
        rect.size.height = 0;
        [cell.imageContainer removeFromSuperview];
        cell.imageContainer = [[UIView alloc] initWithFrame:rect];
        [cell.bgView addSubview:cell.imageContainer];
    }
    
    int imageSize = message.picNames.count / 2;
    CGFloat max_height = 0;
    for (int i = 0; i < imageSize; i++) {
        CGRect rect;
        CGFloat width = CGRectGetWidth(cell.bgView.frame);
        if (imageSize == 1) rect = CGRectMake((width - ONEIMAGE_HEIGHT)/2, 0, ONEIMAGE_HEIGHT, ONEIMAGE_HEIGHT);
        else if (imageSize == 2) rect = CGRectMake((width-TWOIMAGE_HEIGHT*2-BETWEEN_IMAGE)/2+i*(TWOIMAGE_HEIGHT+BETWEEN_IMAGE), 0, TWOIMAGE_HEIGHT, TWOIMAGE_HEIGHT);
        else if (imageSize == 4) rect = CGRectMake((width-TWOIMAGE_HEIGHT*2-BETWEEN_IMAGE)/2+i%2*(TWOIMAGE_HEIGHT+BETWEEN_IMAGE), (TWOIMAGE_HEIGHT+BETWEEN_IMAGE)*(i/2), TWOIMAGE_HEIGHT, TWOIMAGE_HEIGHT);
        else {
            int line = i / 3;
            CGFloat tmp = (width - SMALLIMAGE_HEIGHT * 3 - 2 * BETWEEN_IMAGE) / 2;
            rect = CGRectMake((BETWEEN_IMAGE+SMALLIMAGE_HEIGHT)*(i%3)+tmp, (BETWEEN_IMAGE+SMALLIMAGE_HEIGHT)*line, SMALLIMAGE_HEIGHT, SMALLIMAGE_HEIGHT);
        }
        if (CGRectGetMaxY(rect)+BOTTOM_HEIGHT>max_height) max_height = CGRectGetMaxY(rect) + BOTTOM_HEIGHT;
        UIImage *image = [appData getImage:[message.picNames objectAtIndex:i*2]];
        if (image) {
            UIImageView *view = [[UIImageView alloc] initWithImage:image];
                        view.frame = rect;
            [cell.imageContainer addSubview:view];
        }
        else {
            UIView *view = getViewFromNib(@"loadingimageview", self);
            view.frame = rect;
            [cell.imageContainer addSubview:view];
            if (![_downloadingImageSet containsObject:[message.picNames objectAtIndex:i*2]]) {
                [_downloadingImageSet addObject:[message.picNames objectAtIndex:i*2]];
                [UploadLogic downloadImage:[message.picNames objectAtIndex:i*2] from:NSStringFromClass(self.class)];
            }
        }
    }
    
    //点赞信息
    LikedList *likedList = [appData getLikedListOfMid:[message.mid intValue]];
    cell.likedList = [[NSMutableArray alloc] init];
    for (int i = likedList.userList.count - 1; i >= 0; i--) {
//    for (NSNumber *uid in likedList.userList) {
        NSNumber *uid = [likedList.userList objectAtIndex:i];
        UserInfo *userInfo0 = [appData readUserInfoForId:[uid intValue]];
        if (userInfo0.username)
            [cell.likedList addObject:userInfo0.username];

    }
    BOOL hasLikedList = cell.likedList.count > 0;
    
    User *user = [UserSimpleLogic user];
    if ([likedList.userList containsObject:[NSNumber numberWithInt:user.uid]])
        cell.liked = YES;
    else
        cell.liked = NO;
    [cell update];
    
    //评论列表
    BOOL hasComment = NO;
    CGFloat commentViewHeight = 0;
    NSDictionary *dic = [_comments objectForKey:message.mid];
    if (dic) {
        hasComment = YES;
        commentViewHeight = [[dic objectForKey:@"height"] floatValue];
    }
    cell.commentList = [[NSMutableArray alloc] init];
    cell.userList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic0 in [dic objectForKey:@"list"]) {
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        UserInfo *userInfo = [appData readUserInfoForId:[[dic0 objectForKey:@"uid"] intValue]];
        [tmp setObject:userInfo.username forKey:@"user"];
        NSNumber *reuid = [dic0 objectForKey:@"reuid"];
        if ([reuid intValue] != -1) {
            userInfo = [appData readUserInfoForId:[reuid intValue]];
            [tmp setObject:userInfo.username forKey:@"reuser"];
        }
        [tmp setObject:[dic0 objectForKey:@"content"] forKey:@"content"];
        [cell.commentList addObject:tmp];
        [cell.userList addObject:[dic0 objectForKey:@"uid"]];
    }
    [cell updateCommentList];
    
    // 调整cell中各个view的frame
    CGFloat bgh = SHORTMESSAGECELL_BGVIEW_HEIGHT;
    CGRect rect = cell.textView.frame;
    rect.size.height = [self calculateTextViewHeight:message.content];
    cell.textView.frame = rect;
    CGFloat origin_y = CGRectGetMaxY(rect);
    
    if (message.picNames.count == 0) {
        cell.imageContainer.hidden = YES;
    }
    else {
        cell.imageContainer.hidden = NO;
        rect = cell.imageContainer.frame;
        rect.origin.y = origin_y;
        rect.size.height = max_height;
        cell.imageContainer.frame = rect;
        origin_y = CGRectGetMaxY(rect);
    }
    
    rect = cell.cellBar.frame;
    rect.origin.y = origin_y;//CGRectGetMaxY(cell.textView.frame);
    cell.cellBar.frame = rect;
    origin_y = CGRectGetMaxY(rect);
    
    if (!hasLikedList) cell.likedListView.hidden = YES;
    else {
        cell.likedListView.hidden = NO;
        rect = cell.likedListView.frame;
        rect.origin.y = origin_y;
        cell.likedListView.frame = rect;
        origin_y = CGRectGetMaxY(rect);
    }
    
    if (!hasComment) {
        cell.commentBgView.hidden = YES;
        bgh = origin_y;
    }
    else {
        cell.commentBgView.hidden = NO;
       
        rect = cell.commentListView.frame;
        rect.origin.y = 0;
        rect.size.height = commentViewHeight;
        cell.commentListView.frame = rect;
        rect = cell.commentField.frame;
        rect.origin.y = CGRectGetMaxY(cell.commentListView.frame);
        cell.commentField.frame = rect;
        rect = cell.commentBgView.frame;
        rect.origin.y = origin_y;
        rect.size.height = CGRectGetMaxY(cell.commentField.frame)+6;
        cell.commentBgView.frame = rect;
        bgh = CGRectGetMaxY(rect);
    }
    rect = cell.bgView.frame;
    rect.size.height = bgh;
    cell.bgView.frame = rect;
    
    LOG(@"row %d %f", indexPath.row, rect.size.height);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _data.count) return 50;
    Message *message = [[AppData sharedInstance] getMessageOfMid:[[_data objectAtIndex:indexPath.row] intValue] ];
    CGFloat ret = 60 + [self calculateTextViewHeight:message.content] + 37;
    
//    ret = SHORTMESSAGRCELL_HEIGHT + [self calculateTextViewHeight:message.content] - TEXTVIEW_HEIGHT;
    AppData *appData = [AppData sharedInstance];
    LikedList *likedList = [appData getLikedListOfMid:[message.mid intValue]];
    if (likedList.userList.count)
        ret += LIKEDLISTVIEW_HEIGHT;
    if (message.picNames.count) {
        const CGFloat x = BOTTOM_HEIGHT;
        if (message.picNames.count/2 >= 3 && message.picNames.count/2!=4)
            ret+=(BETWEEN_IMAGE+SMALLIMAGE_HEIGHT)*((message.picNames.count/2-1)/3+1)-BETWEEN_IMAGE+x;
        else if (message.picNames.count/2 == 1)
            ret+=ONEIMAGE_HEIGHT+x;
        else if (message.picNames.count/2 == 2) ret+=TWOIMAGE_HEIGHT+x;
        else ret+= TWOIMAGE_HEIGHT*2+BETWEEN_IMAGE+x;
    }
    Comment *comment = [appData getCommentOfMid:[message.mid intValue]];
    if (comment.commentList.count == 0) return ret + 5;
    NSMutableString *string = [[NSMutableString alloc] init];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in comment.commentList) {
        NSNumber *uid = [dic objectForKey:@"uid"];
        NSNumber *reuid = [dic objectForKey:@"reuid"];
        UserInfo *userInfo1 = [appData readUserInfoForId:[uid intValue]];
        if (!userInfo1) continue;
        if ([reuid intValue] != -1) {
            UserInfo *userInfo2 = [appData readUserInfoForId:[reuid intValue]];
            if (!userInfo2) continue;
            NSString *tmp = [NSString stringWithFormat:@"%@回复%@: %@\n", userInfo1.username, userInfo2.username, [dic objectForKey:@"content"]];
            [string appendString:tmp];
        }
        else
        [string appendString:[NSString stringWithFormat:@"%@: %@\n", userInfo1.username, [dic objectForKey:@"content"]]];
        [list addObject:dic];
    }
    if (list.count) {
        CGFloat height = [self calculateCommentViewHeight:string];
        [_comments setObject:@{@"list":list, @"height": [NSNumber numberWithFloat:height]} forKey:message.mid];
        ret += [self calculateCommentViewHeight:string] + 34 + 4 ;
    }
    ret += 5;
    return ret;
}

- (CGFloat)calculateTextViewHeight:(NSString *)string {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(TEXTVIEW_WIDTH-20, FLT_MAX)];
    return size.height + 20;
}

- (CGFloat)calculateCommentViewHeight:(NSString *)string {
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(COMMENTLISTVIEW_WIDTH-5, FLT_MAX)];
    return size.height + 16;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (p.y < -35) {
        UIView *view = [self getActivityIndicator];
        if (!view.superview)
            [scrollView addSubview:[self getActivityIndicator]];
        [self beginToDownloadTimeline];
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideMenu];
//    [_keyboardToolBar resignFirstResponder];
    [self hideKeyboardToolBar];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
        [self workAtIndexpath:indexPath];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    [self workAtIndexpath:indexPath];
}

// 到达indexPath时处理的工作
- (void)workAtIndexpath:(NSIndexPath *)indexPath {
    LOG(@"current %d max %d", _currentPage, _maxDataLoadedPage);
    int row = indexPath.row;
    int tmp = row / PAGE_MESSAGE_COUNT;
    AppData *appData = [AppData sharedInstance];
    if (_currentPage != tmp) {
        int len = PAGE_MESSAGE_COUNT;
        if (appData.timeline.mids.count - tmp * PAGE_MESSAGE_COUNT < PAGE_MESSAGE_COUNT)
            len = appData.timeline.mids.count - tmp * PAGE_MESSAGE_COUNT;
        [MessageLogic downloadLikedList:[appData.timeline.mids subarrayWithRange:NSMakeRange(tmp*PAGE_MESSAGE_COUNT, len)]];
        [MessageLogic downloadCommentList:[appData.timeline.mids subarrayWithRange:NSMakeRange(tmp*PAGE_MESSAGE_COUNT, len)]];
    }
    _currentPage = tmp;//row / PAGE_MESSAGE_COUNT;
    if (_currentPage < _maxDataLoadedPage) return;
    if (_backgroubdLoadWorking) return;
    _backgroubdLoadWorking = YES;
    
    if (_data.count - row < 15) {
        NSArray *messageNeedDownload = [appData messagesNeedDownloadFromIndex:_data.count];
        if (messageNeedDownload.count == 0) {
            NSArray *messages = [appData getMessagesInPage:_currentPage + 1];
            for (Message *message in messages)
                [_data addObject:message.mid];
            [self.tableView reloadData];
            _backgroubdLoadWorking = NO;
            _maxDataLoadedPage = _currentPage + 1;
        }
        else {
            _backgroubdLoadData = YES;
            _backgroubdLoadDataAtIndex = -1;
            L([messageNeedDownload description]);
            [MessageLogic downloadMessages:messageNeedDownload];
        }
        return;
    }
    else if (row % PAGE_MESSAGE_COUNT < PAGE_MESSAGE_COUNT * 2 / 3) {
        _backgroubdLoadWorking = NO;
        return;
    }
    int mid1 = [[_data objectAtIndex:_currentPage * PAGE_MESSAGE_COUNT] intValue];
    int mid2 = [[_data objectAtIndex:_currentPage * PAGE_MESSAGE_COUNT + 1] intValue];
    Message *message1 = [appData getMessageOfMid:mid1];
    Message *message2 = [appData getMessageOfMid:mid2];
    
    int index1 = [appData.timeline.mids indexOfObject:message1.mid];
    int index2 = [appData.timeline.mids indexOfObject:message2.mid];
    if (index2 - index1 == 1) return;
    NSArray *messageNeedDownload = [appData messagesNeedDownloadFromIndex:index1+1];
    if (messageNeedDownload.count == 0) {
        NSArray *messages = [appData getMessagesInPage:_currentPage + 1];
        for (Message *message in messages) {
            if ([message2.mid isEqualToNumber:message.mid]) break;
            [_data addObject:message.mid];
        }
        [self.tableView reloadData];
        _backgroubdLoadWorking = NO;
        _maxDataLoadedPage = _currentPage + 1;
    }
    else {
        _backgroubdLoadData = YES;
        _backgroubdLoadDataAtIndex = _currentPage * PAGE_MESSAGE_COUNT + 1;
        [MessageLogic downloadMessages:messageNeedDownload];
    }
    

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (p.y < -35)
    [scrollView setContentOffset:CGPointMake(0, -35) animated:NO];
}

- (void)beginToDownloadTimeline {
    if (_timelineDownloading) return;
    _timelineDownloading = YES;
    [MessageLogic downloadTimeline];
}

- (void)dataDidDownload:(NSNotification *)notification {
    FUNC_START();
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        FUNC_END();
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADTIMELINE])
        [self timelineDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADMESSAGES])
        [self messageDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADUSERINFOS])
        [self userInfoDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADLIKEDLIST])
        [self likedListDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCOMMENTLIST])
        [self commentListDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
    FUNC_END();
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self.tableView reloadData];
}


- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)timelineDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        L(@"local timeline newest");
        [self hideTopActivityIndicator];
//        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        _timelineDownloading = NO;
        [self.tableView reloadData];
        return;
    }
    _maxDataLoadedPage = 0;
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSArray *mids = [data objectForKey:@"mids"];
    int seq = [[data objectForKey:@"seq"] intValue];
    AppData *appData = [AppData sharedInstance];
    for (int i = mids.count - 1, j = 0; i >= 0; i--, j++) {
        if ([appData.timeline.mids containsObject:[mids objectAtIndex:i]]) break;
        if (!j || j < appData.timeline.mids.count)
            [appData.timeline.mids insertObject:[mids objectAtIndex:i] atIndex:j];
        else [appData.timeline.mids addObject:[mids objectAtIndex:i]];
    }
    [appData.timeline update];
    appData.timeline.seq = [NSNumber numberWithInt:seq];
    [AppData saveData];
    NSArray *messageNeedDownload = [appData messagesNeedDownload];
    [MessageLogic downloadMessages:messageNeedDownload];
    LOG(@"messageneeddownload %@", [messageNeedDownload description]);
    
//    [MessageLogic downloadLikedList:[appData.timeline.mids subarrayWithRange:NSMakeRange(0, PAGE_MESSAGE_COUNT)]];
//    [MessageLogic downloadCommentList:[appData.timeline.mids subarrayWithRange:NSMakeRange(0, PAGE_MESSAGE_COUNT)]];

    _timelineDownloading = NO;
}

- (void)likedListDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"likedlist download succ");
    else L(@"likedlist download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    AppData *appData = [AppData sharedInstance];
    for (NSNumber *mid in [data allKeys]) {
        NSDictionary *dic = [data objectForKey:mid];
        LikedList *likedList = [appData getLikedListOfMid:[mid intValue]];
        likedList.seq = [dic objectForKey:@"seq"];
        likedList.userList = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"list"]];
        for (NSNumber *uid in likedList.userList)
            if (![uids containsObject:uid]) [uids addObject:uid];
        [likedList update];
    }
    [AppData saveData];
    NSArray *userInfoNeedDownload = [appData userInfosNeedDownload:uids];
    if (userInfoNeedDownload.count) {
        [UserSimpleLogic downloadUseInfos:userInfoNeedDownload from:NSStringFromClass(self.class)];
    }
    [self.tableView reloadData];
}

- (void)commentListDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"commentlist download succ");
    else L(@"commentlist download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    for (NSNumber *mid in [data allKeys]) {
        NSDictionary *dic = [data objectForKey:mid];
        
        Comment *comment = [appData getCommentOfMid:[mid intValue]];
        comment.seq = [dic objectForKey:@"seq"];
        comment.commentList = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"list"]];
        for (NSDictionary *cc in comment.commentList) {
//            L([cc description]);
            NSNumber *uid = [cc objectForKey:@"uid"];
            if (uid && ![uids containsObject:uid]) [uids addObject:uid];
            uid = [cc objectForKey:@"reuid"];
            if (uid && [uid intValue] != -1 && ![uids containsObject:uid]) [uids addObject:uid];
        }
        [comment update];
    }
    [AppData saveData];
    NSArray *userInfoNeedDownload = [appData userInfosNeedDownload:uids];
    if (userInfoNeedDownload.count) {
        [UserSimpleLogic downloadUseInfos:userInfoNeedDownload from:NSStringFromClass(self.class)];
    }
    
//    [self.tableView reloadData];
}

- (void)messageDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"message download succ");
    else L(@"message download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    AppData *appData = [AppData sharedInstance];
//    int nowCount = _data.count;
    for (NSString *key in [[data allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSDictionary *obj = [data objectForKey:key];
        Message *message = [appData messgeForId:[key intValue]];
        if ([[obj objectForKey:@"seq"] intValue] == [message.seq intValue]) continue;
        message.seq = [obj objectForKey:@"seq"];
        message.mid = [obj objectForKey:@"mid"];
        message.content = [obj objectForKey:@"content"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        message.time = [format dateFromString:[obj objectForKey:@"time"]];
        message.type = [obj objectForKey:@"type"];
        message.sharedCount = [obj objectForKey:@"sharedcount"];
        message.likedList = [obj objectForKey:@"likedlist"];
        message.uid = [obj objectForKey:@"uid"];
        message.picNames = [obj objectForKey:@"pics"];
        if (!message.picNames) message.picNames = [NSMutableArray array];
        [message update];
        if (![_data containsObject:message.mid])
            [_data addObject:message.mid];
//        if (!_backgroubdLoadData)
//        [_data insertObject:message atIndex:0];
//        else {
//            if (_backgroubdLoadDataAtIndex == -1)
//                [_data insertObject:message atIndex:nowCount];
//            else [_data insertObject:message atIndex:_backgroubdLoadDataAtIndex];
//        }
        if (![uids containsObject:message.uid])
            [uids addObject:message.uid];
    }
    [AppData saveData];
    _data =  [[NSMutableArray alloc] initWithArray:[[[_data sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects]];
    [self.tableView reloadData];
    
    int count = _data.count - PAGE_MESSAGE_COUNT * _currentPage;
    if (count > PAGE_MESSAGE_COUNT) count = PAGE_MESSAGE_COUNT;
    [MessageLogic downloadLikedList:[_data subarrayWithRange:NSMakeRange(_currentPage*PAGE_MESSAGE_COUNT, count)]];
    [MessageLogic downloadCommentList:[_data subarrayWithRange:NSMakeRange(_currentPage*PAGE_MESSAGE_COUNT, count)]];

    
    //[_data sortedArrayUsingSelector:@selector(compare:)];
    
    NSArray *userInfoNeedDownload = [appData userInfosNeedDownload:uids];
    if (userInfoNeedDownload.count) {
        [UserSimpleLogic downloadUseInfos:userInfoNeedDownload from:NSStringFromClass(self.class)];
    }
    
    if (_updateAtTop) {
        [self performSelector:@selector(hideTopActivityIndicator) withObject:nil afterDelay:0.0];
//        [self hideTopActivityIndicator];
    }
    _updateAtTop = NO;
    _moreMessageCell = 1;
//    if (!_backgroubdLoadData)
    [self.tableView reloadData];
    if (_backgroubdLoadData) {
        _backgroubdLoadWorking = NO;
        _maxDataLoadedPage = _currentPage + 1;
        _backgroubdLoadData = NO;
    }
//    L([notification.userInfo description]);
}

- (void)userInfoDidDownload:(NSNotification *)notification {
    FUNC_START();
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"userInfo download succ");
    else L(@"userInfo download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    [UserSimpleLogic userInfosDidDownload:data];
    [self.tableView reloadData];
    FUNC_END();
}

// 位于顶部的更新标志
- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.view.frame)-len / 2, -len, len, len);
    }
    _activityIndicator.hidden = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}

- (void)likeMessage:(id)sender {
//    return;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    Message *message = [[AppData sharedInstance]getMessageOfMid: [[_data objectAtIndex:indexPath.row] intValue] ];
    [MessageLogic likeMessage:[message.mid intValue]];
    LikedList *likedList = [[AppData sharedInstance] getLikedListOfMid:[message.mid intValue]];
    User *user = [MessageLogic user];
    [likedList.userList addObject:[NSNumber numberWithInt:user.uid]];
    [likedList update];
    [AppData saveData];
    [self.tableView reloadData];
}

- (void)dislikeMessage:(id)sender {
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    Message *message = [[AppData sharedInstance] getMessageOfMid:[[_data objectAtIndex:indexPath.row] intValue] ];
    [MessageLogic dislikeMessage:[message.mid intValue]];
    LikedList *likedList = [[AppData sharedInstance] getLikedListOfMid:[message.mid intValue]];
    User *user = [MessageLogic user];
    if ([likedList.userList containsObject:[NSNumber numberWithInt:user.uid]])
        [likedList.userList removeObject:[NSNumber numberWithInt:user.uid]];
    [likedList update];
    [AppData saveData];
    [self.tableView reloadData];

}

- (void)commentMessage:(id)sender {
    
}

- (void)willShowMessageDetail:(id)sender {
    int index = [self.tableView indexPathForCell:sender].row;
    ShortMessageCell *cell = (ShortMessageCell *)sender;
    Message *message = [[AppData sharedInstance] getMessageOfMid:[[_data objectAtIndex:index] intValue] ];

    MessageDetailViewController *controller = getViewControllerOfName(@"MessageDetail");
    controller.downloadingImageSet = _downloadingImageSet;
    controller.message = message;
    controller.liked = cell.liked;
    controller.likedList = cell.likedList;
    controller.commentList = cell.commentList;
    controller.userList = cell.userList;
    _loadDetail = YES;
//    [controller update];
//    [controller updateCommentList];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)shareMessage:(id)sender {
    
}

- (void)beginToComment:(id)sender {
    [MessageLogic sendMessage:@"你好你好你好你好你好你好你好你好你好你好你好你好你好你好" toUid:281];
    int index = [self.tableView indexPathForCell:sender].row;
    Message *message = [[AppData sharedInstance] getMessageOfMid:[[_data objectAtIndex:index] intValue] ];
    _commentingMid = [message.mid intValue];
    ShortMessageCell *cell = (ShortMessageCell *)sender;
    _reuid = cell.targetUid;
    if (_reuid != -1) {
        UserInfo *userInfo = [[AppData sharedInstance] readUserInfoForId:_reuid];
        _keyboardToolBar.placeHolder = [NSString stringWithFormat:@"回复 %@:", userInfo.username];
    }
    else _keyboardToolBar.placeHolder = @"";
//    LOG(@"reuid %d", _reuid);
    [_keyboardToolBar becomeFirstResponder];
//    _firstResponder = cell.commentField;
}

- (void)sendText:(NSString *)text {
    AppData *appData = [AppData sharedInstance];
    Comment *comment = [appData getCommentOfMid:_commentingMid];
    User *user = [MessageLogic user];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt: user.uid] forKey:@"uid"];
    [dic setObject:[NSNumber numberWithInt:_reuid] forKey:@"reuid"];
    [dic setObject:text forKey:@"content"];
    [comment.commentList addObject:dic];
    [comment update];
    [AppData saveData];
    [self.tableView reloadData];
    if (_reuid == -1)
        [MessageLogic commentMessage:_commentingMid withContent:text];
    else {
        [MessageLogic replyUser:_reuid atMessage:_commentingMid withContent:text];
        _reuid = -1;
    }
    
    [_keyboardToolBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)hideKeyboardToolBar {
    [_keyboardToolBar.textView setInputView:nil];
    [_keyboardToolBar becomeFirstResponder];
    [_keyboardToolBar resignFirstResponder];
    _keyboardToolBar.emotionButtonState = NO;
}

- (void)emotionDidSelected:(NSDictionary *)info {
    
}

@end


