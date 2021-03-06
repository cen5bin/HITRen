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
#import "ChatViewController.h"
#import "MyActivityIndicatorView.h"
#import "UploadLogic.h"
#import "PersonInfoViewController.h"


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
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@", ASYNCDATALOADED, CLASS_NAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(asyncDataDidDownload:) name:notificationName object:nil];
    _isLoading = NO;
    _myActivityIndicator = getViewFromNib(@"MyActivityIndicatorView", self);
    _downloadingImageSet = [[NSMutableSet alloc] init];
}

- (void)willLoad {
    if (_isLoading) return;
    _isLoading = YES;
    [RelationshipLogic asyncDownloadInfofromClass:NSStringFromClass(self.class)];
//    UIView *view = [self getActivityIndicator];
//    if (!view.superview)
//        [self addSubview:view];
    _myActivityIndicator.textLabel.text = @"正在加载";
    [_myActivityIndicator showInView:self.parentController.view];

}

- (void)asyncDataDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *string = [dic objectForKey:@"fromclass"];
    if (string && ![string isEqualToString:@""] && ![string isEqualToString:NSStringFromClass(self.class)]) return;
    if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADCONTACT])
        [self contactDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADUSERINFOS])
        [self userInfosDidDownload:notification];
    else if ([notification.object isEqualToString:ASYNC_EVENT_DOWNLOADIMAGE])
        [self imageDidDownload:notification];
}

- (void)imageDidDownload:(NSNotification *)notification {
    UIImage *image = [UIImage imageWithData:[notification.userInfo objectForKey:@"imagedata"]];
    if (!image) image = [UIImage imageNamed:@"null.png"];
    [[AppData sharedInstance] storeImage:image withFilename:[notification.userInfo objectForKey:@"imagename"]];
    [_downloadingImageSet removeObject:[notification.userInfo objectForKey:@"imagename"]];
    [self reloadData];
}

- (void)loadData {
    _groups = [[NSMutableArray alloc] init];
    _list = [[NSMutableDictionary alloc] init];
    _datas = [[NSMutableArray alloc] init];
    User *user = [RelationshipLogic user];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in user.relationShip.concerList) {
        NSString *gname = [dic objectForKey:@"gname"];
        if ([gname isEqualToString:@"ALL"]) gname = @"所有好友";
        else if ([gname isEqualToString:@"default"]) gname = @"默认分组";
        if ([gname isEqualToString:@"所有好友"])
            [_datas insertObject:@{@"type":[NSNumber numberWithInt:2],@"showlist":[NSNumber numberWithBool:NO], @"gname":gname} atIndex:0];
        else [_datas addObject:@{@"type":[NSNumber numberWithInt:2],@"showlist":[NSNumber numberWithBool:NO], @"gname":gname}];
        NSArray *userlist = [dic objectForKey:@"userlist"];
        for (NSNumber *uid in userlist)
            if (![array containsObject:uid])
                [array addObject:uid];
        [_list setObject:userlist forKey:gname];
    }
//    AppData *appData = [AppData sharedInstance];
//    NSArray *uids = [appData userInfosNeedDownload:array];
    [UserSimpleLogic  downloadUseInfos:array from:NSStringFromClass(self.class)];
}

- (void)contactDidDownload:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([[dic objectForKey:@"SUC"] boolValue]) {
        L(@"contact download succ");
        [RelationshipLogic unPackRelationshipInfoData:[dic objectForKey:@"DATA"]];
        [self loadData];
    }
    else if ([[dic objectForKey:@"INFO"] isEqualToString:@"newest"]) {
        L(@"contact download succ");
        [self loadData];
//         _isLoading = NO;
//        [self hideTopActivityIndicator];
        
    }
    else L(@"contact download failed");
    [_myActivityIndicator hide];
     _isLoading = NO;
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
        AppData *appData = [AppData sharedInstance];
        int uid = [[dic objectForKey:@"uid"] intValue];
        UserInfo *userInfo = [appData readUserInfoForId:uid];
        NSString *filename = userInfo.pic;
        if (!userInfo.pic||!userInfo.pic.length)
            cell.pic.image = [UIImage imageNamed:@"empty.png"];
        else if ([[filename substringToIndex:1] isEqualToString:@"h"])
            cell.pic.image = [UIImage imageNamed:filename];
        else {
            UIImage *image = [appData getImage:filename];
            if (image) cell.pic.image = [UIImage imageNamed:filename];
            else if (![_downloadingImageSet containsObject:filename]) {
                [_downloadingImageSet addObject:filename];
                [UploadLogic downloadImage:filename from:NSStringFromClass(self.class)];
            }

        }
        
        
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

        AppData *appData = [AppData sharedInstance];
        int uid = [[dic objectForKey:@"uid"] intValue];
        UserInfo *userInfo = [appData readUserInfoForId:uid];
        if (!self.isInContactViewController) {
            ChatViewController *controller = getViewControllerOfName(@"ChatView");
            controller.userInfo = userInfo;
            [self.parentController.navigationController pushViewController:controller animated:YES];
        }
        else {
            PersonInfoViewController *controller = getViewControllerOfName(@"PersonInfo");
            controller.userInfo = userInfo;
            [self.parentController.navigationController pushViewController:controller animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                UserInfo *userInfo = [appData getUserInfoOfUid:[uid intValue]];
                
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
        _activityIndicator.frame = CGRectMake(CGRectGetWidth(self.frame)/2-len / 2, len, len, len);
    }
    _activityIndicator.hidden = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    return _activityIndicator;
}

- (void)hideTopActivityIndicator {
//    _activityIndicator.hidden = YES;
    if (_activityIndicator.superview) [_activityIndicator removeFromSuperview];
    _isLoading = NO;
//    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
