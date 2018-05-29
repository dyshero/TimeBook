//
//  RecommendDateDetailCtr.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "RecommendDateDetailCtr.h"

@interface RecommendDateDetailCtr ()

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_height;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *download_width;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabel_top;
@property (weak, nonatomic) IBOutlet UIView *smallLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallLine_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallLine_right;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@end

@implementation RecommendDateDetailCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_NULL_7;
    self.destinationLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.84];
    
    self.descLabel_top.constant = STATUEBAR_HEIGHT + 8;
    self.descLabel.verticalText = @"下载作品";
    [self.descLabel sizeToFit];
    
    [self.downloadBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.92] forState:UIControlStateNormal];
    self.downloadBtn.layer.transform = CATransform3DMakeRotation(45 * M_PI_2 / 90, 0, 0, 1);
    [self.downloadBtn setLayerShadow:COLOR_NULL_6 offset:CGSizeMake(0, 0) radius:8];
    
    [self.backBtn setThemeBGColor];
    self.backBtn.alpha = 0.84;
    
    self.smallLine.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.72];
    self.bottomView.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.64];
    self.bottomView.hidden = YES;

    [self.picture setImageURL:[NSURL URLWithString:self.img_url]];
    self.titleLabel.text = self.pic_title;
    self.destinationLabel.text = self.destination;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.backBtn.hidden) {
            
            self.backBtn.hidden = self.line.hidden = self.descLabel.hidden = self.downloadBtn.hidden = NO;
            [UIView animateWithDuration:0.36 animations:^{
                self.line.alpha = self.descLabel.alpha = self.downloadBtn.alpha = 1.f;
                self.backBtn.alpha = 0.84;
                
                self.bottomView.alpha = 0.f;
            } completion:^(BOOL finished) {
                self.bottomView.hidden = YES;
            }];
        }else {
            self.bottomView.hidden = NO;
            [UIView animateWithDuration:0.36 animations:^{
                self.bottomView.alpha = 1.f;
                self.backBtn.alpha = self.line.alpha = self.descLabel.alpha = self.downloadBtn.alpha = 0.f;
            } completion:^(BOOL finished) {
                self.backBtn.hidden = self.line.hidden = self.descLabel.hidden = self.downloadBtn.hidden = YES;
            }];
        }
        
    }]];
}

- (IBAction)clickDownload:(id)sender {
    
    self.line_height.constant = STATUEBAR_HEIGHT + 8;
    self.descLabel_top.constant = - self.descLabel.height;
    [UIView animateWithDuration:0.48 delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
        self.line.alpha = 0.f;

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.64 animations:^{
            self.downloadBtn.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.72];
            [self.downloadBtn setCornerRadius:0.f];
            self.downloadBtn.layer.transform = CATransform3DMakeRotation(360 * M_PI_2 / 90, 0, 0, 1);
        } completion:^(BOOL finished) {
            
            self.download_width.constant = 96;
            self.smallLine_right.constant = 12;
            self.smallLine_width.constant = 12;
            [UIView animateWithDuration:0.48 animations:^{
                [self.view layoutIfNeeded];
                [self.downloadBtn setTitle:@"正在下载" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                //下载
                [self downLoadPic];
            }];
        }];
    }];
}

- (IBAction)back:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)downLoadPic {
    if (self.picture.image) {
        UIImage *photo = self.picture.image;
        
        UIImageWriteToSavedPhotosAlbum(photo, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }

}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        self.smallLine_width.constant = 0.f;
        [UIView animateWithDuration:0.64 delay:1.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
            self.downloadBtn.alpha = 0.f;
            [self.downloadBtn setTitle:@"下载成功" forState:UIControlStateNormal];

        } completion:^(BOOL finished) {
            
            self.downloadBtn.hidden = YES;
        }];
    } else {
        self.smallLine_width.constant = 0.f;
        [UIView animateWithDuration:0.64 delay:1.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
            self.downloadBtn.backgroundColor = [COLOR_EMPHASIZE colorWithAlphaComponent:0.72];
            [self.downloadBtn setTitle:@"下载失败" forState:UIControlStateNormal];

        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
