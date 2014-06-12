//
//  UICollectionView+ScrollToTop.m
//  ZuFang
//
//  Created by xiazhidi on 14-6-12.
//  Copyright (c) 2014年 chentoo. All rights reserved.
//

#import "UICollectionView+ScrollToTop.h"

@implementation UICollectionView (ScrollToTop)
- (void)scrollToTop
{
    [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
@end
