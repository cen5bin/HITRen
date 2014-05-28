//
//  ContactView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "ContactView.h"
#import "ContactPersonCell.h"
#import "ContactGroupCell.h"
#import "RelationshipLogic.h"
#import "User.h"
#import "RelationShip.h"
#import <QuartzCore/QuartzCore.h>
#import "UserSimpleLogic.h"


#define SECTIONVIEW_HEIGHT 40

@implementation ContactView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(asyncDataDidDownload:) name:ASYNCDATALOADED object:nil];
    _isLoading = NO;
}

- (void)willLoad {
    if (_isLoading) return;
    _isLoading = YES;
    [RelationshipLogic asyncDownloadInfo];
}

- (void)asyncDataDidDownload:(NSNotification *)notification {
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCONTACT])
        [self contactDidDownload:notification];
}

- (void)contactDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([[dic objectForKey:@"SUC"] boolValue]) {
        L(@"contact download succ");
        [RelationshipLogic unPackRelationshipInfoData:[dic objectForKey:@"DATA"]];
        L([[dic objectForKey:@"DATA"] description]);
        _groups = [[NSMutableArray alloc] init];
        _list = [[NSMutableDictionary alloc] init];
        _datas = [[NSMutableArray alloc] init];
        User *user = [RelationshipLogic user];
        for (NSDictionary *dic in user.relationShip.concerList) {
//            [_groups addObject:[dic objectForKey:@"gname"]];
            NSString *gname = [dic objectForKey:@"gname"];
            if ([gname isEqualToString:@"ALL"]) gname = @"所有好友";
            else if ([gname isEqualToString:@"default"]) gname = @"未分组";
            if ([gname isEqualToString:@"所有好友"])
                [_datas insertObject:@{@"type":[NSNumber numberWithInt:2],@"showlist":[NSNumber numberWithBool:NO], @"gname":gname} atIndex:0];
            else [_datas addObject:@{@"type":[NSNumber numberWithInt:2],@"showlist":[NSNumber numberWithBool:NO], @"gname":gname}];
            [_list setObject:[dic objectForKey:@"userlist"] forKey:gname];
        }
        [self reloadData];
    }
    else if ([[dic objectForKey:@"INFO"] isEqualToString:@"newest"]) L(@"contact download succ");
    else L(@"contact download failed");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"ContactPersonCell";
    static NSString *CellIdentifier2 = @"ContactGroupCell";
    NSDictionary *dic = [_datas objectAtIndex:indexPath.row];
    int type = [[dic objectForKey:@"type"] intValue];
    if (type == 1) {
        ContactPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        return cell;
    }
    else {
        ContactGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        [cell setShowList:[[dic objectForKey:@"showlist"] boolValue]];
        cell.gnameLabel.text = [dic objectForKey:@"gname"];
        cell.countLabel.text = [NSString stringWithFormat:@"%d 人",[[_list objectForKey:[dic objectForKey:@"gname"]] count]];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = scrollView.contentOffset;
    if (p.y < 0) p.y = 0;
    else if (p.y > scrollView.contentSize.height - scrollView.frame.size.height)
        p.y = scrollView.contentSize.height - scrollView.frame.size.height;
    if (p.y < 0) p.y = 0;
    scrollView.contentOffset = p;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_datas objectAtIndex:indexPath.row];
    int type = [[dic objectForKey:@"type"] intValue];
    if (type == 1) {
        
    }
    else {
        
    }
}
@end
