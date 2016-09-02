//
//  ViewController.m
//  TCP
//
//  Created by qijia on 16/6/13.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "ViewController.h"

#import "HLS_SPViewController.h"
#import "AV_ffpegViewController.h"
#import "AV_LZViewController.h"
#import "FdSxViewController.h"
#import "CGAffineTransformVC.h"
#import "CGContextViewC.h"
#import "ImageViewController.h"
#import "NetWorkViewController.h"
#import "GCDViewController.h"
#import "ZJMainViewController.h"
#define CELL_IFIER @"cell"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArr = [[NSArray alloc]initWithObjects:@"HLS_点播",@"HLS_直播",@"AVideo_录制",@"TCP_文件传输",@"TCP_长连接",@"音乐播放器",@"视频播放",@"蓝牙连接",@"放大缩小",@"CGAffineTransform",@"CGContext",@"图像处理",@"网络处理",@"线程处理",@"组件化", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IFIER];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IFIER];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        HLS_SPViewController *sp = [[HLS_SPViewController alloc]initWithNibName:@"HLS_SPViewController" bundle:nil];
        [self.navigationController pushViewController:sp animated:YES];
    }else if(indexPath.row==1){
        AV_ffpegViewController *av = [[AV_ffpegViewController alloc]init];
        av.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:av animated:YES];
    }else if(indexPath.row==2){
        AV_LZViewController *av = [[AV_LZViewController alloc]init];
        [self.navigationController pushViewController:av animated:YES];
    }else if(indexPath.row==8){
        FdSxViewController *fx = [[FdSxViewController alloc]init];
        [self.navigationController pushViewController:fx animated:YES];
    }else if(indexPath.row == 9){
        CGAffineTransformVC *cg = [[CGAffineTransformVC alloc]init];
        [self.navigationController pushViewController:cg animated:YES];
    }else if(indexPath.row == 10){
        CGContextViewC * context = [[CGContextViewC alloc]init];
        [self.navigationController pushViewController:context animated:YES];
    }else if(indexPath.row == 11){
        ImageViewController *image = [[ImageViewController alloc]init];
        [self.navigationController pushViewController:image animated:YES];
    }else if(indexPath.row == 12){
        NetWorkViewController *net = [[NetWorkViewController alloc]init];
        [self.navigationController pushViewController:net animated:YES];
    }else if(indexPath.row == 13){
        GCDViewController *net = [[GCDViewController alloc]init];
        [self.navigationController pushViewController:net animated:YES];
    }else if(indexPath.row==14){
        ZJMainViewController *zj = [[ZJMainViewController alloc]init];
        [self.navigationController pushViewController:zj animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
