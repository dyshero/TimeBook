//
//  WallpaperController.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "WallpaperController.h"
#import "RecommendDateDetailCtr.h"

#import <MJRefresh.h>
#import "NSString+Util.h"
#import "ScrollViewFooter.h"
#import "ScrollViewHeader.h"

#import "WallpaperCell.h"

@interface WallpaperController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerPreviewingDelegate>
{
    NSMutableArray *_allDatas;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *failPic;

@property (nonatomic,strong) UIView *progressLine;

@property (nonatomic,assign) int start;

@end

@implementation WallpaperController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = flowLayout;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WallpaperCell class]) bundle:nil] forCellWithReuseIdentifier:@"wallpaper"];
    
    [self reloadThemeColor];

    self.collectionView.mj_header = [ScrollViewHeader headerWithRefreshingBlock:^{
        self.start = 0;
        [self loadData];
    }];
    
    self.collectionView.mj_footer = [ScrollViewFooter footerWithRefreshingBlock:^{
        self.start += 1;
        [self loadData];
    }];

    [self.failPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self loadAllData];
    }]];
    
    [self loadAllData];
}

- (void)reloadThemeColor {
    
    self.progressLine.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];
    self.failPic.image = [[UIImage imageNamed:DEFAULT_FAIL_BG] imageByTintColor:[[APPUtils getThemeColor] colorWithAlphaComponent:0.48]];
    
    [self.collectionView reloadData];
}

- (void)loadAllData {
    
    self.failPic.hidden = YES;
    
    self.progressLine.hidden = NO;
    [UIView animateWithDuration:1.2 delay:0.f options:UIViewAnimationOptionRepeat animations:^{
        self.progressLine.left = WIDTH;
    } completion:nil];
    
    if ([APPUtils getObjectForKey:CACHE_WALLPAPER]) {
        NSArray *arr = [APPUtils getObjectForKey:CACHE_WALLPAPER];
        [self loadAllDataWithArr:arr];
    }
    
    [NetRequest loadWallpapersSuccessBlock:^(id object) {

        NSArray *arr = object;
        
        [APPUtils saveObject:arr forKey:CACHE_WALLPAPER];

        [self loadAllDataWithArr:arr];
        
    } failBlock:^(NSString *error) {
        
        self.progressLine.hidden = YES;

        if (self.datas.count == 0) {
            self.failPic.hidden = NO;
        }else {
            self.failPic.hidden = YES;
        }
    }];
}

- (void)loadAllDataWithArr:(NSArray *)arr {
    
    self.progressLine.hidden = YES;
    self.failPic.hidden = YES;
    
    if (_allDatas && _allDatas.count > 0 && arr.count == _allDatas.count) {
        return;
    }

    _allDatas = [NSMutableArray array];
    
    NSMutableArray *array= [NSMutableArray arrayWithArray:arr];
    
    for(int i = 0;i < array.count;i ++) {
        
        WallpaperModel *model = [WallpaperModel modelWithDictionary:array[i]];
        NSString *date = [model.publish_date month];
        NSMutableArray*tempArray = [NSMutableArray array];
        
        [tempArray addObject:model];
        
        for(int j = i+1;j < array.count;j ++) {
            
            WallpaperModel *otherModel = [WallpaperModel modelWithDictionary:array[j]];
            
            NSString *otherDate = [otherModel.publish_date month];
            
            if([date isEqualToString:otherDate]){
                
                [tempArray addObject:otherModel];
                
                [array removeObjectAtIndex:j];
                j -= 1;
                
            }
            
        }
        [_allDatas addObject:@{@"month":[model.publish_date month],@"arr":tempArray}];
    }
    
    self.start = 0;
    [self loadData];
    
}

- (void)loadData {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];

    if (_allDatas && _allDatas.count > 0) {
        
        if (self.start < _allDatas.count) {
            [self.datas removeAllObjects];
            
            for (NSInteger index = 0; index <= self.start; index ++) {
                [self.datas addObject:_allDatas[index]];
            }
            
            [self.collectionView reloadData];
        }else { //没有更多数据
            
        }
    }
}

#pragma mark - 3D Touch
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint) point
{
    WallpaperCell *cell = (WallpaperCell *)[context sourceView];
    RecommendDateDetailCtr *detailCtr = [RecommendDateDetailCtr nibCtrInitialiation];
    detailCtr.img_url = cell.model.ios_wallpaper_url;
    detailCtr.pic_title = cell.model.title;
    detailCtr.destination = cell.model.destination;
    detailCtr.preferredContentSize = CGSizeMake(0.0f,HEIGHT - NAVBAR_HEIGHT);
    return detailCtr;
}

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showDetailViewController:viewControllerToCommit sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    NSDictionary *dict = self.datas[indexPath.section];
    NSArray *arr = dict[@"arr"];
    WallpaperModel *model = arr[indexPath.item];
    
    RecommendDateDetailCtr *detailCtr = [RecommendDateDetailCtr nibCtrInitialiation];
    detailCtr.img_url = model.ios_wallpaper_url;
    detailCtr.pic_title = model.title;
    detailCtr.destination = model.destination;
    [self.navigationController presentViewController:detailCtr animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.datas.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dict = self.datas[section];
    NSArray *arr = dict[@"arr"];
    return arr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wallpaper" forIndexPath:indexPath];

#ifdef __IPHONE_9_0
    //如果响应3D Touch
    if ([UIDevice systemVersion] >= 9) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
#endif
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    WallpaperCell *wallpaperCell = (WallpaperCell *)cell;
    NSDictionary *dict = self.datas[indexPath.section];
    NSArray *arr = dict[@"arr"];
    wallpaperCell.model = arr[indexPath.item];
    wallpaperCell.isLeft = indexPath.item % 2 == 0 ? (YES):(NO);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"header" forIndexPath:indexPath];
        [view removeAllSubviews];
        
        NSDictionary *dict = self.datas[indexPath.section];
        NSString *month = dict[@"month"];
        
        UILabel *titleLabel = [UILabel labelWithText:month fontSize:FONT_SIZE_1 frame:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        titleLabel.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.48];
        [view addSubview:titleLabel];
        [titleLabel sizeToFit];
        titleLabel.width += 32;
        titleLabel.height += 6;
        titleLabel.centerX = WIDTH * 0.5;
        titleLabel.top = (48 - titleLabel.height) * 0.5;
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left - 48, titleLabel.top + titleLabel.height * 0.5 - 0.5 , 36, 1)];
        line1.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];
        [view addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right + 12, titleLabel.top + titleLabel.height * 0.5 - 0.5 , 36, 1)];
        line2.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];
        [view addSubview:line2];
        
        return view;
    }else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = WIDTH * 0.5;
    CGFloat height = width * 3 / 2;
    return CGSizeMake(width, height);
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 48);
}

- (UIView *)progressLine {
    if (_progressLine == nil) {
        _progressLine = [[UIView alloc] initWithFrame:CGRectMake(- WIDTH * 0.64, HEIGHT * 0.42, WIDTH * 0.64, 4)];
        [self.collectionView addSubview:_progressLine];
    }
    return _progressLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
