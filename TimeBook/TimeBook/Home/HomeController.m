//
//  HomeController.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "HomeController.h"
#import "RecommendController.h"
#import "SampleReelsController.h"
#import "WallPagerCategoryController.h"
#import "ThemeColorView.h"

@interface HomeController ()
{
    BOOL _recommend_loaded;
    BOOL _sampleReels_loaded;
    BOOL _wallpaper_loaded;
}
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIView *colorView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) RecommendController *recommendCtr;
@property (nonatomic,strong) SampleReelsController *sampleReelsCtr;
@property (nonatomic,strong) WallPagerCategoryController *wallpaperCtr;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}

- (void)loadUI {
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.colorView];
    [self.view addSubview:self.scrollView];
    [self reloadThemeColor];
}

- (void)reloadThemeColor {
    [self clickTitleAtIndex:1];
    
    [self.colorView setThemeBGColor];
}

- (void)clickTitleAtIndex:(NSInteger)index {
    
    for (UIButton *btn in self.datas) {
        [btn setTitleColor:COLOR_NULL_3 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_3];
    }
    
    UIButton *selectBtn = self.datas[index];
    [selectBtn setTitleColor:[APPUtils getThemeColor] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_1];
    
    switch (index) {
        case 0:
        {
            [self.scrollView scrollToLeft];
            if (_sampleReels_loaded == NO) {
                _sampleReels_loaded = YES;
                
                [self.scrollView addSubview:self.sampleReelsCtr.view];
            }
            break;
        }
        case 1:
        {
            [self.scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
            if (_recommend_loaded == NO) {
                _recommend_loaded = YES;
                
                [self.scrollView addSubview:self.recommendCtr.view];
            }
            break;
        }
        case 2:
        {
            [self.scrollView scrollToRight];
            if (_wallpaper_loaded == NO) {
                _wallpaper_loaded = YES;
                
                [self.scrollView addSubview:self.wallpaperCtr.view];
            }
            break;
        }
        default:
            break;
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - NAVBAR_HEIGHT)];
        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(WIDTH * 3, HEIGHT - NAVBAR_HEIGHT);
    }
    return _scrollView;
}

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 36)];
        
        NSArray *titleArr = @[@"作品",@"今日",@"壁纸"];
        CGFloat w = _titleView.width / titleArr.count;
        CGFloat h = _titleView.height;
        for (NSInteger index = 0; index < titleArr.count; index ++) {
            UIButton *btn = [UIButton buttonWithLocalImage:nil title:titleArr[index] titleColor:COLOR_NULL_3 fontSize:FONT_SIZE_3 frame:CGRectMake(w * index, 0, w, h) click:^{
                
                [self clickTitleAtIndex:index];
                
            }];
            [_titleView addSubview:btn];
            [self.datas addObject:btn];
        }
        
    }
    return _titleView;
}

- (UIView *)colorView {
    if (_colorView == nil) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        
        UILabel *TLabel = [UILabel labelWithText:@"T" fontSize:FONT_SIZE_2 frame:_colorView.bounds color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [_colorView addSubview:TLabel];
        
        [_colorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            [ThemeColorView show];
            
        }]];
    }
    return _colorView;
}

- (WallPagerCategoryController *)wallpaperCtr {
    if (_wallpaperCtr == nil) {
        _wallpaperCtr = [WallPagerCategoryController new];
        [self addChildViewController:_wallpaperCtr];
        _wallpaperCtr.view.frame = CGRectMake(WIDTH * 2, 0, WIDTH, HEIGHT - NAVBAR_HEIGHT);
    }
    return _wallpaperCtr;
}

- (SampleReelsController *)sampleReelsCtr {
    if (_sampleReelsCtr == nil) {
        _sampleReelsCtr = [SampleReelsController nibCtrInitialiation];
        [self addChildViewController:_sampleReelsCtr];
        _sampleReelsCtr.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT - NAVBAR_HEIGHT);
    }
    return _sampleReelsCtr;
}

- (RecommendController *)recommendCtr {
    if (_recommendCtr == nil) {
        _recommendCtr = [RecommendController nibCtrInitialiation];
        [self addChildViewController:_recommendCtr];
        _recommendCtr.view.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT - NAVBAR_HEIGHT);
    }
    return _recommendCtr;
}

@end
