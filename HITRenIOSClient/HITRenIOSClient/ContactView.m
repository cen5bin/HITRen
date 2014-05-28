//
//  ContactView.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-5-28.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//


// _datas每个单元是dictionary
// 字段type，为1表示当前的单元表示一个人，为2表示是分组
// type=1，其余字段username,uid
// type=2，其余字段 showlist:BOOL 表示列表是否展开, gname,

//_list是个字典，key为gname，value为gname对应的好友列表

#import "ContactView.h"
#import "ContactPersonCell.h"
#import "ContactGroupCell.h"
#import "RelationshipLogic.h"
#import "User.h"
#import "RelationShip.h"
#import <QuartzCore/QuartzCore.h>
#import "UserSimpleLogic.h"
#import "AppData.h"
#import "UserInfo.h"


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
    UIView *view = [self getActivityIndicator];
    if (!view.superview)
        [self addSubview:view];
//    [self setContentOffset:CGPointMake(0, -35) animated:NO];
}

- (void)asyncDataDidDownload:(NSNotification *)notification {
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCONTACT])
        [self contactDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADUSERINFOS])
        [self userInfosDidDownload:notification];
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
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in user.relationShip.concerList) {
//            [_groups addObject:[dic objectForKey:@"gname"]];
            NSString *gname = [dic objectForKey:@"gname"];
            if ([gname isEqualToString:@"ALL"]) gname = @"所有好友";
            else if ([gname isEqualToString:@"default"]) gname = @"未分组";
            if ([gname isEqualToString:@"所有好友"])
                [_datas insertObject:@{@"type":[NSNumber numberWithInt:2],@"showlist":[NSNumber numberWithBool:NO], @"gname":gname} atIndex:0];
            else [_datas addObject:@{@"type":[NSNumber numberWithInt:2],@"showlist":[NSNumber numberWithBool:NO], @"gname":gname}];
            NSArray *userlist = [dic objectForKey:@"userlist"];
            for (NSNumber *uid in userlist)
                if (![array containsObject:uid])
                    [array addObject:uid];
            [_list setObject:userlist forKey:gname];
        }
        AppData *appData = [AppData sharedInstance];
        NSArray *uids = [appData userInfosNeedDownload:array];
        [UserSimpleLogic  downloadUseInfos:uids];
    }
    else if ([[dic objectForKey:@"INFO"] isEqualToString:@"newest"]) L(@"contact download succ");
    else L(@"contact download failed");
}

- (void)userInfosDidDownload:(NSNotification *)notification {
    NSDictionary *ret = notification.userInfo;
    if ([ret objectForKey:@"SUC"]) L(@"download userinfo succ");
    else L(@"download userinfo failed");
    [UserSimpleLogic userInfosDidDownload:[ret objectForKey:@"DATA"]];
    [self reloadData];
    [self hideTopActivityIndicator];

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
        cell.username.text = [dic objectForKey:@"username"];
        cell.stateLabel.text = @"";
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
    if (type == 1) { //表示点到的是人
        
    }
    else {  //表示点到的是分组
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        BOOL showList = [[dic objectForKey:@"showlist"] boolValue];
        [tmpDic setValue:[NSNumber numberWithBool:!showList] forKey:@"showlist"];
        int index = indexPath.row;
        [_datas insertObject:tmpDic atIndex:index];
        [_datas removeObjectAtIndex:index+1];
        if (!showList) {
            NSString *gname = [dic objectForKey:@"gname"];
            NSArray *userlist = [_list objectForKey:gname];
            AppData *appData = [AppData sharedInstance];
            BOOL last = (indexPath.row == _datas.count-1);
            int index = indexPath.row;
            for (NSNumber *uid in userlist) {
                UserInfo *userInfo = [appData readUserInfoForId:[uid intValue]];
                L(userInfo.username);
                NSDictionary *tmp = @{@"username":userInfo.username, @"uid":userInfo.uid,@"type":[NSNumber numberWithInt:1]};
                if (last) [_datas addObject:tmp];
                else [_datas insertObject:tmp atIndex:++index];
            }
        }
        else {
            while (index+1<_datas.count) {
                NSDictionary *tmp = [_datas objectAtIndex:index+1];
                if ([[tmp objectForKey:@"type"] intValue] == 1)
                    [_datas removeObjectAtIndex:index+1];
                else break;
            }
        }
        [self reloadData];
        
    }
}

- (UIActivityIndicatorView *)getActivityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat len = 30;
        _activityIndicator.frame = CGRectMake(CGRectGetMidX(self.frame)-len / 2, len, len, len);
    }
    _activityIndicator.hidden = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}

- (void)hideTopActivityIndicator {
    _activityIndicator.hidden = YES;
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
