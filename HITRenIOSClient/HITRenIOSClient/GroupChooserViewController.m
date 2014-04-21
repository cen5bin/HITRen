//
//  GroupChooserViewController.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-4-15.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "GroupChooserViewController.h"
#import "RelationshipLogic.h"

@interface GroupChooserViewController ()

@end

@implementation GroupChooserViewController

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
    if (self.flag == 1)
        self.titleLabel.text = @"复制到分组";
    else if (self.flag == 2)
        self.titleLabel.text = @"移动到分组";
    else if (self.flag == 3)
        self.titleLabel.text = @"从分组删除";
    _choosedGroups = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"groupcellinchooser";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [_groups objectAtIndex:indexPath.row];
    
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
        else if (p.x >= self.view.frame.size.width - 50) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base2" ofType:@"png"]];
            self.topBar.image = image;
            [self done];
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"base0" ofType:@"png"]];
            self.topBar.image = image;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_choosedGroups removeObject:cell.textLabel.text];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_choosedGroups addObject:cell.textLabel.text];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)done {
    if (_choosedGroups.count == 0) return;
    if (self.flag == 1) {
        [RelationshipLogic copyUser:self.uid toGroups:_choosedGroups];
    }
    else if (self.flag == 2) {
        [RelationshipLogic moveUser:self.uid fromGroup:self.gname toGroups:_choosedGroups];
    }
    else if (self.flag == 3) {
//        [RelationshipLogic deleteUser:self.uid fromGroup:]
    }
}

@end
