//
//  EmotionView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "EmotionView.h"
#define KEYBOARD_H 216
#define KEYBOARD_W 320
#define EMOTION_COUNT 107
#define PAGE_EMOTION_COUNT 28
#define LINE_EMOTION_COUNT 7
#define LINE_NUM 3
#define PAGE_NUM (EMOTION_COUNT/(PAGE_EMOTION_COUNT-1)+1)

#define IMAGE_W 30



static EmotionView *emotionView = nil;

@implementation EmotionView

+ (id)sharedInstance {
    if (emotionView) return emotionView;
    emotionView = [[EmotionView alloc] initWithFrame:CGRectMake(0, 0, KEYBOARD_W, KEYBOARD_H)];
    emotionView.contentSize = CGSizeMake(KEYBOARD_W * PAGE_NUM, KEYBOARD_H);
    return emotionView;
}

- (id)initWithFrame:(CGRect)frame
{
    const CGFloat len = IMAGE_W;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        for (int i = 0; i < EMOTION_COUNT; i++) {
            int index = i % (PAGE_EMOTION_COUNT - 1);
            int page = i / (PAGE_EMOTION_COUNT - 1);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, len, len)];
            CGRect rect = CGRectMake(0, 0, len, len);
            imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"f%03d", i] ofType:@"gif"]];
            int tmp = index % 7;
            if (tmp == 0) rect.origin.x = 7 + KEYBOARD_W *page;
            else rect.origin.x = (tmp)*46+7 + KEYBOARD_W * page;
            rect.origin.y = 12 + (index/7)*(len+24);
            imageView.frame = rect;
            [self addSubview:imageView];
        }
        
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = BACKGROUND_COLOR;
    }
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    _tapRecognizer.numberOfTapsRequired = 1;
    _tapRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:_tapRecognizer];
    
//    UIImage 
    return self;
}

- (void)tapped: (UITapGestureRecognizer *)recognizer {
    CGPoint p = [recognizer locationInView:self];
    int page = p.x / KEYBOARD_W;
    CGFloat tmp = p.x - page * KEYBOARD_W;
    int index = 0;
    if (tmp <= 45) index = 0;
    else index = (tmp - 45) / 46 + 1;
    int line = p.y / 54;
    index = PAGE_EMOTION_COUNT * page + line * LINE_EMOTION_COUNT + index;
    NSString *filename = [NSString stringWithFormat:@"f%3d", index];
    L(filename);
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"gif"]];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, IMAGE_W, IMAGE_W)];
    view.image = image;
    [self.window addSubview:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
