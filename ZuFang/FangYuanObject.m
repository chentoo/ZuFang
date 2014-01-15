//
//  fangYuanObject.m
//  ZuFang
//
//  Created by Summer on 15/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import "FangYuanObject.h"

@implementation FangYuanObject


- (instancetype)initWithTitle:(NSString *)title
                          url:(NSString *)url
                         time:(NSString *)time
{
    self = [super init];
    if (self)
    {
        _title = title;
        _url = url;
        _time = time;
    }
    return self;
}



@end
