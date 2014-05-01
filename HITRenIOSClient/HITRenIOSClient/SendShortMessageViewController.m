//
//  SendShortMessageViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SendShortMessageViewController.h"
#import "MessageLogic.h"

@interface SendShortMessageViewController ()

@end

@implementation SendShortMessageViewController

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
            self.topBar.image = image;
            [self dismissViewControllerAnimated:YES completion:^(void){}];
        }
        else if (p.x >= CGRectGetMaxX(self.topBar.frame)-50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;
            if (self.textView.text.length > 140) {
                alert(@"错误", @"状态字数不得超过140字", self);
                return;
            }
            else if (self.textView.text.length == 0) {
                alert(@"错误", @"状态不能为空", self);
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
                self.topBar.image = image;

                return;
            }
            [MessageLogic sendShortMessage:self.textView.text];
            [self dismissViewControllerAnimated:YES completion:^(void){}];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    int count = self.textView.text.length;
    if (count > 140) self.countLabel.textColor = [UIColor redColor];
    else self.countLabel.textColor = [UIColor blackColor];
    self.countLabel.text = [NSString stringWithFormat:@"%d/140字", count];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
