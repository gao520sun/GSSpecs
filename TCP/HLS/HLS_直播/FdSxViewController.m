//
//  FdSxViewController.m
//  TCP
//
//  Created by qijia on 16/6/23.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "FdSxViewController.h"

@interface FdSxViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollview;
@end

@implementation FdSxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, 480-64)];
    self.scrollview.delegate = self;
    self.scrollview.backgroundColor = [UIColor whiteColor];
    [self.scrollview setMinimumZoomScale: 0.8];
    [self.scrollview setMaximumZoomScale: 30];
    [self.view addSubview:self.scrollview];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 60)];
    image.backgroundColor = [UIColor redColor];
    image.tag =22;
    [self.scrollview addSubview:image];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIView *v = [scrollView viewWithTag:22];
    return v;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
