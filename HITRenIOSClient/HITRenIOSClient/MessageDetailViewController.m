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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat tmp = 220;
    self.cellBar.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.cellBar.layer.borderWidth = 0.5;
    self.scrollView.layer.borderWidth = 0.5;
    self.scrollView.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.commentListView.commentListViewDelegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppData *appData = [AppData sharedInstance];
    UserInfo *userInfo = [appData readUserInfoForId:[self.message.uid intValue]];
    self.usernameLabel.text = userInfo.username;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.timeLabel.text = [format stringFromDate:self.message.time];
    self.textView.text = self.message.content;
    
    [self update];
    [self updateCommentList];
    
    CGRect rect = self.textView.frame;
    rect.size.height = [self calculateTextViewHeight:self.textView.text];
    self.textView.frame = rect;
    
    rect = self.cellBar.frame;
    rect.origin.y = CGRectGetMaxY(self.textView.frame);
    self.cellBar.frame = rect;
    
    CGFloat origin_y = CGRectGetMaxY(rect);
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
        else self.scrollView.contentSize = self.scrollView.frame.size;
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
    //    [self.delegate beginToComment:self];
    self.targetUid = -1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
            self.topBar.image = image;
            [self.navigationController popViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:^(void){}];
        }
        else if (p.x >= CGRectGetMaxX(self.topBar.frame)-50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;
        }
    }

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
    CGPoint p = scrollView.contentOffset;
    if (p.y < 0) p.y = 0;
//    else if (p.y + scrollView.frame.size.height > scrollView.contentSize.height) p.y = scrollView.contentSize.height - scrollView.frame.size.height;
    scrollView.contentOffset = p;
    
}


@end
