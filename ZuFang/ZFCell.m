//
//  ZFCell.m
//  ZuFang
//
//  Created by xiazhidi on 14-5-28.
//  Copyright (c) 2014年 chentoo. All rights reserved.
//

#import "ZFCell.h"
#import "NSAttributedString+Lintie.h"

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

        _titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width - 0, 40)];
        _titleBackView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width - 10, 40)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        [_titleBackView addSubview:_titleLabel];
        [self addSubview:_titleBackView];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, frame.size.width - 10, frame.size.height - 40)];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = [UIColor blackColor];
        [self addSubview:_tipsLabel];

        
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
    self.tipsLabel.frame = CGRectMake(5, 20, self.frame.size.width - 10, self.frame.size.height - 40);
    self.tipsLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.timeLabel.frame = CGRectMake(self.frame.size.width - 110, 5, 100, 20);
    self.titleBackView.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 0, 40);
    self.titleLabel.frame = CGRectMake(5, 0, self.frame.size.width - 10, 40);
}

@end
