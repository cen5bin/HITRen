//
//  SendShortMessageViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-22.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SendShortMessageViewController.h"
#import "MessageLogic.h"
#import <QuartzCore/QuartzCore.h>
#import "AppData.h"
#import "UploadLogic.h"

#define MAX_PIC_COUNT 9

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferCompleted:) name:ASYNCDATALOADED object:nil];
    self.textView.layer.borderColor = VIEW_BORDER_COLOR.CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 5;
    self.imageContainer.layer.borderWidth = 0.5;
    self.imageContainer.layer.borderColor = VIEW_BORDER_COLOR.CGColor;
    self.imageContainer.layer.cornerRadius = 5;
    
    _pics = [[NSMutableArray alloc] init];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
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
            if (_pics.count == 0) {
                [MessageLogic sendShortMessage:self.textView.text andPics:[NSArray array]];
                [self dismissViewControllerAnimated:YES completion:^(void){}];
            }
            else [UploadLogic uploadImages:_pics from:NSStringFromClass(self.class)];
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

- (IBAction)addPic:(id)sender {
    if (_pics.count == MAX_PIC_COUNT * 2) return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(picDidSelect:) withObject:image afterDelay:0.0];
}

- (void)picDidSelect:(UIImage *)image {
    self.addPicLabel.hidden = YES;
    UIImage *newImage = [AppData imageWithImage:image scaledToSize:CGSizeMake(160, 160)];
    
    [_pics addObject:newImage];
    [_pics addObject:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.addPicButton.frame];
    imageView.image = newImage;
    [self.imageContainer addSubview:imageView];
    
    if (_pics.count == MAX_PIC_COUNT * 2) {
        self.addPicButton.hidden = YES;
        return;
    }
    int tmp1 = _pics.count / 2 % 4;
    int tmp2 = (_pics.count / 2) / 4;
    CGRect rect = self.imageContainer.frame;
    rect.size.height = (tmp2 + 1) * 70 + 10;
    self.imageContainer.frame = rect;
    
    rect = self.addPicButton.frame;
    rect.origin.x = (tmp1) % 4 * 70 + 10;
    rect.origin.y = tmp2 * 70 + 10;
    self.addPicButton.frame = rect;
}

- (void)transferCompleted:(NSNotification *)noticifition {
    if ([noticifition.object isEqualToString:ASYNC_EVENT_UPLOADIMAGE]) {
        [MessageLogic sendShortMessage:self.textView.text andPics:[noticifition.userInfo objectForKey:@"DATA"]];
    }
    else if ([noticifition.object isEqualToString:ASYNC_EVENT_SENDSHORTMESSAGE]) {
        [self dismissViewControllerAnimated:YES completion:^(void){}];
    }
}


@end
