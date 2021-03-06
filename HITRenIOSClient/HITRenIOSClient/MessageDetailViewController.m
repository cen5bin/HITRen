//
//  MessageDetailViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-23.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Message.h"
#import "AppData.h"
#import "UserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentListView.h"
#import "MessageLogic.h"
#import "LikedList.h"
#import "UserInfo.h"
#import "KeyboardToolBar.h"
#import "Comment.h"
#import "UploadLogic.h"
#import "MyActivityIndicatorView.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

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
    CGFloat tmp = 220;
    self.cellBar.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.cellBar.layer.borderWidth = 0.5;
    self.scrollView.layer.borderWidth = 0.5;
    self.scrollView.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.likedListView.layer.borderWidth = 0.5;
    self.likedListView.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.commentListView.commentListViewDelegate = self;
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"keyboardtoolbar" owner:self options:nil];
    _keyboardToolBar = [nibViews objectAtIndex:0];
    _keyboardToolBar.delegate = self;
    
    self.targetUid = -1;
    
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@",ASYNCDATALOADED, CLASS_NAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:notificationName object:nil];
//    _downloadingImageSet = [[NSMutableSet alloc] init];
    [MessageLogic downloadCommentList:[NSArray arrayWithObjects:self.message.mid, nil] from:CLASS_NAME];
    [MessageLogic downloadLikedList:[NSArray arrayWithObjects:self.message.mid, nil] from:CLASS_NAME];
    _myActivityIndicatorView = getViewFromNib(@"MyActivityIndicatorView", self);
    _myActivityIndicatorView.textLabel.text = @"正在加载";
    [_myActivityIndicatorView showInView:self.view];
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        FUNC_END();
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCOMMENTLIST])
        [self commentListDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADLIKEDLIST])
        [self likedListDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADUSERINFOS])
        [self userInfoDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self loadContent];
//    [self.tableView reloadData];
}

- (void)userInfoDidDownload:(NSNotification *)notification {
    FUNC_START();
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"userInfo download succ");
    else L(@"userInfo download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    [UserSimpleLogic userInfosDidDownload:data];
    [self loadContent];
//    [self.tableView reloadData];
    FUNC_END();

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
    //    NSArray *userInfoNeedDownload = [appData userInfosNeedDownload:uids];
    //    if (userInfoNeedDownload.count) {
    [UserSimpleLogic downloadUseInfos:uids from:NSStringFromClass(self.class)];
    //    }
    [self loadContent];
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
    //    NSArray *userInfoNeedDownload = [appData userInfosNeedDownload:uids];
    //    if (userInfoNeedDownload.count) {
    [UserSimpleLogic downloadUseInfos:uids from:NSStringFromClass(self.class)];
    //    }
    [self loadContent];
    [_myActivityIndicatorView hide];
    //    [self.tableView reloadData];
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
    [self loadContent];
}

