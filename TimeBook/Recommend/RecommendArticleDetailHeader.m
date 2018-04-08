//
//  RecommendArticleDetailHeader.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/8.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "RecommendArticleDetailHeader.h"

@interface RecommendArticleDetailHeader ()

@property (weak, nonatomic) IBOutlet UIView *square;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_top;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UILabel *descLabel2;

@end

@implementation RecommendArticleDetailHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picture.backgroundColor = COLOR_NULL_7;
    
    [self.square setThemeBGColor];
    
    self.descLabel1.textColor = self.descLabel2.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.96];
    self.contentLabel.textColor = COLOR_NULL_2;
}

- (void)setModel:(RecommendModel *)model {
    _model = model;
    
    self.contentLabel.text = model.desc;
    
    [self.contentLabel sizeToFit];
    self.height = self.contentLabel.bottom + 8;
    
    self.descLabel1.text = [NSString stringWithFormat:@"图by  %@",self.model.photo_author];
    self.descLabel2.text = [NSString stringWithFormat:@"文by  %@",self.model.text_author];
    
    //动画
    [UIView animateWithDuration:0.72 animations:^{
        
        self.square.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 180 * M_PI_2 / 90);
        
    } completion:^(BOOL finished) {
        
        self.title_top.constant = self.square.height + 12;
        [UIView animateWithDuration:0.72 animations:^{
            
            [self layoutIfNeeded];

            self.titleLabel.verticalText = model.title;
            [self.titleLabel sizeToFit];//顶部显示
            
            self.square.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 360 * M_PI_2 / 90);
        } completion:^(BOOL finished) {
            
            [self.titleLabel setGradientBGColorWithTopColor:[APPUtils getThemeColor] bottomColor:[[APPUtils getThemeColor] colorWithAlphaComponent:0.f]];

        }];
    }];
}


@end
