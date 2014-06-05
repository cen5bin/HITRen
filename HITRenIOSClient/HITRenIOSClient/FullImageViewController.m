//
//  FullImageViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FullImageViewController.h"
#import "UploadLogic.h"
#import "AppData.h"

@interface FullImageViewController ()

@end

@implementation FullImageViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    _downloadingImageSet = [[NSMutableSet alloc] init];
    _loadedImageIndex = [[NSMutableSet alloc] init];
    [self updateTopLabel];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*(self.picNames.count / 2), CGRectGetHeight(self.view.frame));
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.view.frame)*self.nowIndex, 0);
//    AppData *appData = [AppData sharedInstance];
//    UIImage *image = [appData getImage:[self imageNameAtIndex:self.nowIndex]];
//    if (!image) {
//        [_downloadingImageSet addObject:[self imageNameAtIndex:self.nowIndex]];
//        [UploadLogic downloadImage:[self imageNameAtIndex:self.nowIndex] from:NSStringFromClass(self.class)];
//    }
    [self reloadView];
}


- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])
        return;
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self reloadView];
//    [self.tableView reloadData];
}

- (void)reloadView {
    if ([_loadedImageIndex containsObject:[NSNumber numberWithInt:self.nowIndex]])
        return;
    AppData *appData = [AppData sharedInstance];
    NSString *filename = [self imageNameAtIndex:self.nowIndex];
    UIImage *image = [appData getImage:filename];
    if (image) {
        [_loadedImageIndex addObject:[NSNumber numberWithInt:self.nowIndex]];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame =[self makeImageRectAtIndex:self.nowIndex];
        [self.scrollView addSubview:view];
        return;
    }
    if (!image && ![_downloadingImageSet containsObject:filename]) {
        [_downloadingImageSet addObject:filename];
        [self addIndicatorAtIndex:self.nowIndex];
        [UploadLogic downloadImage:filename from:NSStringFromClass(self.class)];
        if (self.nowIndex+1<self.picNames.count/2)
            filename = [self imageNameAtIndex:self.nowIndex+1];
        UIImage *image = [appData getImage:filename];
        if (!image && ![_downloadingImageSet containsObject:filename]) {
            [_downloadingImageSet addObject:filename];
            [UploadLogic downloadImage:filename from:NSStringFromClass(self.class)];
        }
    }

}

- (CGRect)makeImageRectAtIndex:(int)index {
    return CGRectMake(20+index*320, 100, 280, 280);
}

- (void)addIndicatorAtIndex:(int)index {
    UIActivityIndicatorView *activityIndicator = [_activityIndicators objectForKey:[NSNumber numberWithInt:index]];
    if (activityIndicator && activityIndicator.superview) return;
    if (!activityIndicator) {
        CGRect rect = [self makeImageRectAtIndex:index];
        CGFloat len = 50;
        CGRect rect1 = CGRectMake(CGRectGetMidX(rect)-len/2, CGRectGetMidY(rect)-len/2, len, len);
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.frame = rect1;
        [activityIndicator startAnimating];
        [_activityIndicators setObject:activityIndicator forKey:[NSNumber numberWithInt:index]];
    }
    if (!activityIndicator.superview)
        [self.scrollView addSubview:activityIndicator];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.nowIndex = page;
    [self updateTopLabel];
    [self reloadView];
}

- (void)updateTopLabel {
    self.topLabel.text = [NSString stringWithFormat:@"%d/%d", self.nowIndex+1, self.picNames.count/2];
}

- (NSString *)imageNameAtIndex:(int)index {
    return [self.picNames objectAtIndex:2*index+1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)comeBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
