//
//  WallpaperBottomView.m
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallpaperBottomView.h"
#import "WallpaperModel.h"
#import "MyAnnotation.h"

@interface WallpaperBottomView()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubdateLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation WallpaperBottomView
- (void)awakeFromNib {
    [super awakeFromNib];
    _mapView.delegate = self;
    _mapView.layer.cornerRadius = 5;
    _mapView.clipsToBounds = YES;
}

- (void)setModel:(WallpaperModel *)model {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"";
    [_mapView addAnnotation:annotation];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
    
    _contentLabel.text = model.content;
    _pubdateLabel.text = model.pubdate;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView     viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapSample"];
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (IBAction)bottomClicked:(UIButton *)sender {
    if (self.btmClickBlock) {
        self.btmClickBlock(sender.tag);
    }
}


@end
