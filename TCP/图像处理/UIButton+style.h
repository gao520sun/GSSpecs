//
//  UIButton+style.h
//  iDoctor8Family
//
//  Created by 000000 on 16/8/1.
//  Copyright © 2016年 肖扬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,buttonType) {
    buttonTypeLeft = 0,
    buttonTypeBottom,
};

@interface UIButton (style)
@property (nonatomic ,assign) int index;
- (void)SetbuttonType:(buttonType)type;

@end
