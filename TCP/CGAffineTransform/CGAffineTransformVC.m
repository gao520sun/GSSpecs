//
//  CGAffineTransformVC.m
//  TCP
//
//  Created by qijia on 16/7/26.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "CGAffineTransformVC.h"

@implementation CGAffineTransformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Affine";
    UIButton *affBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 150, 60, 60)];
    [affBtn setTitle:@"测试" forState:UIControlStateNormal];
    affBtn.backgroundColor = [UIColor redColor];
    [affBtn addTarget:self action:@selector(affTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:affBtn];
    
    UIButton *affBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(60, 500, 60, 60)];
    [affBtn1 setTitle:@"测试" forState:UIControlStateNormal];
    affBtn1.backgroundColor = [UIColor redColor];
    [affBtn1 addTarget:self action:@selector(affTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:affBtn1];
    
}

-(void)affTestBtn:(UIButton *)btn{

   [UIView animateWithDuration:5 animations:^{
       btn.transform = CGAffineTransformMake(0, 1, 0, 0, 0, 1);
       btn.transform = CGAffineTransformMakeRotation(180);//旋转
       btn.transform = CGAffineTransformMakeScale(1, 2);//在原来的基础上Frame 进行放大缩小
       btn.transform = CGAffineTransformMakeTranslation(20, 200);//按照x，y坐标进行平移
//       同时进行 修改矩阵
       CGAffineTransform t = CGAffineTransformMakeTranslation(20, 200);
       CGAffineTransform t2 = CGAffineTransformMakeTranslation(80, 300);
       btn.transform = CGAffineTransformTranslate(t, 0, -100);
       btn.transform = CGAffineTransformScale(t, 2, 2);
       btn.transform = CGAffineTransformRotate(t, -360);
       btn.transform = CGAffineTransformInvert(t);//反方向
       btn.transform = CGAffineTransformConcat(t, t2);//连载一起的返回通过结合两个现有的仿射变换构建了一个仿射变换矩阵。
       
//       应用仿射变换
//        CGAffineTransform t = CGAffineTransformMakeTranslation(100, 200);
//       CGPoint p = CGPointMake(10, 20);
//       btn.center = CGPointApplyAffineTransform(p, t);//把变化应用到一个点上
       
//       CGSize size = CGSizeApplyAffineTransform(CGSizeMake(80, 80), t);
//       btn.frame = CGRectMake(60, 150, size.width, size.height);
//       btn.frame = CGRectApplyAffineTransform(CGRectMake(20, 300, 50, 50), t);
       //得出 x+x y+y 120.000000...500.000000.....50.000000....50.000000
//       NSLog(@"btn.frame...%f...%f.....%f....%f",btn.frame.origin.x,btn.frame.origin.y,btn.frame.size.width,btn.frame.size.height);
       //清空
//      btn.transform =  CGAffineTransformIdentity
   }];
    
    

}

@end
