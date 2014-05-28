//
//  ZuFangViewController.m
//  ZuFang
//
//  Created by Summer on 14/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import "ZuFangViewController.h"
#import "FangYuanGroupURL.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DetailViewController.h"
#import "ZuFangCell.h"
#import "FangYuanObject.h"
#import "ZFCell.h"

static NSInteger maxNumOfPages = 30;

@interface ZuFangViewController ()
{
    NSMutableArray *fangyuanArrays;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ZuFangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    fangyuanArrays = [[NSMutableArray alloc] initWithObjects:@"月月大傻逼", nil];
    self.title = @"赫尔呵呵";
    [self initCollectionView];
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
}

#pragma mark - UICollectionView DateSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"ZFCell";
    
    ZFCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = @"月月大傻逼";
    
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
