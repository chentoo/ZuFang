//
//  ZuFangViewController.m
//  ZuFang
//
//  Created by Summer on 14/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import "ZuFangViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
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
    
    House *house = [self.housesArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = house.title;
    
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
