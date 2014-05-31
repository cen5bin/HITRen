//
//  FindThingsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-31.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "FindThingsViewController.h"
#import "FindThingsMenu.h"
#import "AppData.h"
#import "ThingCell.h"

@interface FindThingsViewController ()

@end

@implementation FindThingsViewController

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

- (void)dataDidDownload:(NSNotification *)notification {
    
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
    return cell;
}

- (IBAction)moreButtonClicked:(id)sender {
    if (!_menu.hidden) [self hideMenu];
    else [self showMenu];

}

- (void)menuDidChooseAtIndex:(int)index {
    if (index == 0) {
        //发布信息
        UIViewController *controller = getViewControllerOfName(@"UploadGoods");
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (index == 1) {
        //搜索物品
    }
    
    [self hideMenu];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideMenu];
}

@end
