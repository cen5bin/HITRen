//
//  MenuView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-21.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _items = [[NSMutableArray alloc] initWithObjects:@"发状态", @"加好友", nil];
        self.backgroundColor = [UIColor colorWithRed:66.0/255 green:66.0/255 blue:66.0/255 alpha:1];
        _index = -1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    _index = p.y / (self.frame.size.height / _items.count);
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    _index = p.y / (self.frame.size.height / _items.count);
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    _index = p.y / (self.frame.size.height / _items.count);
    if (_index > _items.count) return;
    [self.delegate menuDidChooseAtIndex:_index];
    _index = -1;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int count = _items.count;
    CGFloat height = rect.size.height / count;
    CGFloat height0 = 0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < count; i++) {
        height0 += height;
        CGContextSaveGState(context);
        [[UIColor colorWithRed:100.0 / 255 green:100.0 / 255 blue:100.0 / 255 alpha:1] set];
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(rect), height0);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), height0);
        CGContextStrokePath(context);
        if (_index == i) {
            [[UIColor colorWithRed:100.0 / 255 green:100.0 / 255 blue:100.0 / 255 alpha:1] setFill];
            CGContextFillRect(context, CGRectMake(rect.origin.x, height0 - height, rect.size.width, height));
        }
        [[UIColor whiteColor] set];
        drawStringWithFontInRect([_items objectAtIndex:i], [UIFont boldSystemFontOfSize:20], CGRectMake(rect.origin.x, height0 - height, rect.size.width, height));
        CGContextRestoreGState(context);
    }
    if (_index < 0) return;
}


@end
