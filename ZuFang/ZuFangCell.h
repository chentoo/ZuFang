//
//  ZuFangCell.h
//  ZuFang
//
//  Created by Summer on 15/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZuFangCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (void)initCell:(NSDictionary *)dic;
@end
