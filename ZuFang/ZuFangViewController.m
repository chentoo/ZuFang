//
//  ZuFangViewController.m
//  ZuFang
//
//  Created by Summer on 14/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import "ZuFangViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "NSAttributedString+Lintie.h"
#import "ZFCell.h"
#import "House.h"

static NSInteger maxNumOfPages = 10;

@interface ZuFangViewController ()
{
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)     NSMutableArray *housesArray;
@property (nonatomic, assign)     BOOL hasMore;

@end

@implementation ZuFangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _housesArray = [[NSMutableArray alloc] init];
    self.title = @"赫尔呵呵";
    [self initCollectionView];
    [self findAds:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initCollectionView
{
    self.collectionView.collectionViewLayout = [self layoutFromeRowSize:1];
    [self.collectionView registerClass:[ZFCell class] forCellWithReuseIdentifier:@"ZFCell"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshCollectionView) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

- (void)refreshCollectionView
{
    [self findAds:NO];
}
#pragma mark - AVOS Query

- (void)findAds:(BOOL)isAppend
{
    __weak ZuFangViewController *weakSelf = self;

    AVQuery *houseQuery = [House query];
    houseQuery.limit = maxNumOfPages;
    houseQuery.skip = isAppend ? self.housesArray.count : 0;
    [houseQuery orderByDescending:@"updatedAt"];
    [houseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (isAppend) {
                weakSelf.hasMore = objects.count >= maxNumOfPages;
                [self addAdsToCollectionViewBottom:objects];
            } else {
                [weakSelf.refreshControl endRefreshing];
                weakSelf.housesArray = [NSMutableArray arrayWithArray:objects];
                weakSelf.hasMore = YES;
                [weakSelf.collectionView reloadData];
            }
        }
    }];
    
}

//在collectionview中，增加一堆house到末尾
- (void)addAdsToCollectionViewBottom:(NSArray *)houses
{
    __block ZuFangViewController *weakSelf = self;
    NSInteger start = self.housesArray.count;
    
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        for (NSInteger i = start; i < houses.count + start; i ++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [weakSelf.housesArray addObjectsFromArray:houses];
        [weakSelf.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:nil];
}


#pragma mark - UICollectionView DateSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.housesArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"ZFCell";
    
    ZFCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:((10 * (indexPath.row % 10 + 3)) / 255.0) green:((20 * (indexPath.row % 10 + 3))/255.0) blue:((30 * (indexPath.row % 10 + 3))/255.0) alpha:1.0f];    //默认底色

    House *house = [self.housesArray objectAtIndex:indexPath.row];
    
    // title
    if (house.title) {
        cell.titleLabel.attributedText = [NSAttributedString attributedStringWithText:house.title fontSize:20];
    }
    else{
        cell.titleLabel.attributedText = nil;
    }
    // updateTime
    if (house.updateTime) {
        cell.timeLabel.attributedText = [NSAttributedString attributedStringWithText:house.updateTime fontSize:12];
    }
    else{
        cell.timeLabel.attributedText = nil;
    }

    // image
    if (house.images && house.images.count > 0) {
        NSString *imageUrl = [house.images objectAtIndex:0];
        __block ZFCell *weakCell = cell;
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  weakCell.imageView.alpha = 0;
                                  [UIView animateWithDuration:0.3
                                                   animations:^{
                                                       weakCell.imageView.alpha = 1.0;
                                                   }];
                              }];
    }
    else{
        [cell.imageView setImage:nil];
    }
    
    //----------- 动画 -------------
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.8];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = 0.4f;
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [cell.layer addAnimation:scaleAnimation forKey:@"scale"];

    // load more
    if (indexPath.row == self.housesArray.count - 1 && self.hasMore) {
        [self findAds:YES];
    }

    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"呵呵呵");
}


- (UICollectionViewLayout *)layoutFromeRowSize:(NSUInteger)rowSize
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    if (rowSize == 1) {
        layout.itemSize = CGSizeMake(300, 300);
        
    } else if (rowSize == 2) {
        layout.itemSize = CGSizeMake(150, 150);
    } else {
        layout.itemSize = CGSizeMake(96, 96);
    }
    return layout;
}


@end
