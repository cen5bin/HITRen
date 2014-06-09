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
#import "GoodsDetailViewController.h"

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
    
    self.tableView.decelerationRate = 0.5;
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", ASYNCDATALOADED, CLASS_NAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:notificationName object:nil];
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TradeLogic downloadGoodsLinefrom:CLASS_NAME];
    _currentPage = 0;
    _maxLoadedPage = 0;
    _backgroundWorking = NO;
    _downloadFromTop = YES;
    AppData *appData = [AppData sharedInstance];
    int count = PAGE_GOODS_COUNT > appData.goodsLine.gids.count ? appData.goodsLine.gids.count : PAGE_GOODS_COUNT;
    if (count == 0) return;
    _data = [[NSMutableArray alloc] initWithArray:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)]];
    [self.tableView reloadData];
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)]) return;
    if ([notification.object isEqualToString: ASYNC_EVENT_DOWNLOADGOODSLINE])
        [self goodsLineDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADGOODSINFO])
        [self goodsInfoDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImages removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self.tableView reloadData];
}

- (void)goodsLineDidDownload:(NSNotification *)notification {
    _currentPage = 0;
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"goodsline download succ");
    else L(@"goodsline download fail");
    AppData *appData = [AppData sharedInstance];
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        int count = PAGE_GOODS_COUNT > appData.goodsLine.gids.count ? appData.goodsLine.gids.count : PAGE_GOODS_COUNT;
        _data = [[NSMutableArray alloc] initWithArray:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)]];
        [self.tableView reloadData];
        return;
    }

    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSArray *gids = [data objectForKey:@"gids"];
    appData.goodsLine.seq = [data objectForKey:@"seq"];
    L([gids description]);
    appData.goodsLine.gids = [NSMutableArray arrayWithArray:[[gids reverseObjectEnumerator] allObjects]];
//    if (gids.count == 0) return;
//    int index = -1;
//    if (appData.goodsLine.gids.count)
//        index = [gids indexOfObject:[appData.goodsLine.gids objectAtIndex:0]];
//    LOG(@"index %d", index);
//    if (index == NSNotFound) index = -1;
//    for (int i = index + 1; i < gids.count; i++)
//        [appData.goodsLine.gids insertObject:[gids objectAtIndex:i] atIndex:0];
    [appData.goodsLine update];
    L([appData.goodsLine.gids description]);
    int count = PAGE_GOODS_COUNT > appData.goodsLine.gids.count ? appData.goodsLine.gids.count : PAGE_GOODS_COUNT;
    [TradeLogic downloadGoodsInfo:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)] from:CLASS_NAME];
    [self.tableView reloadData];
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
    if (_downloadFromTop)
        _data = [[NSMutableArray alloc] initWithArray:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)]];
    else {
        _maxLoadedPage++;
        count = PAGE_GOODS_COUNT * (_maxLoadedPage+1) > appData.goodsLine.gids.count ? appData.goodsLine.gids.count : PAGE_GOODS_COUNT * (_maxLoadedPage+1);
        _data = [[NSMutableArray alloc] initWithArray:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(0, count)]];
        _backgroundWorking = NO;
    }
    _downloadFromTop = NO;
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
            
            UIImage *image = [appData getImage:showImage];
            if (image == nil) {
                if (![_downloadingImages containsObject:showImage]) {
                    [UploadLogic downloadImage:showImage from:NSStringFromClass(self.class)];
                    [_downloadingImages addObject:showImage];
                    cell.noImageLabel.text = @"正在加载";
                    cell.noImageLabel.hidden = NO;
                }
            }
            else {
                cell.noImageLabel.hidden = YES;
            }
            cell.pic.image = image;
        }
        else {
            cell.pic.image = nil;
            cell.noImageLabel.text = @"无图片";
            cell.noImageLabel.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *gid = [_data objectAtIndex:indexPath.row];
    AppData *appData = [AppData sharedInstance];
    GoodsInfo *goodsInfo = [appData getGoodsInfoOfGid:[gid intValue]];
    GoodsDetailViewController *controller = getViewControllerOfName(@"GoodsDetail");
    controller.goodsInfo = goodsInfo;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


- (void)workAtIndexpath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    _currentPage = index / PAGE_GOODS_COUNT;
    if (_currentPage < _maxLoadedPage) return;
    int tmp = index % PAGE_GOODS_COUNT;
    if (tmp < PAGE_GOODS_COUNT * 2 / 3) return;
    AppData *appData = [AppData sharedInstance];
    int count = appData.goodsLine.gids.count - (_currentPage + 1) * PAGE_GOODS_COUNT;
    if (count > PAGE_GOODS_COUNT) count = PAGE_GOODS_COUNT;
    if (count < 0) return;
    _backgroundWorking = YES;
    [TradeLogic downloadGoodsInfo:[appData.goodsLine.gids subarrayWithRange:NSMakeRange(PAGE_GOODS_COUNT * (_currentPage + 1), count)] from:CLASS_NAME];

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
        //我的商品
        UIViewController *controller = getViewControllerOfName(@"MyGoods");
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [self hideMenu];
}

- (IBAction)moreButtonClicked:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;

    if (!_menu.hidden) [self hideMenu];
    else [self showMenu];
    
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.0];
    

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
