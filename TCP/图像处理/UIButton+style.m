//
//  UIButton+style.m
//  iDoctor8Family
//
//  Created by 000000 on 16/8/1.
//  Copyright © 2016年 肖扬. All rights reserved.
//

#import "UIButton+style.h"
@implementation UIButton (style)

- (void)SetbuttonType:(buttonType)type{
    
    //需要在外部修改标题背景色的时候将此代码注释
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.imageView.backgroundColor = self.backgroundColor;
    
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGSize btnSize = self.bounds.size;
    CGFloat interval = 2.0;
    
    if (type == buttonTypeLeft) {
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval)];
        
    } else if(type == buttonTypeBottom) {
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,(btnSize.width - imageSize.width)/2, titleSize.height + interval, (btnSize.width - imageSize.width)/2)];
        [self setTitleEdgeInsets: UIEdgeInsetsMake(imageSize.height, -((btnSize.width - titleSize.width)/2), 0, 0)];
    }
    
}

@end
