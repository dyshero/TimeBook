//
//  WallPagerCategoryController.m
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallPagerCategoryController.h"
#import "WallpaperCell.h"
#import "WallpaperModel.h"
#import "WallPaperCategoryModel.h"
#import "WallpaperHeaderView.h"
#import "AFNet.h"
#import "WallpaperListController.h"

#define Space 5

@interface WallPagerCategoryController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation WallPagerCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self loadData];
}

- (void)loadData {
    _dataArray = [NSMutableArray array];
    [AFNet requestWithUrl:@"http://paper-cdn.2q10.com/api/list/paper_plus_best" requestType:HttpRequestTypeGet parameter:nil completation:^(id object) {
        for (NSDictionary *cateDict in object) {
            WallPaperCategoryModel *categoryModel = [WallPaperCategoryModel modelWithDictionary:cateDict];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in cateDict[@"thumbs"]) {
                WallpaperModel *model = [WallpaperModel modelWithDictionary:dict];
                [array addObject:model];
            }
            categoryModel.thumbs = array;
            [_dataArray addObject:categoryModel];
        }
        [self.collectionView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

- (void)configView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, Space, 0, Space);
    CGFloat itemW = (WIDTH - Space * 4)/3.0;
    layout.itemSize = CGSizeMake(itemW,693*itemW/390.0);
    layout.minimumInteritemSpacing = Space;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - NAVBAR_HEIGHT) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"WallpaperCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WallpaperHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    WallPaperCategoryModel *model = _dataArray[section];
    return model.thumbs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    WallPaperCategoryModel *model = _dataArray[indexPath.section];
    cell.model = model.thumbs[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, WIDTH*0.2);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WallpaperHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.model = _dataArray[indexPath.section];
        reusableView = headerView;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WallpaperListController *listVC = [[WallpaperListController alloc] init];
    WallPaperCategoryModel *model = _dataArray[indexPath.section];
    listVC.model = model;
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
