//
//  MyThingsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-9.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MyThingsViewController.h"
#import "FindThingsMenu.h"
#import "AppData.h"
#import "ThingCell.h"
#import "FindLogic.h"
#import "ThingsLine.h"
#import "ThingsInfo.h"
#import "UploadLogic.h"
#import "ThingsDetailViewController.h"


@interface MyThingsViewController ()

@end

@implementation MyThingsViewController

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
    _menu = getViewFromNib(@"findthingsmenu", self);
    CGRect rect = _menu.frame;
    rect.origin.y = CGRectGetMaxY(self.topBar.frame) -2;
    rect.origin.x = CGRectGetMaxX(self.view.frame) - rect.size.width -2;
    _menu.frame = rect;
    [self.view addSubview:_menu];
    _menu.hidden = YES;
    _menu.delegate = self;
    
    _downloadingImages = [[NSMutableSet alloc] init];
    
    //    UIView *view = [self getActivityIndicator];
    //    [self.view addSubview:view];
    
    self.tableView.decelerationRate = 0.5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [FindLogic downloadMyThingsLine];
    _currentPage = 0;
    _maxLoadedPage = 0;
    _backgroundWorking = NO;
    _downloadFromTop = YES;
}


- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)]) return;
    if ([notification.object isEqualToString: ASYNC_EVENT_DOWNLOADMYTHINGSLINE])
        [self thingsLineDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADTHINGSINFO])
        [self thingsInfoDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
    
    
}