- (void)loadContent {
    AppData *appData = [AppData sharedInstance];
    UserInfo *userInfo = [appData readUserInfoForId:[self.message.uid intValue]];
    self.usernameLabel.text = userInfo.username;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.timeLabel.text = [format stringFromDate:self.message.time];
    self.textView.text = self.message.content;
    
    if (userInfo.pic && ![userInfo.pic isEqualToString:@""]) {
        if (!userInfo.pic||!userInfo.pic.length)
            self.pic.image = [UIImage imageNamed:@"empty.png"];
        else if ([[userInfo.pic substringToIndex:1] isEqualToString:@"h"])
            self.pic.image = [UIImage imageNamed:userInfo.pic];
        else {
            UIImage *image = [appData getImage:userInfo.pic];
            if (image) self.pic.image = image;
            else if (!_downloadIngImage) {
                _downloadIngImage = YES;
                [UploadLogic downloadImage:userInfo.pic from:NSStringFromClass(self.class)];
            }
        }
    }
    
    
    Comment *comment = [appData getCommentOfMid:[self.message.mid intValue]];
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
    self.commentList = [[NSMutableArray alloc] init];
//    cell.userList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic0 in list) {
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        UserInfo *userInfo = [appData readUserInfoForId:[[dic0 objectForKey:@"uid"] intValue]];
        [tmp setObject:userInfo.username forKey:@"user"];
        NSNumber *reuid = [dic0 objectForKey:@"reuid"];
        if ([reuid intValue] != -1) {
            userInfo = [appData readUserInfoForId:[reuid intValue]];
            [tmp setObject:userInfo.username forKey:@"reuser"];
        }
        [tmp setObject:[dic0 objectForKey:@"content"] forKey:@"content"];
        [self.commentList addObject:tmp];
//        [cell.userList addObject:[dic0 objectForKey:@"uid"]];
    }
    
    LikedList *likedList = [appData getLikedListOfMid:[self.message.mid intValue]];
    self.likedList = [[NSMutableArray alloc] init];
    for (int i = likedList.userList.count - 1; i >= 0; i--) {
        //    for (NSNumber *uid in likedList.userList) {
        NSNumber *uid = [likedList.userList objectAtIndex:i];
        UserInfo *userInfo0 = [appData readUserInfoForId:[uid intValue]];
        if (userInfo0.username)
            [self.likedList addObject:userInfo0.username];
    }

    
    [self update];
    [self updateCommentList];
    
    CGRect rect = self.textView.frame;
    rect.size.height = [self calculateTextViewHeight:self.textView.text];
    self.textView.frame = rect;
    
    CGFloat origin_y = CGRectGetMaxY(rect);
    
    Message *message = self.message;
    int imageSize = message.picNames.count / 2;
    CGFloat max_height = 0;
    for (int i = 0; i < imageSize; i++) {
        CGRect rect;
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
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
            [self.imageContainer addSubview:view];
        }
        else {
            UIView *view = getViewFromNib(@"loadingimageview", self);
            view.frame = rect;
            [self.imageContainer addSubview:view];
            if (![_downloadingImageSet containsObject:[message.picNames objectAtIndex:i*2]]) {
                [_downloadingImageSet addObject:[message.picNames objectAtIndex:i*2]];
                [UploadLogic downloadImage:[message.picNames objectAtIndex:i*2] from:NSStringFromClass(self.class)];
            }
        }
    }
    if (message.picNames.count == 0) {
        self.imageContainer.hidden = YES;
    }
    else {
        self.imageContainer.hidden = NO;
        rect = self.imageContainer.frame;
        rect.origin.y = origin_y;
        rect.size.height = max_height;
        self.imageContainer.frame = rect;
        origin_y = CGRectGetMaxY(rect);
    }

    
    
    rect = self.cellBar.frame;
    rect.origin.y = origin_y;//CGRectGetMaxY(self.textView.frame);
    self.cellBar.frame = rect;
    
    origin_y = CGRectGetMaxY(rect);
    if (self.likedList.count) {
        self.likedListView.hidden = NO;
        rect = self.likedListView.frame;
        rect.origin.y = origin_y;
        self.likedListView.frame = rect;
        origin_y = CGRectGetMaxY(rect);
    }
    else {
        self.likedListView.hidden = YES;
    }
    
    if (self.commentList.count) {
        self.commentListView.hidden = NO;
        rect = self.commentListView.frame;
        rect.origin.y = origin_y;
        rect.size.height = [self calculateCommentViewHeight:self.commentListView.text];
        self.commentListView.frame = rect;
        if (CGRectGetMaxY(rect) > self.scrollView.frame.size.height) {
            CGSize size = self.scrollView.contentSize;
            size.height = CGRectGetMaxY(rect);
            self.scrollView.contentSize = size;
        }
        else {
            CGSize size = self.scrollView.frame.size;
            size.height += 1;
            self.scrollView.contentSize = size;
        }
    }
    else {
        self.commentListView.hidden = YES;
    }

}

- (CGFloat)calculateCommentViewHeight:(NSString *)string {
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(COMMENTLISTVIEW_WIDTH-5, FLT_MAX)];
    return size.height + 16;
}
- (CGFloat)calculateTextViewHeight:(NSString *)string {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(TEXTVIEW_WIDTH-20, FLT_MAX)];
    return size.height + 20;
}

- (void)tappedAtLine:(int)line {
    self.targetUid = [[self.userList objectAtIndex:line-1] intValue];
    if (self.targetUid != -1) {
        UserInfo *userInfo = [[AppData sharedInstance] readUserInfoForId:self.targetUid];
        _keyboardToolBar.placeHolder = [NSString stringWithFormat:@"回复 %@:", userInfo.username];
    }
    else _keyboardToolBar.placeHolder = @"";
    [self beginToComment:nil];
    //    [self.delegate beginToComment:self];
//    self.targetUid = -1;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [_keyboardToolBar resignFirstResponder];
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
            self.topBar.image = image;
            [self.navigationController popViewControllerAnimated:YES];
            [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
            
        }
        else if (p.x >= CGRectGetMaxX(self.topBar.frame)-50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;
            [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
        }
    }

}


- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
}





// 更新的是点赞列表
- (void)update {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
    if (!self.likedList || !self.likedList.count)
        return;
    
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    int count = 0;
    for (NSString *name in self.likedList) {
        if (count++) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@", "];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
            [ret appendAttributedString:string];
        }
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:name];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.21f green:0.26f blue:0.51f alpha:1.00f] range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, string.length)];
        [ret appendAttributedString:string];
        if (count == 3) break;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.likedList.count > 3 ? [NSString stringWithFormat:@" 等%d人觉得很赞",self.likedList.count]:[NSString stringWithFormat:@" %d人觉得很赞",self.likedList.count                                                                                                                                                                                     ]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, string.length)];
    [ret appendAttributedString:string];
    
    [self.likedListView setAttributedText:ret];
}

