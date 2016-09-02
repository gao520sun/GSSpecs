//
//  ZJMainViewController.m
//  TCP
//
//  Created by qijia on 16/9/2.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "ZJMainViewController.h"
#import "CTMediator+ZJTestActions.h"
@interface ZJMainViewController ()

@end

@implementation ZJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"组件化";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 100, 80, 80);
    [btn setTitle:@"组件详情" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(infoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)infoBtn:(UIButton *)sender{
    id c = nil;
    UIViewController *viewController = [[CTMediator sharedInstance] CTMediator_viewControllerForDetail:c];
//    UIViewController *viewController = [[CTMediator sharedInstance]performTarget:@"A" action:@"nativeFetchDetailViewController" params:nil];
    [self.navigationController pushViewController:viewController animated:YES];
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
