//
//  House.h
//  ZuFang
//
//  Created by xiazhidi on 14-5-28.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : AVObject <AVSubclassing>

@property(nonatomic, strong) NSString *houseUrl;
@property(nonatomic, strong) NSString *updateTime;
@property(nonatomic, strong) NSString *userNickname;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *commentCount;
@property(nonatomic, strong) NSString *userUrl;
@property(nonatomic, strong) NSArray  *images;


@end
