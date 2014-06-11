//
//  EmotionTextView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-3.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "EmotionTextView.h"

#define EMOTION_START @"["
#define EMOTION_END @"]"

#define DEFAULT_LEN 40
#define DEFAULT_FONT [UIFont systemFontOfSize:15]
#define DEFAULT_COLOR [UIColor blackColor]

static NSArray *emotions = nil;

@implementation EmotionTextView

+ (NSArray *)getEmotions {
    if (emotions)return emotions;
    emotions = [NSArray arrayWithObjects:@"[呲牙]",@"[调皮]",@"[流汗]",@"[偷笑]",@"[再见]",@"[敲打]",@"[擦汗]",@"[猪头]",@"[玫瑰]",@"[流泪]",@"[大哭]",@"[嘘]",@"[酷]",@"[抓狂]",@"[委屈]",@"[便便]",@"[炸弹]",@"[菜刀]",@"[可爱]",@"[色]",@"[害羞]",@"[得意]",@"[吐]",@"[微笑]",@"[发怒]",@"[尴尬]",@"[惊恐]",@"[冷汗]",@"[爱心]",@"[示爱]",@"[白眼]",@"[傲慢]",@"[难过]",@"[惊讶]",@"[疑问]",@"[睡]",@"[亲亲]",@"[憨笑]",@"[爱情]",@"[衰]",@"[撇嘴]",@"[阴险]",@"[奋斗]",@"[发呆]",@"[右哼哼]",@"[拥抱]",@"[坏笑]",@"[飞吻]",@"[鄙视]",@"[晕]",@"[大兵]",@"[可怜]",@"[强]",@"[弱]",@"[握手]",@"[胜利]",@"[抱拳]",@"[凋谢]",@"[饭]",@"[蛋糕]",@"[西瓜]",@"[啤酒]",@"[飘虫]",@"[勾引]",@"[OK]",@"[爱你]",@"[咖啡]",@"[钱]",@"[月亮]",@"[美女]",@"[刀]",@"[发抖]",@"[差劲]",@"[拳头]",@"[心碎]",@"[太阳]",@"[礼物]",@"[足球]",@"[骷髅]",@"[挥手]",@"[闪电]",@"[饥饿]",@"[困]",@"[咒骂]",@"[折磨]",@"[抠鼻]",@"[鼓掌]",@"[糗大了]",@"[左哼哼]",@"[哈欠]",@"[快哭了]",@"[吓]",@"[篮球]",@"[乒乓球]",@"[NO]",@"[跳跳]",@"[怄火]",@"[转圈]",@"[磕头]",@"[回头]",@"[跳绳]",@"[激动]",@"[街舞]",@"[献吻]",@"[左太极]",@"[右太极]",@"[闭嘴]", nil];
    return emotions;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        _realDraw = NO;
        self.font = nil;
        self.len = 0;
        self.color = nil;
    }
    return self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (BOOL)judgeEmotion:(NSString *)string {
    return [string hasPrefix:EMOTION_START] && [string hasSuffix:EMOTION_END] && [emotions containsObject:string];
}

