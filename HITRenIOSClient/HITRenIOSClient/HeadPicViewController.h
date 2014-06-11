//
//  HeadPicViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-6.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadPicViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) int selectedIndex;
- (IBAction)comeback:(id)sender;
- (IBAction)confirm:(id)sender;

@end
