//
//  WallpaperListController.m
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallpaperListController.h"
#import "AFNet.h"
#import "WallpaperModel.h"
#import "WallpaperCell.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import "WallPaperCategoryModel.h"
#import "WallpaperDetailController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define Space 5

@interface WallpaperListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UILabel *rightItemLabel;
@end

@implementation WallpaperListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    [self configView];
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self loadData];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self loadData];
    }];
    self.collectionView.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _dataArray = [NSMutableArray array];
        _page = 1;
        [self loadData];
    }];
    self.collectionView.mj_header = header;
    
    _rightItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2, NAVBAR_HEIGHT)];
    _rightItemLabel.font = [UIFont systemFontOfSize:19];
    _rightItemLabel.textAlignment = NSTextAlignmentRight;
    _rightItemLabel.textColor = [UIColor lightGrayColor];
    _rightItemLabel.text = [NSString stringWithFormat:@"%@ ·  %@",_model.title,_model.name];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightItemLabel];
}

- (void)loadData {
    [AFNet requestWithUrl:[NSString stringWithFormat:@"http://paper-cdn.2q10.com/api/list/%@?page=%ld",_model.alias,_page] requestType:0 parameter:nil completation:^(id object) {
        if (self.collectionView.mj_header.isRefreshing) {
            [self.collectionView.mj_header endRefreshing];
        }
        if (self.collectionView.mj_footer.isRefreshing) {
            [self.collectionView.mj_footer endRefreshing];
        }
        for (NSDictionary *dict in object) {
            if ([dict[@"cat"] isEqualToString:@"more"]) {
                continue;
            }
            WallpaperModel *model = [WallpaperModel modelWithDictionary:dict];
            [_dataArray addObject:model];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)configView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, Space, 0, Space);
    CGFloat itemW = (kScreenWidth - Space * 4)/3.0;
    layout.itemSize = CGSizeMake(itemW,693*itemW/390.0);
    layout.minimumInteritemSpacing = Space;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - NAVBAR_HEIGHT - SafeAreaBottom - 5) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"WallpaperCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    WallpaperModel *model = _dataArray[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = collectionView.indexPathsForVisibleItems;
    if (array.count == 0)return;
    NSIndexPath *firstIndexPath = array[0];
    if (firstIndexPath.row < indexPath.row) {
        CATransform3D rotation;
        rotation = CATransform3DMakeTranslation(0 ,150 ,20);
        rotation = CATransform3DScale(rotation,0.9,0.9,1);
        rotation.m34 = 1.0/ -600;
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowOffset = CGSizeMake(10,10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        [UIView animateWithDuration:1.0 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0,0);
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WallpaperDetailController *detailVC = [[WallpaperDetailController alloc] init];
    WallpaperModel *model = _dataArray[indexPath.item];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