- (void)thingsLineDidDownload:(NSNotification *)notification {
    _currentPage = 0;
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"thingsline download succ");
    else L(@"thingsline download fail");
    AppData *appData = [AppData sharedInstance];
    if ([[ret objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        int count = PAGE_THINGS_COUNT > appData.myThingsLine.tids.count ? appData.myThingsLine.tids.count : PAGE_THINGS_COUNT;
        _data = [[NSMutableArray alloc] initWithArray:[appData.myThingsLine.tids subarrayWithRange:NSMakeRange(0, count)]];
        [self.tableView reloadData];
        return;
    }
    
    NSDictionary *data = [ret objectForKey:@"DATA"];
    NSArray *tids = [data objectForKey:@"tids"];
    appData.myThingsLine.seq = [data objectForKey:@"seq"];
//    L([tids description]);
//    L([appData.myThingsLine.tids description]);
//    if (tids.count == 0) return;
    appData.myThingsLine.tids = [NSMutableArray arrayWithArray:[[tids reverseObjectEnumerator]allObjects]];
    //    int index = 0;
    //    if (appData.myThingsLine.tids.count)
    //        index = [tids indexOfObject:[appData.myThingsLine.tids objectAtIndex:0]];
    //    LOG(@"index %d", index);
    //    if (index == NSNotFound) index = 0;
    //    for (int i = index + 1; i < tids.count; i++)
    //        [appData.myThingsLine.tids insertObject:[tids objectAtIndex:i] atIndex:0];
    [appData.myThingsLine update];
    int count = PAGE_THINGS_COUNT > appData.myThingsLine.tids.count ? appData.myThingsLine.tids.count : PAGE_THINGS_COUNT;
    [FindLogic downloadThingsInfo:[appData.myThingsLine.tids subarrayWithRange:NSMakeRange(0, count)]];
    [self.tableView reloadData];
    //    [TradeLogic downloadGoodsInfo:[appData.goodsLine.tids subarrayWithRange:NSMakeRange(0, count)]];
}

- (void)thingsInfoDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"download thingsinfo succ");
    else L(@"download thingsinfo fail");
    NSDictionary *thingsInfos = [ret objectForKey:@"DATA"];
    AppData *appData = [AppData sharedInstance];
    for (NSNumber *tid in [thingsInfos allKeys]) {
        ThingsInfo *ti = [appData newThingsInfo];
        NSDictionary *dic = [thingsInfos objectForKey:tid];
        ti.tid = [dic objectForKey:@"tid"];
        ti.name = [dic objectForKey:@"name"];
        ti.desc = [dic objectForKey:@"description"];
        ti.picNames = [dic objectForKey:@"pics"];
        ti.time = [dic objectForKey:@"time"];
        ti.uid = [dic objectForKey:@"uid"];
        [ti update];
    }
    [AppData saveData];
    int count = PAGE_THINGS_COUNT > appData.myThingsLine.tids.count ? appData.myThingsLine.tids.count : PAGE_THINGS_COUNT;
    if (_downloadFromTop)
        _data = [[NSMutableArray alloc] initWithArray:[appData.myThingsLine.tids subarrayWithRange:NSMakeRange(0, count)]];
    else {
        _maxLoadedPage++;
        count = PAGE_THINGS_COUNT * (_maxLoadedPage+1) > appData.myThingsLine.tids.count ? appData.myThingsLine.tids.count : PAGE_THINGS_COUNT * (_maxLoadedPage+1);
        _data = [[NSMutableArray alloc] initWithArray:[appData.myThingsLine.tids subarrayWithRange:NSMakeRange(0, count)]];
        _backgroundWorking = NO;
    }
    _downloadFromTop = NO;
    [self.tableView reloadData];
    
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImages removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ThingCell";
    ThingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[ThingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSNumber *tid = [_data objectAtIndex:indexPath.row];
    AppData *appData = [AppData sharedInstance];
    ThingsInfo *thingsInfo = [appData getThingsInfoOfTid:[tid intValue]];
    if (thingsInfo) {
        cell.thingName.text = thingsInfo.name;
        cell.releaseTime.text = thingsInfo.time;
        cell.thingDescription.text = thingsInfo.desc;
        NSArray *pics = thingsInfo.picNames;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThingsDetailViewController *controller = getViewControllerOfName(@"ThingsDetail");
    NSNumber *tid = [_data objectAtIndex:indexPath.row];
    AppData *appData = [AppData sharedInstance];
    ThingsInfo *thingsInfo = [appData getThingsInfoOfTid:[tid intValue]];
    if (!thingsInfo) return;
    controller.thingsInfo = thingsInfo;
    [self.navigationController pushViewController:controller animated:YES];
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
    _currentPage = index / PAGE_THINGS_COUNT;
    if (_currentPage < _maxLoadedPage) return;
    int tmp = index % PAGE_THINGS_COUNT;
    if (tmp < PAGE_THINGS_COUNT * 2 / 3) return;
    AppData *appData = [AppData sharedInstance];
    int count = appData.myThingsLine.tids.count - (_currentPage + 1) * PAGE_THINGS_COUNT;
    if (count > PAGE_THINGS_COUNT) count = PAGE_THINGS_COUNT;
    if (count < 0) return;
    _backgroundWorking = YES;
    [FindLogic downloadThingsInfo:[appData.myThingsLine.tids subarrayWithRange:NSMakeRange(PAGE_THINGS_COUNT * (_currentPage + 1), count)]];
    //    [TradeLogic downloadGoodsInfo:[appData.goodsLine.tids subarrayWithRange:NSMakeRange(PAGE_THINGS_COUNT * (_currentPage + 1), count)]];
    
}


- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base3" ofType:@"png"]];
    self.topBar.image = image;

}

- (IBAction)moreButtonClicked:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base5" ofType:@"png"]];
    self.topBar.image = image;
    UIViewController *controller = getViewControllerOfName(@"UploadThing");
    [self.navigationController pushViewController:controller animated:YES];
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
    return;
    
    if (!_menu.hidden) [self hideMenu];
    else [self showMenu];
    
}

- (void)menuDidChooseAtIndex:(int)index {
    if (index == 0) {
        //发布信息
        UIViewController *controller = getViewControllerOfName(@"UploadThing");
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (index == 1) {
        //搜索物品
    }
    
    [self hideMenu];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base4" ofType:@"png"]];
            self.topBar.image = image;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideMenu];
}

@end
