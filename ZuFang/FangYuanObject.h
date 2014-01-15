//
//  fangYuanObject.h
//  ZuFang
//
//  Created by Summer on 15/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FangYuanObject : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *time;

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSString *)url
                         time:(NSString *)time;


@end
