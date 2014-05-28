//
//  SecondTradeViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "SecondTradeViewController.h"
#import "GoodsCell.h"
#import "AppData.h"

@interface SecondTradeViewController ()

@end

@implementation SecondTradeViewController

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
    _data = [[NSMutableArray alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"GoodsCell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    if (!cell)
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    return cell;
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
        else if (p.x >= CGRectGetMaxX(self.topBar.frame)-50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
