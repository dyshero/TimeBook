//
//  RecommendController.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "RecommendController.h"
#import "RecommendDateDetailCtr.h"
#import "RecommendArticleDetailCtr.h"

#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "AFNet.h"
#import "RecommendModel.h"

#import "NSDate+Category.h"
#import "NSString+Util.h"

@interface RecommendController () <NewPagedFlowViewDelegate,NewPagedFlowViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *failPic;
@property (weak, nonatomic) IBOutlet NewPagedFlowView *pageFlowView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabel_left;

@property (nonatomic,strong) UIView *progressLine;

@property (nonatomic, assign) int start;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeLabel_left.constant = -self.timeLabel.width;
    
    self.pageFlowView.delegate = self;
    self.pageFlowView.dataSource = self;
    self.pageFlowView.minimumPageAlpha = 0.36f;
    self.pageFlowView.minimumPageScale = 0.84f;
    self.pageFlowView.isCarousel = NO;
    self.pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    self.pageFlowView.isOpenAutoScroll = NO;
    
    [self reloadThemeColor];
    
    [self.failPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self loadData];
    }]];

    [self loadData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f block:^(NSTimer * _Nonnull timer) {
        
        NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
        
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:[[[NSDate today] year] integerValue]];
        [adcomps setMonth:[[[NSDate today] month_true] integerValue]];
        [adcomps setDay:[[[NSDate today] day] integerValue] + 1];
        
        NSDate *newdate = [cal dateFromComponents:adcomps];
        
        NSDate *today = [NSDate date];//得到当前时间
        //用来得到具体的时差
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponents = [cal components:unitFlags fromDate:today toDate:newdate options:0];
        
        self.timeLabel.text = [NSString stringWithFormat:@"  下一话\n  %ld时%ld分%ld秒", [dateComponents hour], [dateComponents minute], [dateComponents second]];
        
    } repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pageFlowView.scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pageFlowView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)reloadThemeColor {
    
    self.timeLabel.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.64];

    self.failPic.image = [[UIImage imageNamed:DEFAULT_FAIL_BG] imageByTintColor:[[APPUtils getThemeColor] colorWithAlphaComponent:0.48]];
    
    self.progressLine.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];
    
    [self.pageFlowView reloadData];
}