- (void)work {
    FUNC_START();
    // Drawing code
    _lineCount = 0;
    if (self.len == 0) self.len = DEFAULT_LEN;
    if (self.font == nil) self.font = DEFAULT_FONT;
    if (self.color == nil) self.color = DEFAULT_COLOR;
    NSMutableArray *array = [NSMutableArray array];
    [self analyzeText:self.text toResult:array];
    NSArray *emotions = [EmotionTextView getEmotions];
    _pureText = (array.count == 1 && ![self judgeEmotion:[array objectAtIndex:0]]);
    if (_pureText) {
        NSString *string = [array objectAtIndex:0];
        CGSize size = [string sizeWithFont:self.font constrainedToSize:CGSizeMake(FLT_MAX, self.len)];
        if (size.width + 16 <= CGRectGetWidth(self.frame)) {
            self.width = size.width + 16;
            self.height = size.height + 16;
        }
        else {
            self.width = CGRectGetWidth(self.frame);
            size = [string sizeWithFont:self.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-16, FLT_MAX)];
            self.height = size.height + 16;
        }
        return;
    }
    CGFloat nowX = 8;
    CGFloat nowY = 8;
    CGFloat tap = 2;
    CGFloat width = CGRectGetWidth(self.frame);
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    CGFloat max_h = 0;
    for (NSString *string in array) {
//        if ([string hasPrefix:EMOTION_START] && [string hasSuffix:EMOTION_END] && [emotions containsObject:string]) {
        if ([self judgeEmotion:string]) {
            if (nowX+self.len>width - 5) {
                [self draw:tmp withLineHeight:max_h andNowY:nowY];
                tmp = [[NSMutableArray alloc] init];
                nowY += max_h +tap;
                nowX = 8;
                max_h = 0;
            }
            
            int index = [emotions indexOfObject:string];
            NSString *filename = [NSString stringWithFormat:@"f%03d.gif", index];
            UIImage *image = [UIImage imageNamed:filename];
            [tmp addObject:image];
            nowX += self.len;
            if (max_h < self.len) max_h = self.len;
            
        }
        else {
            if (width - 8 - nowX < 10) {
                [self draw:tmp withLineHeight:max_h andNowY:nowY];
                tmp = [[NSMutableArray alloc] init];
                nowY += max_h +tap;
                nowX = 8;
                max_h = 0;
            }
            NSString *tmpString = [NSString stringWithFormat:@"%@", string];
            while (1) {
                int head = 0;
                int tail = tmpString.length - 1;
                NSString *t = @"";
                CGSize size;
                while (head < tail) {
                    int mid = (head+tail+1)>>1;
                    t = [tmpString substringWithRange:NSMakeRange(0, mid+1)];
                    size = [t sizeWithFont:self.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), self.len)];
                    if (nowX+size.width>width-8) tail = mid - 1;
                    else head = mid;
                }
                t = [tmpString substringWithRange:NSMakeRange(0, head+1)];
                size = [t sizeWithFont:self.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), self.len)];
                if (max_h < size.height) max_h = size.height;
                [tmp addObject:t];
                nowX+=size.width;
                if (tail == tmpString.length-1) break;
                [self draw:tmp withLineHeight:max_h andNowY:nowY];
                tmp = [[NSMutableArray alloc] init];
                nowY += max_h +tap;
                nowX = 8;
                max_h = 0;
                tmpString = [tmpString substringFromIndex:tail+1];
            }
        }
    }
    if (tmp.count) [self draw:tmp withLineHeight:max_h andNowY:nowY];
    self.height = max_h + nowY + 8;
    if (_lineCount == 1) self.width = nowX + 8;
    else self.width = width;
//    self.text = @"";
    FUNC_END();

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    _realDraw = YES;
    [self.color set];
    [self work];
    if (!_pureText)
        self.text = @"";
}

- (void)draw:(NSArray *)tmp withLineHeight:(CGFloat)h andNowY:(CGFloat)nowY{
    _lineCount++;
    if (!_realDraw) return;
    CGFloat nowX = 8;
    for (id obj in tmp) {
        if ([obj isKindOfClass:[NSString class]]) {
            CGSize size = [obj sizeWithFont:self.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), self.len)];
            [obj drawInRect:CGRectMake(nowX, nowY+h-size.height, size.width, size.height) withFont:self.font];
            nowX += size.width;
        }
        else if ([obj isKindOfClass:[UIImage class]]) {
//            UIImageView *view0 = [[UIImageView alloc] init];
//            view0.image = obj;
//            view0.frame = CGRectMake(nowX, nowY+h-self.len, self.len, self.len);
//            [self addSubview:view0];
            [obj drawInRect:CGRectMake(nowX, nowY+h-self.len, self.len, self.len)];
            nowX += self.len;
        }
    }
}

- (void)analyzeText:(NSString *)text toResult:(NSMutableArray *)res{
    if ([text isEqualToString:@""]) return;
    NSRange startRange = [text rangeOfString:EMOTION_START];
    NSRange endRange = [text rangeOfString:EMOTION_END];
    if (!startRange.length||!endRange.length) {
        [res addObject:text];
        return;
    }
    if (startRange.location > 0) [res addObject:[text substringToIndex:startRange.location]];
    NSString *nextString = [text substringWithRange:NSMakeRange(startRange.location, endRange.location+endRange.length-startRange.location)];
    [res addObject:nextString];
    [self analyzeText:[text substringFromIndex:endRange.location+endRange.length] toResult:res];
}

@end
