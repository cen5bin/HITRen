//
//  HeadPicViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "HeadPicViewController.h"
#import "HeadPicCell.h"
#import "User.h"
#import "UserSimpleLogic.h"

@interface HeadPicViewController ()

@end

@implementation HeadPicViewController

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

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return HEADPIC_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"headpiccell";
    HeadPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor redColor];
    if (!cell)
        cell = [[HeadPicCell alloc] init];
    cell.pic.image = [UIImage imageNamed:[NSString stringWithFormat:@"h%d.jpg", indexPath.row]];
    if (self.selectedIndex == indexPath.row)
        cell.contentView.backgroundColor = [UIColor greenColor];
    else cell.contentView.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
}



- (IBAction)comeback:(id)sender {
    User *user = [UserSimpleLogic user];
    if (self.selectedIndex != -1)
        user.pic = [NSString stringWithFormat:@"h%d.jpg", self.selectedIndex];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
