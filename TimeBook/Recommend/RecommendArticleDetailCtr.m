//
//  RecommendArticleDetailCtr.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "RecommendArticleDetailCtr.h"
#import "RecommendDateDetailCtr.h"

#import "BaseTableView.h"
#import "RecommendArticleDetailHeader.h"
#import "RecommendArticleDetailCell.h"

@interface RecommendArticleDetailCtr () <UITableViewDelegate,UITableViewDataSource,RecommendArticleDetailCellProtocol>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic,strong) RecommendArticleDetailHeader *header;

@property (nonatomic,strong) UIView *footer;

@property (nonatomic,assign) BOOL isWhite;

@end

@implementation RecommendArticleDetailCtr

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.backBtn setCornerRadius:self.backBtn.height * 0.5];
    [self.backBtn setImage:[[UIImage imageNamed:@"return.png"] imageByTintColor:[APPUtils getThemeColor]] forState:UIControlStateNormal];
    self.backBtn.layer.masksToBounds = NO;
    self.backBtn.clipsToBounds = NO;
    self.backBtn.layer.shadowColor = COLOR_NULL_6.CGColor;
    self.backBtn.layer.shadowRadius = 8;
    self.backBtn.layer.shadowOpacity = 1;
    self.backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self.bottomLeftView setGradientBGColorWithLeftColor:[UIColor whiteColor] rightColor:[[UIColor whiteColor] colorWithAlphaComponent:0.f]];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendArticleDetailCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.tableView setContentOffset:CGPointMake(0, self.header.height) animated:YES];
    }]];
    
    [self loadData];
}

- (IBAction)clickBack:(id)sender {
    [self back];
}

-(void)loadData {
    
    self.header.model = self.model;
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:self.model.image_url] options:YYWebImageOptionIgnoreFailedURL progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        if (image) {
            dispatch_async_on_main_queue(^{
                self.header.picture.image = image;
                
                self.header.height += WIDTH * image.size.height / image.size.width;;
                self.tableView.tableHeaderView = self.header;
            });
        }
        
    }];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.model.description_notes];
    [arr addObjectsFromArray:self.model.photos];
    
    CGFloat interval = 4;
    
    self.bottomScrollView.contentSize = CGSizeMake(arr.count * (self.bottomView.height - interval) + interval, self.bottomView.height);

    [self.bottomScrollView removeAllSubviews];
    
    [self.datas removeAllObjects];
    for(NSInteger index = 0; index < arr.count; index ++){
        
        NSDictionary *dict = arr[index];
        
        RecommendModel *model = [RecommendModel modelWithDictionary:dict];
        model.desc = dict[@"description"];
        model.height = (WIDTH - 16 * 2) * 0.72 + 8 + [model.desc heightForFont:[UIFont systemFontOfSize:FONT_SIZE_2] width:(WIDTH - 16 * 2)];
        [self.datas addObject:model];
        
        UIImageView *bottomImgView = [UIImageView imageViewWithNetImage:model.image_url frame:CGRectMake(self.bottomScrollView.contentSize.width - (self.bottomView.height - interval) * (index + 1), interval, self.bottomView.height - interval * 2, self.bottomView.height - interval * 2)];
        [self.bottomScrollView addSubview:bottomImgView];
        bottomImgView.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.16];
        bottomImgView.contentMode = UIViewContentModeScaleAspectFill;
        bottomImgView.clipsToBounds = YES;
    }

    [self.tableView reloadData];
}

#pragma mark - RecommendArticleDetailCellProtocol
- (void)selectCellWithModel:(RecommendModel *)model {
    
    RecommendDateDetailCtr *detailCtr = [RecommendDateDetailCtr nibCtrInitialiation];
    detailCtr.img_url = model.image_url;
    detailCtr.pic_title = self.model.title;
    detailCtr.destination = model.desc == nil ? (@"今日风景") : (model.desc);
    [self.navigationController presentViewController:detailCtr animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendArticleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendArticleDetailCell *picCell = (RecommendArticleDetailCell *)cell;
    RecommendModel *model = self.datas[indexPath.row];
    picCell.model = model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendModel *model = self.datas[indexPath.row];
    return model.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < 0) {
        self.tableView.contentOffset = CGPointZero;
    }
    
    CGFloat alpha = y / (HEIGHT * 0.32);
    
    if (alpha > 0.72) {
        
        if (self.isWhite == YES) {
            return;
        }
        self.isWhite = YES;
        
        [UIView animateWithDuration:0.24 animations:^{
            self.bottomView.alpha = 0.f;
            self.backBtn.backgroundColor = [UIColor whiteColor];
        }];
        
    }else {
        
        if (self.isWhite == NO) {
            return;
        }
        self.isWhite = NO;
        
        [UIView animateWithDuration:0.24 animations:^{
            self.bottomView.alpha = 1.f;
            self.backBtn.backgroundColor = [UIColor clearColor];
        }];
        
    }
}

- (RecommendArticleDetailHeader *)header {
    if (_header == nil) {
        _header = [RecommendArticleDetailHeader nibInitializtion];
        _header.frame = CGRectMake(0, 0, WIDTH, 200);
        self.tableView.tableHeaderView = _header;
    }
    return _header;
}

- (UIView *)footer {
    if (_footer == nil) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
        _footer.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"# %@",self.model.title] fontSize:FONT_SIZE_2 frame:CGRectMake(16, 24, WIDTH - 16 * 2, 24) color:COLOR_NULL_3 textAlignment:NSTextAlignmentLeft];
        titleLabel.numberOfLines = 1;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
        [attStr setColor:[APPUtils getThemeColor] range:NSMakeRange(0, 1)];
        titleLabel.attributedText = attStr;
        [_footer addSubview:titleLabel];
        
        UILabel *descLabel1 = [UILabel labelWithText:[NSString stringWithFormat:@"%@  图",self.model.photo_author] fontSize:FONT_SIZE_4 frame:CGRectMake(16, titleLabel.bottom + 16, WIDTH - 16 * 2, 16) color:COLOR_NULL_4 textAlignment:NSTextAlignmentRight];
        descLabel1.numberOfLines = 1;
        [_footer addSubview:descLabel1];
        
        UILabel *descLabel2 = [UILabel labelWithText:[NSString stringWithFormat:@"%@  文",self.model.text_author] fontSize:FONT_SIZE_4 frame:CGRectMake(16, descLabel1.bottom + 4, WIDTH - 16 * 2, 16) color:COLOR_NULL_4 textAlignment:NSTextAlignmentRight];
        descLabel2.numberOfLines = 1;
        [_footer addSubview:descLabel2];

    }
    return _footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
