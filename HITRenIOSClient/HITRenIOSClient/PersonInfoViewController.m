//
//  PersonInfoViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-6-7.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UserInfo.h"
#import "AppData.h"
#import "UploadLogic.h"
#import <QuartzCore/QuartzCore.h>
#import "ChatViewController.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

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
    _cells = [NSMutableArray arrayWithObjects:self.usernameCell, self.sexCell, self.birthdayCell, self.hometownCell, nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.usernameLabel.text = self.userInfo.username;
    self.sexLabel.text = [self.userInfo.sex intValue] == 1?@"♂":@"♀";
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd";
    self.birthdayLabel.text = [formater stringFromDate:self.userInfo.birthday];
    self.hometownLabel.text = self.userInfo.hometown;
    _downloadingImageSet = [[NSMutableSet alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidDownload:) name:ASYNCDATALOADED object:nil];
    
    self.sendMessageButton.layer.cornerRadius = 5;
    self.concernButton.layer.cornerRadius = 5;
}

- (void)dataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)])  {
        return;
    }
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    self.pic.image = image;
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    UserInfo *userInfo = self.userInfo;
    AppData *appData = [AppData sharedInstance];
    if (userInfo.pic && ![userInfo.pic isEqualToString:@""]) {
        if (!userInfo.pic||!userInfo.pic.length)
            self.pic.image = [UIImage imageNamed:@"empty.png"];
        else if ([[userInfo.pic substringToIndex:1] isEqualToString:@"h"])
            self.pic.image = [UIImage imageNamed:userInfo.pic];
        else {
            UIImage *image = [appData getImage:userInfo.pic];
            if (image)self.pic.image = image;
            else if (![_downloadingImageSet containsObject:userInfo.pic]) {
                [_downloadingImageSet addObject:userInfo.pic];
                [UploadLogic downloadImage:userInfo.pic from:NSStringFromClass(self.class)];
            }
        }
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.topBar.frame, p)) {
        if (p.x <= 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base1" ofType:@"png"]];
            self.topBar.image = image;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cells objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreButtonClicked:(id)sender {
}

- (IBAction)buttonTouchDown:(id)sender {
    if (sender == self.sendMessageButton) {
        self.sendMessageButton.backgroundColor = BLUE_BUTTON_BACKGROUNF1;
    }
    else if (sender == self.concernButton) {
        self.concernButton.backgroundColor = GREEN_BUTTON_BACKGROUNF1;
    }
}

- (void)clearButton {
    self.sendMessageButton.backgroundColor = BLUE_BUTTON_BACKGROUNF;
    self.concernButton.backgroundColor = GREEN_BUTTON_BACKGROUNF;
}

- (IBAction)buttonClicked:(id)sender {
    if (sender == self.sendMessageButton) {
        ChatViewController *controller = getViewControllerOfName(@"ChatView");
        controller.userInfo = self.userInfo;
        self.sendMessageButton.backgroundColor = BLUE_BUTTON_BACKGROUNF1;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if (sender == self.concernButton) {
        
    }
    [self performSelector:@selector(clearButton) withObject:nil afterDelay:0.1];
}
@end
