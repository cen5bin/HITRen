//
//  UploadGoodsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "UploadGoodsViewController.h"
#import "UploadLogic.h"
#import "TradeLogic.h"
#import "AppData.h"

@interface UploadGoodsViewController ()

@end

@implementation UploadGoodsViewController

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
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", ASYNCDATALOADED, CLASS_NAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferCompleted:) name:notificationName object:nil];
    _cells = [NSMutableArray arrayWithObjects:self.goodsNameCell,self.goodsPriceCell,self.goodsPicCell, self.goodsDescriptionCell, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    _pics = [[NSMutableArray alloc] init];
    _isWorking = NO;
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
    return view.frame.size.height;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)releaseGoods:(id)sender {
    if (_isWorking) return;
    _isWorking = YES;
    [self hideKeyboard];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
    if (!self.namefield.text || !self.namefield.text.length)
        alert(@"错误", @"商品名称不能为空", self);
    else if (!self.pricefield.text || !self.pricefield.text.length)
        alert(@"错误", @"商品价格不能为空", self);
    else {
        UIView *view = [self getActivityIndicator];
        if (!view.superview) [self.tableView addSubview:view];
        if (_pics.count)
            [UploadLogic uploadImages:_pics from:NSStringFromClass(self.class)];
        else {
            NSDictionary *dic = @{
                                  @"name":self.namefield.text,
                                  @"price":self.pricefield.text,
                                  @"description":self.descriptiontextView.text,
                                  @"pics":[NSArray array]
                                  };
            [TradeLogic uploadGoodsInfo:dic from:CLASS_NAME];
        }
        return;
    }
    _isWorking = NO;
}

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;

}

- (IBAction)addPic:(id)sender {
    if (_pics.count == 5) return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(picDidSelect:) withObject:image afterDelay:0.0];
}

- (void)picDidSelect:(UIImage *)image {
    UIImage *newImage = _pics.count==0?[AppData imageWithImage:image scaledToSize:CGSizeMake(160, 160)]:image;
    
    [_pics addObject:newImage];
    if (_pics.count == 1) [_pics addObject:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.addPicButton.frame];
    imageView.image = newImage;
    [self.goodsPicCell.contentView addSubview:imageView];
    if (_pics.count == 5) {
        self.addPicButton.hidden = YES;
        return;
    }
    CGRect rect = self.addPicButton.frame;
    rect.origin.x += CGRectGetWidth(rect) + 12;
    self.addPicButton.frame = rect;
}

- (void)hideKeyboard {
    [self.namefield resignFirstResponder];
    [self.pricefield resignFirstResponder];
    [self.descriptiontextView resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_cells objectAtIndex:indexPath.row] == self.goodsNameCell)
        [self.namefield becomeFirstResponder];
    else if ([_cells objectAtIndex:indexPath.row] == self.goodsPriceCell)
        [self.pricefield becomeFirstResponder];
    else if ([_cells objectAtIndex:indexPath.row] == self.goodsDescriptionCell)
        [self.descriptiontextView becomeFirstResponder];
}

- (void)transferCompleted:(NSNotification *)noticifition {
    NSDictionary *dic = noticifition.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)]) return;
    if ([noticifition.object isEqualToString:ASYNC_EVENT_UPLOADIMAGE]) {
        NSDictionary *dic = @{
                              @"name":self.namefield.text,
                              @"price":self.pricefield.text,
                              @"description":self.descriptiontextView.text,
                              @"pics":[noticifition.userInfo objectForKey:@"DATA"]
                              };
        [TradeLogic uploadGoodsInfo:dic from:CLASS_NAME];
    }
    else if ([noticifition.object isEqualToString:ASYNC_EVENT_UPLOADGOODSINFO]) {
        L([noticifition.userInfo description]);
        [self hideTopActivityIndicator];
        if (self == self.navigationController.topViewController)
            [self.navigationController popViewControllerAnimated:YES];
//        if (self.view.su)
    }
}

- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.view.frame)-len / 2, len, len, len);
    }
    _activityIndicator.hidden = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}



- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


@end
