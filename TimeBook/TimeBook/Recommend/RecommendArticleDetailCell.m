//
//  RecommendArticleDetailCell.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/8.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "RecommendArticleDetailCell.h"

#define PIC_HEIGHT  (WIDTH - 16 * 2) * 0.72

@interface RecommendArticleDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pic_height;

@end

@implementation RecommendArticleDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.descLabel.textColor = COLOR_NULL_2;
    
    int type = arc4random() % 4;
    switch (type) {
        case 0:
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - self.centerView.left * 2) - 72, 0, 3, PIC_HEIGHT)];
            line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
            [self.centerView addSubview:line];
            break;
        }
        case 1:
        {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(72, 0, 3, PIC_HEIGHT)];
            line1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
            [self.centerView addSubview:line1];
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 72, (WIDTH - self.centerView.left * 2), 3)];
            line2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
            [self.centerView addSubview:line2];
            break;
        }
        case 2:{
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (WIDTH - self.centerView.left * 2) * 0.36, PIC_HEIGHT)];
            line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.42];
            [self.centerView addSubview:line];
            break;
        }
        case 3:{
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, PIC_HEIGHT * 0.5, (WIDTH - self.centerView.left * 2) , PIC_HEIGHT * 0.5)];
            line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.42];
            [self.centerView addSubview:line];
            break;
        }
        default:
            break;
    }
    
    [self.centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.delegate) {
            [self.delegate selectCellWithModel:self.model];
        }
        
    }]];
}

- (void)setModel:(RecommendModel *)model {
    _model = model;
    
    self.descLabel.text = model.desc;
    [self.descLabel sizeToFit];
    
    [self.picture setImageURL:[NSURL URLWithString:model.image_url]];
    
    self.pic_height.constant = PIC_HEIGHT;
    [self layoutIfNeeded];
    
    self.pic_height.constant = PIC_HEIGHT + 72;
    [UIView animateWithDuration:3.6 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.pic_height.constant = PIC_HEIGHT;
        [UIView animateWithDuration:3.6 animations:^{
            [self layoutIfNeeded];
        }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