- (void)loadData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.failPic.hidden = YES;
        
        self.progressLine.hidden = NO;
        [UIView animateWithDuration:1.2 delay:0.f options:UIViewAnimationOptionRepeat animations:^{
            self.progressLine.left = WIDTH;
        } completion:nil];
        
        NSString *url = [NSString stringWithFormat:@"http://chanyouji.com/api/pictorials/%@.json",[NSDate dateFromDay:self.start]];

        [AFNet requestWithUrl:url requestType:HttpRequestTypeGet parameter:nil completation:^(id object) {
            [self.datas removeAllObjects];
            
            self.progressLine.hidden = YES;
            self.failPic.hidden = YES;
            
            NSDictionary *dict = object;
            
            RecommendModel *dateModel = [RecommendModel modelWithDictionary:dict];
            dateModel.type = 1;
            [self.datas addObject:dateModel];
            
            NSArray *articles = dict[@"articles"];
            for (NSDictionary *subDict in articles) {
                RecommendModel *model = [RecommendModel modelWithDictionary:subDict];
                model.desc = subDict[@"description"];
                model.type = 2;
                [self.datas addObject:model];
            }
            
            [self.pageFlowView reloadData];

        } failure:^(NSError *error) {
            self.progressLine.hidden = YES;
            self.failPic.hidden = NO;
        }];
    });

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.pageFlowView.scrollView.contentOffset.x < 0) {
            self.timeLabel_left.constant = 0;
            [UIView animateWithDuration:0.36 animations:^{
                [self.view layoutIfNeeded];
            }];
        }else {
            self.timeLabel_left.constant = -self.timeLabel.width;
            [UIView animateWithDuration:0.36 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
}

#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.datas.count;
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    CGFloat height = flowView.height - 64;
    CGFloat width = WIDTH - 48;
    return CGSizeMake(width, height);
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        CGFloat height = flowView.height - 64;
        CGFloat width = WIDTH - 48;
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.layer.masksToBounds = NO;
        bannerView.clipsToBounds = NO;
        bannerView.layer.shadowColor = COLOR_NULL_6.CGColor;
        bannerView.layer.shadowRadius = 10;
        bannerView.layer.shadowOpacity = 1;
        bannerView.layer.shadowOffset = CGSizeMake(0, 0);

        bannerView.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerView.mainImageView.clipsToBounds = YES;
    }
    [bannerView.mainImageView removeAllSubviews];
    
    RecommendModel *model = self.datas[index];
    if (model.type == 1) {
        
        bannerView.mainImageView.image = nil;
        
        UIView *view = [[UIView alloc] initWithFrame:bannerView.bounds];
        [bannerView.mainImageView addSubview:view];
        
        __block CGFloat pic_y = 96;
        //日
        UILabel *dayLabel = [UILabel labelWithText:[[NSDate dateFromDay:(int)index] day] fontSize:64 frame:CGRectMake(12, pic_y, 0, 0) color:[APPUtils getThemeColor] textAlignment:NSTextAlignmentLeft];
        [dayLabel sizeToFit];
        [view addSubview:dayLabel];

        //月
        UILabel *monthLabel = [UILabel labelWithText:[[NSDate dateFromDay:(int)index] month] fontSize:FONT_SIZE_2 frame:CGRectMake(dayLabel.right + 8, pic_y, 0, 0) color:COLOR_NULL_2 textAlignment:NSTextAlignmentLeft];
        [monthLabel sizeToFit];
        [view addSubview:monthLabel];
        
        //黑标题
        UILabel *blackTitleLabel = [UILabel labelWithText:model.title fontSize:FONT_SIZE_4 frame:CGRectMake(dayLabel.left, pic_y, 0, 0) color:COLOR_NULL_3 textAlignment:NSTextAlignmentCenter];
        [blackTitleLabel sizeToFit];
        [view addSubview:blackTitleLabel];
        
        __block CGFloat pic_height = view.height - pic_y;
        
        //背景模糊图
        UIImageView *bgPic = [UIImageView imageViewWithNetImage:model.ios_wallpaper_url frame:CGRectMake(0, pic_y, view.width, pic_height)];
        bgPic.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.24];
        bgPic.alpha = 0.24;
        bgPic.contentMode = UIViewContentModeScaleAspectFill & UIViewContentModeBottom;
        bgPic.clipsToBounds = YES;
        [view addSubview:bgPic];
        
        __block CGFloat pic_width = pic_height * 375 / 667;
        
        //清晰图
        UIImageView *pic = [UIImageView imageViewWithNetImage:model.ios_wallpaper_url frame:CGRectMake((view.width - pic_width) * 0.5, pic_y, pic_width, pic_height)];
        pic.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.24];
        [view addSubview:pic];
        
        pic.layer.masksToBounds = NO;
        pic.clipsToBounds = NO;
        pic.layer.shadowColor = [UIColor whiteColor].CGColor;
        pic.layer.shadowRadius = 10;
        pic.layer.shadowOpacity = 0.64;
        pic.layer.shadowOffset = CGSizeMake(0, 0);
        
        //白色标题
        UILabel *whiteTitleLabel = [UILabel labelWithText:model.title fontSize:FONT_SIZE_1 frame:CGRectMake(8, pic.height * 0.5 - 64, pic.width - 16, 24) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        whiteTitleLabel.adjustsFontSizeToFitWidth = YES;
        [pic addSubview:whiteTitleLabel];
        
        //地点
        UILabel *destinationLabel = [UILabel labelWithText:model.destination fontSize:FONT_SIZE_2 frame:CGRectMake(8, whiteTitleLabel.bottom + 8, 0, 0) color:[[UIColor whiteColor] colorWithAlphaComponent:0.84] textAlignment:NSTextAlignmentCenter];
        [destinationLabel sizeToFit];
        [destinationLabel setLeft:(pic.width - destinationLabel.width) * 0.5];
        [pic addSubview:destinationLabel];
        
        //动画
        dayLabel.alpha = monthLabel.alpha = blackTitleLabel.alpha = 0.f;
        [UIView animateWithDuration:0.64 delay:0.48 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            dayLabel.alpha = monthLabel.alpha = 1.f;
            [dayLabel setTop:12];
            [monthLabel setBottom:dayLabel.bottom - 12];
            
        } completion:nil];
        
        [UIView animateWithDuration:2.4 delay:3.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            whiteTitleLabel.alpha = 0.f;
            [whiteTitleLabel setTop:whiteTitleLabel.top - 48];
            
            [destinationLabel setRight:pic.width - 8];
            [destinationLabel setBottom:pic.height - 8];
            destinationLabel.font = [UIFont systemFontOfSize:FONT_SIZE_4];
            
        } completion:^(BOOL finished) {
            whiteTitleLabel.hidden = YES;
            
            [UIView animateWithDuration:0.64 animations:^{
                
                blackTitleLabel.alpha = 1.f;
                destinationLabel.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];

                pic_y += 12;
                pic_height = view.height - pic_y;
                pic_width = pic_height * 375 / 667;
                bgPic.frame = CGRectMake(0, pic_y, view.width, pic_height);
                pic.frame = CGRectMake((view.width - pic_width) * 0.5, pic_y, pic_width, pic_height);
                
                [dayLabel setTop:4];
                [monthLabel setBottom:dayLabel.bottom - 12];
                [blackTitleLabel setTop:dayLabel.bottom - 6];
                [destinationLabel setBottom:pic.height - 8];

            } completion:nil];
        }];
        
        
    }else {
        [bannerView.mainImageView setImageURL:[NSURL URLWithString:model.image_url]];
        
        UIView *diamondView = [[UIView alloc] initWithFrame:CGRectMake(bannerView.mainImageView.width - 36, 16, 18, 18)];
        diamondView.alpha = 0.84;
        [diamondView setThemeBGColor];
        [bannerView.mainImageView addSubview:diamondView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(diamondView.left, diamondView.bottom + 8, 0, 0))];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_2];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.verticalText = model.title;
        [titleLabel sizeToFit];//顶部显示
        [titleLabel setWidth:diamondView.width];
        [titleLabel setGradientBGColorWithTopColor:[APPUtils getThemeColor] bottomColor:[[APPUtils getThemeColor] colorWithAlphaComponent:0.f]];
        [bannerView.mainImageView addSubview:titleLabel];
        
    }
    
    return bannerView;
}

#pragma mark - PagedFlowView Delegate
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex inFlowView:(NewPagedFlowView *)flowView {
    RecommendModel *model = self.datas[subIndex];
    if (model.type == 1) {
        RecommendDateDetailCtr *detailCtr = [RecommendDateDetailCtr nibCtrInitialiation];
        detailCtr.img_url = model.ios_wallpaper_url;
        detailCtr.pic_title = model.title;
        detailCtr.destination = model.destination;
        [self.navigationController presentViewController:detailCtr animated:YES completion:nil];
    }else {
        RecommendArticleDetailCtr *detailCtr = [RecommendArticleDetailCtr nibCtrInitialiation];
        detailCtr.model = model;
        [self.navigationController pushViewController:detailCtr animated:YES];
    }
}

- (UIView *)progressLine {
    if (_progressLine == nil) {
        _progressLine = [[UIView alloc] initWithFrame:CGRectMake(- WIDTH * 0.64, HEIGHT * 0.42, WIDTH * 0.64, 4)];
        [self.pageFlowView addSubview:_progressLine];
    }
    return _progressLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
