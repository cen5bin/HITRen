//
//  WriterInfoView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "WriterInfoView.h"
#import "UserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "RelationshipLogic.h"
#import "ChooseGroupViewController.h"

@implementation WriterInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    self.concernButton.layer.cornerRadius = 5;
    self.sendMessageButton.layer.cornerRadius = 5;
    self.concerned = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
}

- (void)dataDidDownload:(NSNotification *)notification {
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCONTACT])
        [self relationshipDidDownload:notification];
}

- (void)relationshipDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([[dic objectForKey:@"SUC"] boolValue]) {
        L(@"contact download succ");
        [RelationshipLogic unPackRelationshipInfoData:[dic objectForKey:@"DATA"]];
        
    }
    else if ([[dic objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        L(@"contact download succ");
        //        [self hideTopActivityIndicator];
        
    }
    else L(@"contact download failed");
    self.concerned = [RelationshipLogic uidIsConcerned:[self.userInfo.uid intValue]];
    if (self.concerned) L(@"yes");
    else L(@"no");
    [self updateConcernedButton];
}

- (void)updateConcernedButton {
    [self.concernButton setTitle:self.concerned?@"取消关注":@"关注" forState:UIControlStateNormal];
    self.concernButton.backgroundColor = !self.concerned ? [UIColor colorWithRed:96.0/255 green:210.0/255 blue:48.0/255 alpha:1]: [UIColor darkGrayColor];
}

- (void)showInView:(UIView *)view {
//    view.userInteractionEnabled = NO;
    [RelationshipLogic asyncDownloadInfo];
    self.usernameLabel.text = self.userInfo.username;
    _backgroundView = [[UIView alloc] initWithFrame:view.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    [view addSubview:_backgroundView];
    CGRect rect = self.frame;
    rect.origin.y = 150;
    rect.origin.x = CGRectGetMidX(view.frame) - CGRectGetWidth(rect)/2;
    self.frame = rect;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        _backgroundView.alpha = 0.6;
    } completion:^(BOOL finished){
//        [self.textView becomeFirstResponder];
    }];

}



- (void)hide {
    if (!_backgroundView.superview) return;
//    _backgroundView.superview.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backgroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished){
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

- (IBAction)concernButtonTouchDown:(id)sender {
}

- (IBAction)sendMessageButtonTouchDown:(id)sender {
}

- (IBAction)buttonClicked:(id)sender {
    L(@"yes");
    if (sender == self.concernButton) {
//        UIViewController *controller = getViewControllerOfName(@"ChooseGroup");
//        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        
        [self.delegate writeInfo:self buttonClickedAtIndex:0];
    }
    else if (sender == self.sendMessageButton) [self.delegate writeInfo:self buttonClickedAtIndex:1];
}
@end
