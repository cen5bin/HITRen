//
//  GoodsDetailViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-8.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GoodsInfo.h"
#import "AppData.h"
#import "UploadLogic.h"

@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController

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
    _cells = [[NSMutableArray alloc] initWithObjects:self.nameCell, self.priceCell, self.picsCell, self.descriptionCell, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    if (self.goodsInfo.picNames.count) {
        self.pageControl.numberOfPages = self.goodsInfo.picNames.count - 1;
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
        for (int i = 1; i < self.goodsInfo.picNames.count; i++) {
            NSString *filename = [self.goodsInfo.picNames objectAtIndex:i];
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
    int index = [self.goodsInfo.picNames indexOfObject:filename];
    UIImageView *view = (UIImageView *)[self.scrollView viewWithTag:100+index];
    view.image = image;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.nameField.text = self.goodsInfo.name;
    self.priceField.text = self.goodsInfo.price;
    self.textView.text = self.goodsInfo.desc;
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
        }
    }
    
}





- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;
}


- (IBAction)moreButtonClicked:(id)sender {
}
@end
