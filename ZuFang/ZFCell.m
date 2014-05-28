//
//  ZFCell.m
//  ZuFang
//
//  Created by xiazhidi on 14-5-28.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#import "ZFCell.h"

@implementation ZFCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, frame.size.width - 10, self.frame.size.height - 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLabel.frame = CGRectMake(5, 20, self.frame.size.width - 10, self.frame.size.height - 40);
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

@end
