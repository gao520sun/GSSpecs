//
//  NetWorkViewController.m
//  TCP
//
//  Created by qijia on 16/8/23.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "NetWorkViewController.h"
#import "LXNetworkServiceHelper.h"
#import "LXFileCacheManager.h"

#import <MediaPlayer/MediaPlayer.h>
static NSString *const dataUrl = @"http://api.douban.com/v2/movie/top250?apikey=02d830457f4a8f6d088890d07ddfae47";

static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";
#define URL2 @"http://pcdowncc.imgo.tv/c22b568e89664260ea872330ba774741/552b608f/c1/2014/dianshiju/jinpaihongniang/2014103198b69041-6f7a-46fd-b0b5-066937cda764.fhv.mp4"
/** 是否开始下载*/
@interface NetWorkViewController()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, assign, getter=isDownload) BOOL download;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic,strong) UILabel *lbl;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSData *data;
@property (strong, nonatomic) NSURLSession *session; // 下载的支持父类
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation NetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络";
    self.view.backgroundColor = [UIColor whiteColor];
    self.array = [[NSMutableArray alloc]init];
    self.dataArr = [NSMutableArray arrayWithObjects:downloadUrl,URL2, nil];
    //无缓存
    [[LXNetworkServiceHelper sharedManager] lx_serviceWithUrl:@"http://qafjzl.haoyisheng.com/hys-mgp/app/fd/fmSign/signApply" params:@{@"userId":@"1d25641272864b0d9d40c0d10e886d1f"} modelObject:@"IDSignModel" requestType:LX_GET request:^(id responseObject) {
        if(responseObject){
            NSLog(@"responseObject...%@",responseObject);
        }
    } progress:nil failed:nil];
    
    //有缓存
//    [LXNetworkServiceHelper lx_serviceCacheWithUrl:dataUrl params:nil modelObject:nil responseCache:^(id responseCache) {
//        if(responseCache){
//            NSLog(@"responseCache...%@",responseCache);
//        }
//    } requestType:LX_GET request:^(id responseObject) {
//        if(responseObject){
//            NSLog(@"responseObject...%@",responseObject);
//        }
//    } progress:nil failed:nil];

    
//   NSArray *ar =  [[LXNetworkServiceHelper sharedManager]getDownloadTask];
//    NSLog(@"ar..%@",ar);
//    
//    [self tabl];
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
    cell.contentView.backgroundColor = [UIColor grayColor];
//    cell.textLabel.text = self.dataArr[indexPath.row];
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text =[self.dataArr[indexPath.row] lastPathComponent];
    lbl.frame = CGRectMake(10, 0, 100, 40);
    lbl.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lbl];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.tag = indexPath.row;
    btn.frame = CGRectMake(280, 0, 100, 40);
    BOOL b =  [[LXFileCacheManager sharedManager]directoryFileIsExist:@"gao" fileName:[self.dataArr[indexPath.row] lastPathComponent]];
    if(b){
        [btn setTitle:@"播放视频" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn setTitle:@"开始下载" forState:UIControlStateNormal];
        btn.selected = YES;
        [btn addTarget:self action:@selector(downloadBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [cell.contentView addSubview:btn];
    return cell;
}

-(void)payBtn:(UIButton *)btn{
    NSString *movieurl = [[LXFileCacheManager sharedManager]getFilePath:[NSString stringWithFormat:@"gao/%@",[self.dataArr[btn.tag] lastPathComponent]]];
    NSLog(@"moce..>%@",movieurl);
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:movieurl]];
    
    [self presentMoviePlayerViewControllerAnimated:player];
}


-(void)downloadBtn:(UIButton *)sender{
    NSString *urls = self.dataArr[sender.tag];
    
    BOOL b =  [[LXFileCacheManager sharedManager]directoryFileIsExist:@"gao" fileName:[urls lastPathComponent]];
    if(!b){
        
        if(sender.selected){//下载
            sender.selected = NO;
            [sender setTitle:@"暂停下载" forState:UIControlStateNormal];
            [[LXNetworkServiceHelper sharedManager]lx_serviceDownloadWithUrl:urls params:nil fileDir:@"gao" request:^(id responseObject) {
                if(responseObject){
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            } progress:^(NSProgress *progress) {
                NSLog(@"下载进度:%.2f%%   ",100.0*progress.completedUnitCount/progress.totalUnitCount);
                
            } failed:nil];
            
        }else{//暂停
            NSArray *ar =  [[LXNetworkServiceHelper sharedManager]getDownloadTask];
            NSURLSessionDownloadTask *dataTask;
            for(NSURLSessionDownloadTask *task in ar){
                if([task.response.URL.absoluteString isEqualToString:urls]){
                    dataTask = task;
                    break;
                }
            }
            sender.selected = YES;
            [sender setTitle:@"开始下载" forState:UIControlStateNormal];
            
            [dataTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                if(resumeData.length>0){
                    [[LXFileCacheManager sharedManager]saveResumeData:resumeData key:[urls lastPathComponent]];
                }else{
                    NSLog(@"没有数据");
                }
                
            }];
            [dataTask suspend];
            
        }
        
    }else{
        NSLog(@"文件已存在");
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"文件已存在" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alt show];
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}





@end
