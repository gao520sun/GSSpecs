//
//  AV_LZViewController.m
//  TCP
//
//  Created by qijia on 16/6/13.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "AV_LZViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface AV_LZViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate>
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,strong)dispatch_queue_t  videoQueue;
@property (nonatomic,strong)AVCaptureConnection *videoConnection;
@property (nonatomic,strong)AVCaptureConnection *audioConnection;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,assign) BOOL b_lz;
@property (nonatomic,assign) AVCaptureMovieFileOutput *output;
@end

@implementation AV_LZViewController

-(void)viewWillDisappear:(BOOL)animated{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self avSession];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 60, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backPBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *lzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lzBtn.frame = CGRectMake(150, 400, 60, 30);
    [lzBtn setTitle:@"录制" forState:UIControlStateNormal];
    [lzBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [lzBtn addTarget:self action:@selector(lzPBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lzBtn];
    
    
    UIButton *ckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ckBtn.frame = CGRectMake(250, 400, 60, 30);
    [ckBtn setTitle:@"查看文件" forState:UIControlStateNormal];
    [ckBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ckBtn addTarget:self action:@selector(ckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ckBtn];
    
}

-(void)ckBtn:(UIButton *)sender{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSLog(@"地址>%@",[documentsDirectory stringByAppendingPathComponent:@"myVidioo.mov"]);
    
    NSURL *url = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"myVidioo.mov"]];
    
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

-(void)lzPBtn:(UIButton *)sender{
    if ([self.output isRecording]){
        [self.output stopRecording];
        [sender setTitle:@"录制" forState:UIControlStateNormal];
        self.b_lz = NO;
        return;
    }
    
    [sender setTitle:@"停止" forState:UIControlStateNormal];
    self.b_lz = YES;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"myVidioo.mov"];
     NSURL *url = [NSURL fileURLWithPath:path];
     [self.output startRecordingToOutputFileURL:url recordingDelegate:self];
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"123");
}

-(void)backPBtn{
    [self.navigationController popViewControllerAnimated:YES];
}


//
-(void)avSession{
    _session = [[AVCaptureSession alloc] init];
    // 配置采集输入源（摄像头）
    NSError *error = nil;
    // 获得一个采集设备，例如前置/后置摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 用设备初始化一个采集的输入对象
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (error) {
        NSLog(@"Error getting video input device: %@", error.description);
    }
    
    if ([_session canAddInput:videoInput]) {
        [_session addInput:videoInput]; // 添加到Session
    }
    
    //3.创建麦克风设备
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //4.初始化麦克风输入设备
    AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    if ([_session canAddInput:inputAudio]) {
        [_session addInput:inputAudio]; // 添加到Session
    }
    
        //文件输出
        AVCaptureMovieFileOutput *videoOutput = [[AVCaptureMovieFileOutput alloc] init];
        self.output = videoOutput;
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
        AVCaptureConnection *connection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:_previewLayer];
    
    // 保存Connection，用于在SampleBufferDelegate中判断数据来源（是Video/Audio？）
    _videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    [_session startRunning];
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
