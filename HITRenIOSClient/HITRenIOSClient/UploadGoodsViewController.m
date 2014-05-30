//
//  UploadGoodsViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-30.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "UploadGoodsViewController.h"

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
    _cells = [NSMutableArray arrayWithObjects:self.goodsNameCell,self.goodsPriceCell,self.goodsPicCell, self.goodsDescriptionCell, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    _pics = [[NSMutableArray alloc] init];
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
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)releaseGoods:(id)sender {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
    self.topBar.image = image;
    [self performSelector:@selector(clearTopBar) withObject:nil afterDelay:0.1];
}

- (void)clearTopBar {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
    self.topBar.image = image;

}

- (IBAction)addPic:(id)sender {
    if (_pics.count == 4) return;
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
    [_pics addObject:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.addPicButton.frame];
    imageView.image = image;
    [self.goodsPicCell.contentView addSubview:imageView];
    if (_pics.count == 4) {
        self.addPicButton.hidden = YES;
        return;
    }
    CGRect rect = self.addPicButton.frame;
    rect.origin.x += CGRectGetWidth(rect) + 10;
    self.addPicButton.frame = rect;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.namefield resignFirstResponder];
    [self.pricefield resignFirstResponder];
    [self.descriptiontextView resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_cells objectAtIndex:indexPath.row] == self.goodsNameCell)
        [self.namefield becomeFirstResponder];
    else if ([_cells objectAtIndex:indexPath.row] == self.goodsPriceCell)
        [self.pricefield becomeFirstResponder];
    else if ([_cells objectAtIndex:indexPath.row] == self.goodsDescriptionCell)
        [self.descriptiontextView becomeFirstResponder];
}
@end