- (void)updateCommentList {
    if (!self.commentList || !self.commentList.count) return;
    
    UIFont *font1 = [UIFont boldSystemFontOfSize:15];
    UIFont *font2 = [UIFont systemFontOfSize:14];
    
    UIColor *color1 = [UIColor colorWithRed:0.21f green:0.26f blue:0.51f alpha:1.00f];
    UIColor *color2 = [UIColor blackColor];
    
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dic in self.commentList) {
        NSMutableAttributedString *string = [self aText:[dic objectForKey:@"user"]];
        [self setString:string withColor:color1];
        [self setString:string withFont:font1];
        [ret appendAttributedString:string];
        
        if ([[dic allKeys] containsObject:@"reuser"]) {
            string = [self aText:@"回复"];
            [self setString:string withFont:font2];
            [self setString:string withColor:color2];
            [ret appendAttributedString:string];
            string = [self aText:[dic objectForKey:@"reuser"]];
            [self setString:string withColor:color1];
            [self setString:string withFont:font1];
            [ret appendAttributedString:string];
        }
        string = [self aText:@": "];
        [self setString:string withColor:color1];
        [self setString:string withFont:font1];
        [ret appendAttributedString:string];
        
        string = [self aText:[dic objectForKey:@"content"]];
        [self setString:string withFont:font2];
        [self setString:string withColor:color2];
        [ret appendAttributedString:string];
        
        string = [self aText:@"\n"];
        [self setString:string withColor:color2];
        [self setString:string withFont:font1];
        [ret appendAttributedString:string];
    }
    [self.commentListView setAttributedText:ret];
    
}

- (IBAction)likeMessage:(id)sender {
    self.liked = !self.liked;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
    LikedList *likedList = [[AppData sharedInstance] getLikedListOfMid:[self.message.mid intValue]];
    User *user = [MessageLogic user];
    UserInfo *userInfo = [[AppData sharedInstance] readUserInfoForId:user.uid];
    if (self.liked) {
        [MessageLogic likeMessage:[self.message.mid intValue]from:CLASS_NAME];
        [likedList.userList addObject:[NSNumber numberWithInt:user.uid]];
        [self.likedList insertObject:userInfo.username atIndex:0];
    }
    else {
        [MessageLogic dislikeMessage:[self.message.mid intValue] from:CLASS_NAME];
        [likedList.userList removeObject:[NSNumber numberWithInt:user.uid]];
        [self.likedList removeObject:userInfo.username];
    }
    [likedList update];
    [AppData saveData];
    [self update];
    [self loadContent];

}

- (IBAction)beginToComment:(id)sender {
    if (!_keyboardToolBar.superview) {
        CGRect rect = _keyboardToolBar.frame;
        rect.origin.y = -100;
        _keyboardToolBar.frame = rect;
        [self.view.window addSubview:_keyboardToolBar];
    }
    else _keyboardToolBar.hidden = NO;
    [_keyboardToolBar becomeFirstResponder];
    
}


- (void)setString:(NSMutableAttributedString *)string withColor:(UIColor *)color {
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
}
- (void)setString:(NSMutableAttributedString *)string withFont:(UIFont *)font {
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
}
- (NSMutableAttributedString *)aText:(NSString *)string {
    return [[NSMutableAttributedString alloc] initWithString:string];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_keyboardToolBar resignFirstResponder];
    CGPoint p = scrollView.contentOffset;
    if (p.y < 0) p.y = 0;
//    else if (p.y + scrollView.frame.size.height > scrollView.contentSize.height) p.y = scrollView.contentSize.height - scrollView.frame.size.height;
    scrollView.contentOffset = p;
    
}
- (void)sendText:(NSString *)text {
    AppData *appData = [AppData sharedInstance];
    Comment *comment = [appData getCommentOfMid:[self.message.mid intValue]];
    User *user = [MessageLogic user];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt: user.uid] forKey:@"uid"];
    [dic setObject:[NSNumber numberWithInt:self.targetUid] forKey:@"reuid"];
    [dic setObject:text forKey:@"content"];
    [comment.commentList addObject:dic];
    [comment update];
    [AppData saveData];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    UserInfo *userInfo = [appData readUserInfoForId:user.uid];
    [dic1 setObject:userInfo.username forKey:@"user"];
    if (self.targetUid != -1) {
        userInfo = [appData readUserInfoForId:self.targetUid];
        [dic1 setObject:userInfo.username forKey:@"reuser"];
    }
    [dic1 setObject:text forKey:@"content"];
    [self.commentList addObject:dic1];
    [self updateCommentList];
    [self.userList addObject:[NSNumber numberWithInt:user.uid]];
    [self loadContent];
    if (self.targetUid == -1)
        [MessageLogic commentMessage:[self.message.mid intValue] withContent:text from:CLASS_NAME];
    else {
        [MessageLogic replyUser:self.targetUid atMessage:[self.message.mid intValue] withContent:text from:CLASS_NAME];
        self.targetUid = -1;
    }
    
    [_keyboardToolBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
