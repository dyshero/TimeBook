//
//  SampleReelsCell.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/11.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "SampleReelsCell.h"

#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

@interface SampleReelsCell () <NewPagedFlowViewDataSource,NewPagedFlowViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NewPagedFlowView *pageFlowView;

@end

@implementation SampleReelsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = COLOR_NULL_1;
    self.subTitleLabel.textColor = COLOR_NULL_3;
    
    self.pageFlowView.delegate = self;
    self.pageFlowView.dataSource = self;
    self.pageFlowView.minimumPageAlpha = 0.56f;
    self.pageFlowView.minimumPageScale = 0.72f;
    self.pageFlowView.isCarousel = YES;
    self.pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    self.pageFlowView.isOpenAutoScroll = NO;
    
    [self reloadThemeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadThemeColor) name:@"change_theme_color" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(RecommendModel *)model {
    _model = model;

    self.titleLabel.text = model.name_en;
    self.subTitleLabel.text = model.name_zh_cn;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",model.articles.count];
    
    [self.pageFlowView reloadData];
}

- (void)reloadThemeColor {
    self.numberLabel.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.48];
    
    [self.pageFlowView reloadData];
}

#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.model.articleModels.count;
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    CGFloat height = flowView.height - 16;
    CGFloat width = height * 0.64;
    return CGSizeMake(width, height);
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        CGFloat height = flowView.height - 16;
        CGFloat width = height * 0.64;
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.layer.masksToBounds = NO;
        bannerView.clipsToBounds = NO;
        bannerView.layer.shadowColor = COLOR_NULL_6.CGColor;
        bannerView.layer.shadowRadius = 4;
        bannerView.layer.shadowOpacity = 1;
        bannerView.layer.shadowOffset = CGSizeMake(0, 0);
        
        bannerView.mainImageView.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.16];
        bannerView.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerView.mainImageView.clipsToBounds = YES;
    }
    
    RecommendModel *model = self.model.articleModels[index];
    [bannerView.mainImageView setImageURL:[NSURL URLWithString:model.image_url]];
    
    return bannerView;
}

#pragma mark - PagedFlowView Delegate
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex inFlowView:(NewPagedFlowView *)flowView {
    
    if (self.delegate) {
        RecommendModel *model = self.model.articleModels[subIndex];
        [self.delegate selectCellWithModel:model];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
