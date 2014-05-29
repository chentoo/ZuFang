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
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:_imageView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, frame.size.width - 10, self.frame.size.height - 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 110, 5, 100, 20)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 1;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];

    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLabel.frame = CGRectMake(5, 20, self.frame.size.width - 10, self.frame.size.height - 40);
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.timeLabel.frame = CGRectMake(self.frame.size.width - 110, 5, 100, 20);
}

@end
