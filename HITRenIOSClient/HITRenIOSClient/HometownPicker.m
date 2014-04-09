//
//  HometownPicker.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-8.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "HometownPicker.h"

@implementation HometownPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _data = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hometowns" ofType:@"plist"]];
        _provinces = [[_data allKeys] mutableCopy];
        [_provinces removeObject:@"北京"];
        [_provinces insertObject:@"北京" atIndex:0];
        _cities = [_data objectForKey:@"北京"];
        _counties = [[[_cities objectAtIndex:0] allValues] objectAtIndex:0];
        self.dataSource = self;
        self.delegate = self;
        self.showsSelectionIndicator = YES;
        [self selectRow:0 inComponent:0 animated:NO];
        [self selectRow:0 inComponent:1 animated:NO];
        self.hometown = [[NSMutableDictionary alloc] init];
        [self.hometown setObject:[self pickerView:self titleForRow:0 forComponent:0] forKey:@"province"];
        [self.hometown setObject:[self pickerView:self titleForRow:0 forComponent:1] forKey:@"cities"];
        _action = nil;
        _target = nil;
//        [self selectRow:0 inComponent:2 animated:NO];
    }
    return self;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) return 100;
    return 180;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return [_provinces count];
    if (component == 1) return [_cities count];
    if (component == 2) return [_counties count];
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) return [_provinces objectAtIndex:row];
    if (component == 1) return [[[_cities objectAtIndex:row] allKeys] objectAtIndex:0];
    if (component == 2) return [_counties objectAtIndex:row];
    return @"asd";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *key = [_provinces objectAtIndex:row];
        _cities = [_data objectForKey:key];
        _counties = [[[_cities objectAtIndex:0] allValues] objectAtIndex:0];
        [self.hometown setObject:[self pickerView:self titleForRow:row forComponent:0] forKey:@"province"];
        [self.hometown setObject:[self pickerView:self titleForRow:0 forComponent:1] forKey:@"city"];
    }
    else if (component == 1) {
        _counties = [[[_cities objectAtIndex:row] allValues] objectAtIndex:0];
        [self.hometown setObject:[self pickerView:self titleForRow:row forComponent:1] forKey:@"city"];
    }
    [self reloadAllComponents];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:nil];
#pragma clang diagnostic pop
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *string;
    UILabel *tmp = view?(UILabel *)view : [[UILabel alloc] initWithFrame:CGRectMake(0, 0, component?160:80, 20)];
    tmp.textAlignment = NSTextAlignmentCenter;
    tmp.backgroundColor = [UIColor clearColor];
    if (component == 0) string = [_provinces objectAtIndex:row];
    else if (component == 1) string = [[[_cities objectAtIndex:row] allKeys] objectAtIndex:0];
    else if (component == 2) string = [_counties objectAtIndex:row];
    tmp.text = string;
    if (string.length <= 4){
        UIFont *font = [UIFont systemFontOfSize:17];
        tmp.font = font;
    }
    else {
        CGFloat fontSize = 17;
        while (1){
            UIFont *font = [UIFont systemFontOfSize:fontSize];
            CGSize size = [string sizeWithFont:font];
            if (size.width > tmp.frame.size.width - 2) {
                fontSize--;
                continue;
            }
            tmp.font = font;
            break;
        }
    }
    
    
    return tmp;
}

- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}


@end
