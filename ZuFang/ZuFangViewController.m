//
//  ZuFangViewController.m
//  ZuFang
//
//  Created by Summer on 14/1/14.
//  Copyright (c) 2014 chentoo. All rights reserved.
//

#import "ZuFangViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "NSAttributedString+Lintie.h"
#import "ZFCell.h"
#import "House.h"
#import "DetailViewController.h"
#import "UICollectionView+ScrollToTop.h"

static NSInteger kMaxNumOfPages = 12;

@interface ZuFangViewController () <UISearchBarDelegate, UIGestureRecognizerDelegate>
{
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)     NSMutableArray *housesArray;
@property (nonatomic, assign)     BOOL hasMore;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showAllHouseButtonItem;
@property (strong, nonatomic) NSString *currentKeys;
@property (strong, nonatomic) AVSearchQuery *currentSearchQuery;
@end

@implementation ZuFangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.showAllHouseButtonItem.enabled = NO;
    _housesArray = [[NSMutableArray alloc] init];
    [self initCollectionView];
    [self findAds:NO];
    _currentSearchQuery = [[AVSearchQuery alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
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
    if ([self isSearchingState]) {
        [self searchWithKeys:self.searchBar.text];
    }
    else{
        [self findAds:NO];
    }
}

- (IBAction)showAllButtonPressed:(id)sender
{
    self.showAllHouseButtonItem.enabled = NO;
    self.currentSearchQuery = nil;
    self.searchBar.text = @"";
//    self.hasMore = YES;
    [self refreshCollectionView];
}
//搜索状态
- (BOOL)isSearchingState
{
    return self.showAllHouseButtonItem.enabled == YES;
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.urlString = sender;
}

#pragma mark - AVOS Query

- (void)findAds:(BOOL)isAppend
{
    __weak ZuFangViewController *weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中"];
    AVQuery *houseQuery = [House query];
    houseQuery.limit = kMaxNumOfPages;
    houseQuery.skip = isAppend ? self.housesArray.count : 0;
    [houseQuery orderByDescending:@"updatedAt"];
    [houseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (isAppend) {
                weakSelf.hasMore = objects.count >= kMaxNumOfPages;
                [self addAdsToCollectionViewBottom:objects];
            } else {
                [weakSelf.refreshControl endRefreshing];
                weakSelf.housesArray = [NSMutableArray arrayWithArray:objects];
                weakSelf.hasMore = YES;
                [weakSelf.collectionView reloadData];
                [self.collectionView scrollToTop];
            }
        }
        [SVProgressHUD dismiss];
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
    
    // updateTime
    if (house.updateTime) {
        cell.timeLabel.attributedText = [NSAttributedString attributedStringWithText:house.updateTime fontSize:12];
    }
    else{
        cell.timeLabel.attributedText = nil;
    }

    // image
    if (house.images && house.images.count > 0) {
        cell.tipsLabel.attributedText = nil;
        // title
        if (house.title) {
            cell.titleLabel.attributedText = [NSAttributedString attributedStringWithText:house.title fontSize:13];
        }
        else{
            cell.titleLabel.attributedText = nil;
        }

        NSString *imageUrl = [house.images objectAtIndex:0];
        __block ZFCell *weakCell = cell;
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                   weakCell.imageView.alpha = 0;
                                   [UIView animateWithDuration:0.3
                                                    animations:^{
                                                        weakCell.imageView.alpha = 1.0;
                                                    }];
                               }
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    else{
        [cell.imageView setImage:nil];
        cell.titleLabel.attributedText = nil;
        if (house.title) {
            cell.tipsLabel.attributedText = [NSAttributedString attributedStringWithText:house.title fontSize:20];
        }
        else{
            cell.tipsLabel.attributedText = nil;
        }
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
        if ([self isSearchingState]) {
            [self searchMore];
        }
        else{
            [self findAds:YES];
        }
    }

    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"呵呵呵");
    House *house = [self.housesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"pushToDetailVC" sender:house.houseUrl];
    
}


- (UICollectionViewLayout *)layoutFromeRowSize:(NSUInteger)rowSize
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
        {
            layout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
            layout.itemSize = CGSizeMake(340, 340);
        }
        else
        {
            layout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
            layout.itemSize = CGSizeMake(300, 300);
        }
    }
    else
    {
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        if (rowSize == 1) {
            layout.itemSize = CGSizeMake(300, 300);
            
        } else if (rowSize == 2) {
            layout.itemSize = CGSizeMake(150, 150);
        } else {
            layout.itemSize = CGSizeMake(96, 96);
        }
    }
    return layout;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView setCollectionViewLayout:[self layoutFromeRowSize:1] animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -88 && self.searchBar.frame.origin.y == 64)
    {
        [self searchBarDismiss];
    }
    else if (scrollView.contentOffset.y < -88 && self.searchBar.frame.origin.y != 64)
    {
        [self searchBarShow];
    }
}

#pragma mark - AVSearchQuery

- (void)searchMore
{
    if (self.currentSearchQuery == nil)
    {
        return;
    }
    [self searchWithQuery:self.currentSearchQuery loadMore:YES];
}

- (void)searchWithQuery:(AVSearchQuery *)searchQuery loadMore:(BOOL)loadMore
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [searchQuery findInBackground:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            self.hasMore = objects.count == kMaxNumOfPages;
            if (objects.count > 0) {
                
                [AVObject fetchAll:objects];
                if (loadMore)
                {
                    [self addAdsToCollectionViewBottom:objects];
                }
                else{
                    [self.refreshControl endRefreshing];
                    self.housesArray = [objects mutableCopy];
                    [self.collectionView reloadData];
                }
                self.showAllHouseButtonItem.enabled = YES;
                [SVProgressHUD dismiss];
            }
            else
            {
                if (!loadMore) {
                    self.hasMore = YES;
                    [SVProgressHUD showErrorWithStatus:@"啊哦，木有找到您要找的房子"];
                }
            }
        }
        else{
            NSLog(@"error  %@ ",error);
            [SVProgressHUD showErrorWithStatus:@"啊哦，搜索失败了，小房子正在后台努力改进中~"];
        }
    }];
}

- (void)searchWithKeys:(NSString *)keys
{
    if (keys == nil || keys.length == 0) {
        return;
    }
    AVSearchQuery *searchQuery = [AVSearchQuery searchWithQueryString:[NSString stringWithFormat:@"title:(%@)", keys]];
    searchQuery.className = @"House";
    searchQuery.limit = kMaxNumOfPages;
    self.currentSearchQuery = searchQuery;
    [self searchWithQuery:searchQuery loadMore:NO];
}

- (NSArray *)keyWordsArrayWithString:(NSString *)string
{
    return [string componentsSeparatedByString:@" "];
}

#pragma mark - UISearchBar show & dismiss
- (void)searchBarShow
{
    self.searchBar.transform = CGAffineTransformMakeTranslation(0, -50);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBar.transform = CGAffineTransformMakeTranslation(0, 0);
        self.searchBar.alpha = 1.0;
    }];
}

- (void)searchBarDismiss
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBar.transform = CGAffineTransformMakeTranslation(0, -50);
        self.searchBar.alpha = 0;
    }];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"疯狂搜索中..."];
    self.currentKeys = searchBar.text;
    [self searchWithKeys:searchBar.text];
}

@end
