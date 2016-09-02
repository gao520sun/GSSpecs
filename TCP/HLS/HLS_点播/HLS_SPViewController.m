////
////  HLS_SPViewController.m
////  TCP
////
////  Created by qijia on 16/6/13.
////  Copyright © 2016年 qijia. All rights reserved.
////
//
#import "HLS_SPViewController.h"
//#import <MediaPlayer/MediaPlayer.h>
////#import "M3U8Handler.h"
//
//#import "VideoDownloader.h"
//
//#import "HTTPServer.h"
//
//#define kLibraryCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] 
//#define WebBasePath [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:@""]
//
//@interface HLS_SPViewController ()<M3U8HandlerDelegate, VideoDownloadDelegate,UIAlertViewDelegate>
//
///** 本地服务器对象 */
//@property (nonatomic, strong)HTTPServer * httpServer;
///** 下载管理对象 */
//@property (nonatomic, strong)VideoDownloader *downloader;
//
//@property (nonatomic, copy) NSString *URLString;
//
//@end
//
@implementation HLS_SPViewController
//#define TEST_HLS_URL @"http://yangchao0033.github.io/hlsSegement/0640.m3u8"
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    [self.downloader stopDownloadVideo];
//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isDownload"] boolValue]) {
//        self.downloadButton.enabled = YES;
//        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
//    }
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.title = @"点播";
//    self.URLString = TEST_HLS_URL;
//    /** 打开本地服务器 */
//    [self openHttpServer];
//    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDownload"] boolValue]) {
//        [self.downloadButton setTitle:@"已完成" forState:UIControlStateNormal];
//        self.downloadButton.enabled = NO;
//        self.clearButton.enabled = YES;
////        self.progressView.progress = 1;
//        self.progressLabel.text = @"100%";
//        /** 配置MSU8解析器 */
//        M3U8Handler *handler = [[M3U8Handler alloc] init];
//        [handler praseUrl:[NSString stringWithFormat:@"%@", self.URLString]];
//        /** @"XNjUxMTE4NDAw"就是一个唯一标示符，没有其他含义，下面遇到同理 */
//        handler.playlist.uuid = @"0640";
//        if (self.downloader != nil) {
//            [self.downloader removeObserver:self forKeyPath:@"clearCaches" context:nil];
//            [self.downloader removeObserver:self forKeyPath:@"currentProgress"];
//            self.downloader = nil;
//        }
//        /** 初始化下载对象 */
//        self.downloader = [[VideoDownloader alloc] initWithM3U8List:handler.playlist];
//        [self.downloader addObserver:self forKeyPath:@"clearCaches" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil]; // 判断是否清理缓存
//        [self.downloader addObserver:self forKeyPath:@"currentProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    }
//
//}
//
//- (void)openHttpServer
//{
//    self.httpServer = [[HTTPServer alloc] init];
//    [self.httpServer setType:@"_http._tcp."];  // 设置服务类型
//    [self.httpServer setPort:12345]; // 设置服务器端口
//    
//    // 获取本地Library/Cache路径下downloads路径
//    //    NSString *webPath = [kLibraryCache stringByAppendingPathComponent:kPathDownload];
//    
//    NSString *webPath = [kLibraryCache stringByAppendingPathComponent:kPathDownload];
//    
//    webPath = WebBasePath;
//    
//    NSLog(@"-------------\nSetting document root: %@\n", webPath);
//    // 设置服务器路径
//    [self.httpServer setDocumentRoot:webPath];
//    NSError *error;
//    if(![self.httpServer start:&error])
//    {
//        NSLog(@"-------------\nError starting HTTP Server: %@\n", error);
//    }
//}
//
//#pragma mark - 清理缓存
//- (IBAction)clearCaches:(id)sender {
//    [self.downloader cleanDownloadFiles];
//}
//
//#pragma mark - 视频下载
//- (IBAction)downloadStreamingMedia:(id)sender {
//    [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
//    self.downloadButton.enabled = NO;
//    
//    UIButton *downloadButton = sender;
//    // 获取本地Library/Cache路径
//    NSString *localDownloadsPath = [kLibraryCache stringByAppendingPathComponent:kPathDownload];
//    
//    // 获取视频本地路径
//    NSString *filePath = [localDownloadsPath stringByAppendingPathComponent:@"0640/0640.m3u8"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    // 判断视频是否缓存完成，如果完成则播放本地缓存
//    if ([fileManager fileExistsAtPath:filePath]) {
//        [downloadButton setTitle:@"已完成" forState:UIControlStateNormal];
//        downloadButton.enabled = NO;
//    }else{
//        M3U8Handler *handler = [[M3U8Handler alloc] init];
//        handler.delegate = self;
//        // 解析m3u8视频地址
//        [handler praseUrl:self.URLString];
//        // 开启网络指示器
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    }
//}
//
//
//#pragma mark - 视频解析完成
//-(void)praseM3U8Finished:(M3U8Handler*)handler
//{
//    handler.playlist.uuid = @"0640";
//    if (self.downloader != nil) {
//        [self.downloader removeObserver:self forKeyPath:@"clearCaches" context:nil];
//        [self.downloader removeObserver:self forKeyPath:@"currentProgress"];
//        self.downloader = nil;
//    }
//    self.downloader = [[VideoDownloader alloc]initWithM3U8List:handler.playlist];
//    [self.downloader addObserver:self forKeyPath:@"currentProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil]; // 设置观察者用来得到当前下载的进度
//    [self.downloader addObserver:self forKeyPath:@"clearCaches" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil]; // 判断是否清理缓存
//    self.downloader.delegate = self;
//    [self.downloader startDownloadVideo]; // 开始下载
//}
//
//#pragma mark - 视频解析失败
//-(void)praseM3U8Failed:(M3U8Handler*)handler error:(NSError *)error
//{
//    NSLog(@"视频解析失败-failed -- %@",handler);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"视频解析失败" message:error.domain delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    alertView.tag = 100;
//    [alertView show];
//}
//
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(alertView.tag == 100){
//        [self.downloadButton setTitle:@"下载视频" forState:UIControlStateNormal];
//        self.downloadButton.enabled = YES;
//    }
//}
//
//#pragma mark --------------视频下载完成----------------
//
//-(void)videoDownloaderFinished:(VideoDownloader*)request
//
//{
//    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    
//    //    self.downloadButton.enabled = YES;
//    
//    [request createLocalM3U8file];
//    
//    NSLog(@"----------视频下载完成-------------");
//    
//}
//
//
//
//#pragma mark --------------视频下载失败----------------
//
//-(void)videoDownloaderFailed:(VideoDownloader*)request
//
//{
//    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
//    self.downloadButton.enabled = YES;
//    NSLog(@"----------视频下载失败-----------");
//    
//}
//
//
//#pragma mark - 播放本地视频
//- (IBAction)playVideoFromLocal:(id)sender{
//    
//    //往后需要修改
//    
//    NSString * playurl = [NSString stringWithFormat:@"http://127.0.0.1:12345/0640/0640.m3u8"];
//    NSLog(@"本地视频地址-----%@", playurl);
//    
//    // 获取本地Library/Cache路径
//    NSString *localDownloadsPath = [kLibraryCache stringByAppendingPathComponent:kPathDownload];
//    // 获取视频本地路径
//    //    NSString *filePath = [localDownloadsPath stringByAppendingPathComponent:@"0640/0640.m3u8"];
//    NSString *filePath = [WebBasePath stringByAppendingPathComponent:@"0640/0640.m3u8"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    // 判断视频是否缓存完成，如果完成则播放本地缓存
//    if ([fileManager fileExistsAtPath:filePath]) {
//        MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString: playurl]];
//        [self presentMoviePlayerViewControllerAnimated:playerViewController];
//    }
//    else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"当前视频未缓存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//}
//
//#pragma mark - 在线流媒体播放
//- (IBAction)playLiveStreaming{
//    //调用本地播放器
//    NSURL *url = [[NSURL alloc] initWithString:self.URLString];
//    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    [self presentMoviePlayerViewControllerAnimated:player];
//
//}
//
//#pragma mark - 通过观察者监控下载进度显示/缓存清理
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"clearCaches"]) {
//        NSLog(@"%@", change);
//        self.downloadButton.enabled = YES;
//        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
//        self.downloadButton.enabled = YES;
//        self.clearButton.enabled = NO;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isDownload"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
////        self.progressView.progress = 0.0;
//        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", 0.0];
//    }else{
//        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", 100 * [[change objectForKey:@"new"] floatValue]];
////        self.progressView.progress = [[change objectForKey:@"new"] floatValue];
//        if ([[change objectForKey:@"new"] floatValue] == 1) {
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isDownload"];
//            [self.downloadButton setTitle:@"已完成" forState:UIControlStateNormal];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            self.clearButton.enabled = YES;
//            self.downloadButton.enabled = NO;
//        } else {
//            //            [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
//            //            self.downloadButton.enabled = NO;
//        }
//    }
//    
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc {
//    [self.downloader removeObserver:self forKeyPath:@"clearCaches" context:nil];
//}
//
//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
@end
