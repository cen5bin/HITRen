//
//  SecondTradeViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SecondTradeViewController.h"
#import "GoodsCell.h"
#import "AppData.h"
#import "SecondHandMenu.h"
#import "TradeLogic.h"
#import "GoodsLine.h"
#import "GoodsInfo.h"
#import "UploadLogic.h"

@interface SecondTradeViewController ()

@end

@implementation SecondTradeViewController

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
    _data = [[NSMutableArray alloc] init];
    _menu = getViewFromNib(@"secondhandmenu", self);
    CGRect rect = _menu.frame;
    rect.origin.y = CGRectGetMaxY(self.topBar.frame) -2;
    rect.origin.x = CGRectGetMaxX(self.view.frame) - rect.size.width -2;
    _menu.frame = rect;
    [self.view addSubview:_menu];
    _menu.hidden = YES;
    _menu.delegate = self;
    
    _downloadingImages = [[NSMutableSet alloc] init];
    
    UIView *view = [self getActivityIndicator];
    [self.view addSubview:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    [TradeLogic downloadGoodsLine];
    _currentPage = 0;

}


- (void)dataDidDownload:(NSNotification *)notification {
    if ([notification.object isEqualToString: ASYNC_EVENT_DOWNLOADGOODSLINE])
        [self goodsLineDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADGOODSINFO])
        [self goodsInfoDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    L(@"asd");
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    L([notification.userInfo objectForKey:@"imagename"]);
    L([image description]);
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.image = [[AppData sharedInstance] getImage:[notification.userInfo objectForKey:@"imagename"]];
    [self.view addSubview:view];
    [self.tableView reloadData];
}

- (void)goodsLineDidDownload:(NSNotification *)notification {
    _currentPage = 0;
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"goodsline download succ");
    else L(@"goodsline download fail");
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        [self.tableView reloadData];
        return;
    }
    AppData *appData = [AppData sharedInstance];
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSArray *gids = [data objectForKey:@"gids"];
    appData.goodsLine.seq = [data objectForKey:@"seq"];
    L([gids description]);
    if (gids.count == 0) return;
    int index = 0;
    if (appData.goodsLine.gids.count)
        index = [gids indexOfObject:[appData.goodsLine.gids objectAtIndex:0]];
    if (index == NSNotFound) index = 0;
    for (int i = index; i < gids.count; i++)
        [appData.goodsLine.gids insertObject:[gids objectAtIndex:i] atIndex:0];
    [appData.goodsLine update];
    int count = PAGE_GOODS_COUNT > appData.goodsLine.gids.count ? appData.goodsLine.gids.count : PAGE_GOODS_COUNT;
    [TradeLogic downloadGoodsInfo:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)]];
}

- (void)goodsInfoDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"download goodsinfo succ");
    else L(@"download goodsinfo fail");
    NSDictionary *goodsInfos = [ret objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    for (NSNumber *gid in [goodsInfos allKeys]) {
        GoodsInfo *gi = [appData newGoodsInfo];
        NSDictionary *dic = [goodsInfos objectForKey:gid];
        gi.gid = [dic objectForKey:@"gid"];
        gi.name = [dic objectForKey:@"name"];
        gi.desc = [dic objectForKey:@"description"];
        gi.picNames = [dic objectForKey:@"pics"];
        gi.price = [dic objectForKey:@"price"];
        gi.uid = [dic objectForKey:@"uid"];
        [gi update];
    }
    [AppData saveData];
    int count = PAGE_GOODS_COUNT > appData.goodsLine.gids.count ? appData.goodsLine.gids.count : PAGE_GOODS_COUNT;
    _data = [[NSMutableArray alloc] initWithArray:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"GoodsCell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    if (!cell)
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    NSNumber *gid = [_data objectAtIndex:indexPath.row];
    AppData *appData = [AppData sharedInstance];
    GoodsInfo *goodsInfo = [appData getGoodsInfoOfGid:[gid intValue]];
    if (goodsInfo) {
        cell.goodsName.text = goodsInfo.name;
        cell.goodsPrice.text = goodsInfo.price;
        cell.goodsDesc.text = goodsInfo.desc;
        NSArray *pics = goodsInfo.picNames;
        if (pics.count) {
            NSString *showImage = [pics objectAtIndex:0];
            L(showImage);
            UIImage *image = [appData getImage:showImage];
            if (image == nil) {
                L(@"error");
                if (![_downloadingImages containsObject:showImage]) {
                    [UploadLogic downloadImage:showImage];
                    [_downloadingImages addObject:showImage];
                }
            }
            else {
                cell.pic.image = image;
                L(@"yes");
            }
        }
    }
    L(@"zzzz");
    return cell;
}

- (void)hideMenu {
    static BOOL isWorking = NO;
    if (isWorking) return;
    isWorking = YES;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{_menu.alpha = 0; } completion:^(BOOL finished){_menu.alpha = 1; _menu.hidden = YES; isWorking = NO;}];
}

- (void)showMenu {
    static BOOL isWorking = NO;
    if (isWorking) return;
    isWorking = YES;
    _menu.hidden = NO;
    _menu.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{_menu.alpha = 1; } completion:^(BOOL finished){ isWorking = NO;}];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideMenu];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)menuDidChooseAtIndex:(int)index {
    if (index == 0) {
        //发布商品
        UIViewController *controller = getViewControllerOfName(@"UploadGoods");
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (index == 1) {
        //搜索商品
    }
    
    [self hideMenu];
}

- (IBAction)moreButtonClicked:(id)sender {
    if (!_menu.hidden) [self hideMenu];
    else [self showMenu];
//    _menu.hidden = !_menu.hidden;
}

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

- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
