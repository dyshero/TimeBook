//
//  UILabel+Util.h
//
//  Created by SKY
//  Copyright © 翊sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)

@property (nonatomic) NSString *verticalText;

+(UILabel *)labelWithText:(NSString *)string
                 fontSize:(CGFloat)fontSize
                    frame:(CGRect)frame
                    color:(UIColor *)color
            textAlignment:(int)textAlignment;

-(NSArray *)getSeparatedLinesFromLabel;

@end
