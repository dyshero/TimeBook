//
//  SampleReelsController.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "SampleReelsController.h"
#import "RecommendArticleDetailCtr.h"

#import "BaseTableView.h"
#import "SampleReelsCell.h"

#import "RecommendModel.h"

@interface SampleReelsController () <UITableViewDelegate,UITableViewDataSource,SampleReelsCellProtocol>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *failPic;

@property (nonatomic,strong) UIView *progressLine;

@end

@implementation SampleReelsController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SampleReelsCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self reloadThemeColor];
    
    [self.failPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self loadData];
    }]];
    
    [self loadData];
}

- (void)reloadThemeColor {
    
    self.progressLine.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];

    self.failPic.image = [[UIImage imageNamed:DEFAULT_FAIL_BG] imageByTintColor:[[APPUtils getThemeColor] colorWithAlphaComponent:0.48]];
    
    [self.tableView reloadData];
}

- (void)loadData {
    
    self.failPic.hidden = YES;
    
    self.progressLine.hidden = NO;
    [UIView animateWithDuration:1.2 delay:0.f options:UIViewAnimationOptionRepeat animations:^{
        self.progressLine.left = WIDTH;
    } completion:nil];
    
    if ([APPUtils getObjectForKey:CACHE_SAMPLEREEL]) {
        
        NSData *data = [APPUtils getObjectForKey:CACHE_SAMPLEREEL];
        if (data) {
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self loadDataWithArr:arr];
        }
    }
    
    [NetRequest loadSampleReelsSuccessBlock:^(id object) {
        
        NSArray *arr = object;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [APPUtils saveObject:data forKey:CACHE_SAMPLEREEL];
        
        [self loadDataWithArr:arr];
        
    } failBlock:^(NSString *error) {
        
        self.progressLine.hidden = YES;

        if (self.datas.count == 0) {
            self.failPic.hidden = NO;
        }else {
            self.failPic.hidden = YES;
        }
    }];
}

- (void)loadDataWithArr:(NSArray *)arr {
    
    self.progressLine.hidden = YES;
    self.failPic.hidden = YES;
    
    if (arr.count == self.datas.count) {
        return;
    }
    
    [self.datas removeAllObjects];
    for (NSDictionary *dict in arr) {
        RecommendModel *model = [RecommendModel modelWithDictionary:dict];
        
        NSMutableArray *articles = [NSMutableArray array];
        for (NSDictionary *subDict in model.articles) {
            RecommendModel *subModel = [RecommendModel modelWithDictionary:subDict];
            subModel.desc = subDict[@"description"];
            [articles addObject:subModel];
        }
        model.articleModels = articles;
        model.name_en = dict[@"destination"][@"name_en"];
        model.name_zh_cn = dict[@"destination"][@"name_zh_cn"];
        [self.datas addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark - SampleReelsCellProtocol
- (void)selectCellWithModel:(RecommendModel *)model {
    RecommendArticleDetailCtr *detailCtr = [RecommendArticleDetailCtr nibCtrInitialiation];
    detailCtr.model = model;
    [self.navigationController pushViewController:detailCtr animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SampleReelsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SampleReelsCell *sampleReelsCell = (SampleReelsCell *)cell;
    RecommendModel *model = self.datas[indexPath.row];
    sampleReelsCell.model = model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 342;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UIView *)progressLine {
    if (_progressLine == nil) {
        _progressLine = [[UIView alloc] initWithFrame:CGRectMake(- WIDTH * 0.64, HEIGHT * 0.42, WIDTH * 0.64, 4)];
        [self.tableView addSubview:_progressLine];
    }
    return _progressLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
