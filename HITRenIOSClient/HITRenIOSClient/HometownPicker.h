//
//  HometownPicker.h
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-8.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HometownPicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSMutableDictionary *_data;
    NSMutableArray *_provinces;
    NSMutableArray *_cities;
    NSMutableArray *_counties;
    SEL _action;
    id _target;
}
//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@property (strong, nonatomic) NSMutableDictionary *hometown;

- (void)addTarget:(id)target action:(SEL)action;
@end
