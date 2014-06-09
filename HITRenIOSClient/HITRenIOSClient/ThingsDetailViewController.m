//
//  ThingsDetailViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-8.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ThingsDetailViewController.h"
#import "GoodsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ThingsInfo.h"
#import "AppData.h"
#import "UploadLogic.h"
//#import "TradeLogic.h"
#import "User.h"
#import "MyActivityIndicatorView.h"
#import "UserInfo.h"
#import "UserSimpleLogic.h"
#import "ChatViewController.h"
#import "FindLogic.h"

@interface ThingsDetailViewController ()

@end

@implementation ThingsDetailViewController

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
    _cells = [[NSMutableArray alloc] initWithObjects:self.nameCell, self.picsCell, self.descriptionCell, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    if (self.thingsInfo.picNames.count) {
        self.pageControl.numberOfPages = self.thingsInfo.picNames.count - 1;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame)*self.pageControl.numberOfPages, CGRectGetHeight(self.scrollView.frame));
        CGSize size = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
        CGFloat width = CGRectGetWidth(self.picsCell.contentView.frame);
        CGRect rect = self.pageControl.frame;
        rect.origin.x = (width - size.width) / 2;
        rect.size.width = size.width;
        
        AppData *appData = [AppData sharedInstance];
        const CGFloat len = 180;
        CGFloat margin_x = (CGRectGetWidth(self.scrollView.frame) - len)/2;
        CGFloat margin_y = (CGRectGetHeight(self.scrollView.frame) - len)/2;
        for (int i = 1; i < self.thingsInfo.picNames.count; i++) {
            NSString *filename = [self.thingsInfo.picNames objectAtIndex:i];
            UIImage *image = [appData getImage:filename];
            UIImageView *imageView;
            if (image) imageView = [[UIImageView alloc] initWithImage:image];
            else {
                imageView = [[UIImageView alloc] init];
                imageView.backgroundColor = [UIColor grayColor];
                [_downloadingImageSet addObject:filename];
                [UploadLogic downloadImage:filename from:NSStringFromClass(self.class)];
            }
            CGRect rect = CGRectMake(margin_x+(i-1)*CGRectGetWidth(self.scrollView.frame), margin_y, len, len);
            imageView.frame = rect;
            imageView.tag = 100 + i;
            [self.scrollView addSubview:imageView];
        }
    }
    else [_cells removeObject:self.picsCell];
    
    self.leftButton.hidden = YES;
    if (self.thingsInfo.picNames.count <= 2) self.rightButton.hidden = YES;
    
    User *user = [FindLogic user];
    _mine = [self.thingsInfo.uid intValue] == user.uid;
    _myActivityIndicatorView = getViewFromNib(@"MyActivityIndicatorView", self);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) return;
    CGPoint p = self.scrollView.contentOffset;
    self.pageControl.currentPage = p.x / CGRectGetWidth(self.scrollView.frame);
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DELETETHINGSINFO]) {
        [_myActivityIndicatorView hide];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADUSERINFOS])
        [self userInfoDidDownload:notification];
}

- (void)userInfoDidDownload:(NSNotification *)notification {
    //    FUNC_START();
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"userInfo download succ");
    else L(@"userInfo download fail");
    NSDictionary *data = [ret objectForKey:@"DATA"];
    [UserSimpleLogic userInfosDidDownload:data];
    UserInfo *userInfo = [[AppData sharedInstance] getUserInfoOfUid:[self.thingsInfo.uid intValue]];
    if (userInfo) {
        ChatViewController *controller = getViewControllerOfName(@"ChatView");
        controller.userInfo = userInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    //    [self.tableView reloadData];
    //    FUNC_END();
}


- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    NSString *filename = [notification.userInfo objectForKey:@"imagename"];
    [[AppData sharedInstance] storeImage:image withFilename: filename];
    [_downloadingImageSet removeObject: filename];
    [self loadImage:image of:filename];
}

- (void)loadImage:(UIImage *)image of:(NSString *)filename {
    int index = [self.thingsInfo.picNames indexOfObject:filename];
    UIImageView *view = (UIImageView *)[self.scrollView viewWithTag:100+index];
    view.image = image;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.nameField.text = self.thingsInfo.name;
//    self.priceField.text = self.thingsInfo;
    self.textView.text = self.thingsInfo.desc;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cells objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [_cells objectAtIndex:indexPath.row];
    return CGRectGetHeight(view.frame);
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
            [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];

        }
    }
    
}





- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
}


- (IBAction)moreButtonClicked:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:_mine?@"删除物品":@"联系发布者" otherButtonTitles:nil, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (_mine) {
            _myActivityIndicatorView.textLabel.text = @"正在删除";
            [_myActivityIndicatorView showInView:self.view];
            [FindLogic deleteThing:[self.thingsInfo.tid intValue]];
//            [TradeLogic deleteGoods:[self.thingsInfo.tid intValue]];
        }
        else {
            UserInfo *userInfo = [[AppData sharedInstance] getUserInfoOfUid:[self.thingsInfo.uid intValue]];
            if (userInfo) {
                ChatViewController *controller = getViewControllerOfName(@"ChatView");
                controller.userInfo = userInfo;
                [self.navigationController pushViewController:controller animated:YES];
            }
            else [UserSimpleLogic downloadUseInfos:[NSArray arrayWithObjects:self.thingsInfo.uid, nil] from:NSStringFromClass(self.class)];
        }
    }
}

- (IBAction)left:(id)sender {
    if (self.pageControl.currentPage) {
        self.pageControl.currentPage--;
        [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
        if (self.pageControl.currentPage == 0) self.leftButton.hidden = YES;
    }
    self.rightButton.hidden = NO;
}

- (IBAction)right:(id)sender {
    if (self.pageControl.currentPage<self.thingsInfo.picNames.count-2) {
        self.pageControl.currentPage++;
        [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
        if (self.pageControl.currentPage == self.thingsInfo.picNames.count-2) self.rightButton.hidden = YES;
    }
    self.leftButton.hidden = NO;
    
}
@end
