//
//  RelationShip.h
//  Test
//
//  Created by wubincen on 13-12-22.
//  Copyright (c) 2013年 wubincen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationShip : NSObject

@property (assign, nonatomic) int seq;
@property (retain, nonatomic) NSMutableArray *blackList;
@property (retain, nonatomic) NSMutableArray *concerList;
@property (retain, nonatomic) NSMutableArray *followList;


@end
