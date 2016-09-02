//
//  GCDViewController.m
//  TCP
//
//  Created by qijia on 16/8/30.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "GCDViewController.h"
#import "GCDInfoViewController.h"
@interface GCDViewController()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSArray arrayWithObjects:@"dispatch_apply",@"dispatch_after",@"dispatch_sync",@"dispatch_async", @"串行队列",@"并发队列",@"dispatch_group",@"dispatch_source",@"dispatch_sample",nil];
    [self tabl];
}

-(void)tabl{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GCDInfoViewController *gc = [[GCDInfoViewController alloc]init];
    gc.type = (int)indexPath.row;
    [self.navigationController pushViewController:gc animated:YES];
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
