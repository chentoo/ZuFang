//
//  ZuFangCell.m
//  ZuFang
//
//  Created by Summer on 15/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import "ZuFangCell.h"
#import "FangYuanObject.h"

@implementation ZuFangCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell:(FangYuanObject *)object
{
    self.detailLabel.text = object.title;
    self.timeLabel.text = object.time;
}


@end
