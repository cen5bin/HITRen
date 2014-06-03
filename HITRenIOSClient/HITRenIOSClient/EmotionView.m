//
//  EmotionView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-2.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "EmotionView.h"
#import "KeyboardToolBar.h"
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
        _emotionText = [NSArray arrayWithObjects:@"[呲牙]",@"[调皮]",@"[流汗]",@"[偷笑]",@"[再见]",@"[敲打]",@"[擦汗]",@"[猪头]",@"[玫瑰]",@"[流泪]",@"[大哭]",@"[嘘]",@"[酷]",@"[抓狂]",@"[委屈]",@"[便便]",@"[炸弹]",@"[菜刀]",@"[可爱]",@"[色]",@"[害羞]",@"[得意]",@"[吐]",@"[微笑]",@"[发怒]",@"[尴尬]",@"[惊恐]",@"[冷汗]",@"[爱心]",@"[示爱]",@"[白眼]",@"[傲慢]",@"[难过]",@"[惊讶]",@"[疑问]",@"[睡]",@"[亲亲]",@"[憨笑]",@"[爱情]",@"[衰]",@"[撇嘴]",@"[阴险]",@"[奋斗]",@"[发呆]",@"[右哼哼]",@"[拥抱]",@"[坏笑]",@"[飞吻]",@"[鄙视]",@"[晕]",@"[大兵]",@"[可怜]",@"[强]",@"[弱]",@"[握手]",@"[胜利]",@"[抱拳]",@"[凋谢]",@"[饭]",@"[蛋糕]",@"[西瓜]",@"[啤酒]",@"[飘虫]",@"[勾引]",@"[OK]",@"[爱你]",@"[咖啡]",@"[钱]",@"[月亮]",@"[美女]",@"[刀]",@"[发抖]",@"[差劲]",@"[拳头]",@"[心碎]",@"[太阳]",@"[礼物]",@"[足球]",@"[骷髅]",@"[挥手]",@"[闪电]",@"[饥饿]",@"[困]",@"[咒骂]",@"[折磨]",@"[抠鼻]",@"[鼓掌]",@"[糗大了]",@"[左哼哼]",@"[哈欠]",@"[快哭了]",@"[吓]",@"[篮球]",@"[乒乓球]",@"[NO]",@"[跳跳]",@"[怄火]",@"[转圈]",@"[磕头]",@"[回头]",@"[跳绳]",@"[激动]",@"[街舞]",@"[献吻]",@"[左太极]",@"[右太极]",@"[闭嘴]", nil];
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
    NSString *filename = [NSString stringWithFormat:@"f%03d", index];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"gif"]];
    filename = [[NSBundle mainBundle] pathForResource:filename ofType:@"gif"];
    [self.keyboardToolBar.textView insertText:[_emotionText objectAtIndex:index]];
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    
//    [webView loadHTMLString:[NSString stringWithFormat:@"<img src='%@.gif'/>", [NSString stringWithFormat:@"f%03d", index]] baseURL:[NSURL fileURLWithPath:filename]];
//    [self.window addSubview:webView];
//   
//    webView.scalesPageToFit = YES;
//    CGRect frame = webView.frame;
//    frame.size.width = 768;
//    frame.size.height = 1;
//    
//    //    wb.scrollView.scrollEnabled = NO;
//    webView.frame = frame;
    
//    frame.size.height = webView.scrollView.contentSize.height;
    
//    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
//    webView.frame = frame;
//    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, IMAGE_W, IMAGE_W)];
//    view.image = image;
//    [self.window addSubview:view];
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
