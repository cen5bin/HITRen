//
//  FullImageViewController.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-5.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController<UIScrollViewDelegate> {
    NSMutableSet *_downloadingImageSet;
    NSMutableSet *_loadedImageIndex;
    NSMutableDictionary *_activityIndicators;
    NSMutableArray *_picScrollViews;
}

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *picNames;
@property (nonatomic) int nowIndex;

- (IBAction)comeBack:(id)sender;

@end
