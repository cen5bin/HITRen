//
//  ShortMessageCell.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ShortMessageCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShortMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    CGFloat tmp = 220;
    self.cellBar.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.cellBar.layer.borderWidth = self.bgView.layer.borderWidth;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
    
    self.likedListView.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;
    self.likedListView.layer.borderWidth = self.bgView.layer.borderWidth;
    self.commentField.layer.borderWidth = 1;
    self.commentField.layer.borderColor = [UIColor colorWithRed:tmp/255 green:tmp/255 blue:tmp/255 alpha:1].CGColor;

//    self.likedList = [[NSMutableArray alloc] init];
//    self.likedList.contentOffset = CGPointMake(0, 10);
//    self.bgView.layer.shadowOffset = CGSizeMake(-0.5, 0);
//    self.bgView.layer.shadowColor = [UIColor whiteColor].CGColor;
//    self.bgView.layer.shadowOpacity = 0.4;
//    [self.likedButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liked1" ofType:@"png"]] forState:UIControlStateHighlighted];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate beginToComment:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeMessage:(id)sender {
    self.liked = !self.liked;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
    if (self.liked)
        [self.delegate likeMessage:self];
    else [self.delegate dislikeMessage:self];
}

- (IBAction)commentMessage:(id)sender {
    [self.delegate commentMessage:self];
}

- (IBAction)shareMessage:(id)sender {
    [self.delegate shareMessage:self];
}

- (void)update {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.liked? @"liked1":@"liked" ofType:@"png"]];
    [self.likedButton setImage:image forState:UIControlStateNormal];
    if (!self.likedList || !self.likedList.count)
        return;
    
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    int count = 0;
    for (NSString *name in self.likedList) {
        if (count++) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@", "];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
            [ret appendAttributedString:string];
        }
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:name];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.21f green:0.26f blue:0.51f alpha:1.00f] range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, string.length)];
        [ret appendAttributedString:string];
        if (count == 3) break;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.likedList.count > 3 ? [NSString stringWithFormat:@" 等%d人觉得很赞",self.likedList.count]:[NSString stringWithFormat:@" %d人觉得很赞",self.likedList.count                                                                                                                                                                                     ]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, string.length)];
    [ret appendAttributedString:string];
        
    [self.likedListView setAttributedText:ret];
}

- (void)updateCommentList {
    if (!self.commentList || !self.commentList.count) return;
    
    UIFont *font1 = [UIFont boldSystemFontOfSize:15];
    UIFont *font2 = [UIFont systemFontOfSize:14];
    
    UIColor *color1 = [UIColor colorWithRed:0.21f green:0.26f blue:0.51f alpha:1.00f];
    UIColor *color2 = [UIColor blackColor];
    
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dic in self.commentList) {
        NSMutableAttributedString *string = [self aText:[dic objectForKey:@"user"]];
        [self setString:string withColor:color1];
        [self setString:string withFont:font1];
        [ret appendAttributedString:string];
        
        if ([[dic allKeys] containsObject:@"reuser"]) {
            string = [self aText:@"回复"];
            [self setString:string withFont:font2];
            [self setString:string withColor:color2];
            [ret appendAttributedString:string];
            string = [self aText:[dic objectForKey:@"reuser"]];
            [self setString:string withColor:color1];
            [self setString:string withFont:font1];
            [ret appendAttributedString:string];
        }
        string = [self aText:@": "];
        [self setString:string withColor:color1];
        [self setString:string withFont:font1];
        [ret appendAttributedString:string];
        
        string = [self aText:[dic objectForKey:@"content"]];
        [self setString:string withFont:font2];
        [self setString:string withColor:color2];
        [ret appendAttributedString:string];
        
        string = [self aText:@"\n"];
        [self setString:string withColor:color2];
        [self setString:string withFont:font1];
        [ret appendAttributedString:string];
    }
    [self.commentListView setAttributedText:ret];
    
}


- (void)setString:(NSMutableAttributedString *)string withColor:(UIColor *)color {
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
}

- (void)setString:(NSMutableAttributedString *)string withFont:(UIFont *)font {
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
}

- (NSMutableAttributedString *)aText:(NSString *)string {
    return [[NSMutableAttributedString alloc] initWithString:string];
}
@end
