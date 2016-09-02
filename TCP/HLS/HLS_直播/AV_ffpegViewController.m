//
//  AV_ffpegViewController.m
//  TCP
//
//  Created by qijia on 16/6/13.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "AV_ffpegViewController.h"
//#include <libavformat/avformat.h>
//#include <libavutil/mathematics.h>
//#include <libavutil/time.h>
#import "avformat.h"
#import "mathematics.h"
#import "time.h"
#import <AVFoundation/AVFoundation.h>
#import "mathematics.h"
//#import "ffmpeg.h"
@interface AV_ffpegViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,strong)dispatch_queue_t  videoQueue;
@property (nonatomic,strong)AVCaptureConnection *videoConnection;
@property (nonatomic,strong)AVCaptureConnection *audioConnection;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,assign) BOOL b_lz;
@end

@implementation AV_ffpegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"直播";
    [self.navigationController setNavigationBarHidden:YES];
    [self avSession];
    [self test];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 60, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backPBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UIButton *tlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tlBtn.frame = CGRectMake(100, 330, 60, 30);
    [tlBtn setTitle:@"推流" forState:UIControlStateNormal];
    [tlBtn addTarget:self action:@selector(tlzpBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tlBtn];

    
}

-(void)tlzpBtn{
    [self test];
}

-(void)backPBtn{
    [self.navigationController popViewControllerAnimated:YES];
}



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
    
    // 配置采集输出，即我们取得视频图像的接口
    _videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoOutput setSampleBufferDelegate:self queue:_videoQueue];
    
    // 配置输出视频图像格式
    NSDictionary *captureSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    
    _videoOutput.videoSettings = captureSettings;
    _videoOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([_session canAddOutput:_videoOutput]) {
        [_session addOutput:_videoOutput];  // 添加到Session
    }
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:_previewLayer];
    
    // 保存Connection，用于在SampleBufferDelegate中判断数据来源（是Video/Audio？）
    _videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    [_session startRunning];
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
{
    // 这里的sampleBuffer就是采集到的数据了，但它是Video还是Audio的数据，得根据connection来判断
    if (connection == _videoConnection) {  // Video
        /*
         // 取得当前视频尺寸信息
         CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
         int width = CVPixelBufferGetWidth(pixelBuffer);
         int height = CVPixelBufferGetHeight(pixelBuffer);
         NSLog(@"video width: %d  height: %d", width, height);
         */
//        NSData *data = imageToBuffer(sampleBuffer);
        
//        NSLog(@"在这里获得video sampleBuffer，做进一步处理（编码H.264");
    } else if (connection == _audioConnection) {  // Audio
        NSLog(@"这里获得audio sampleBuffer，做进一步处理（编码AAC）");
    }
}

NSData* imageToBuffer( CMSampleBufferRef source) {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(source);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);
    
    NSData *data = [NSData dataWithBytes:src_buff length:bytesPerRow * height];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return data;
}

- (BOOL)hasPermissionOfCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus != AVAuthorizationStatusAuthorized){
        
        NSLog(@"相机权限受限");
        return NO;
    }
    return YES;
}
//
//int read_buffer(void*opaque, uint8_t *buf,intbuf_size){
//    
//    //休眠,否则会一次性全部发送完
//    
//    if(pkt.stream_index==videoindex){
//        
//        AVRational time_base=ifmt_ctx->streams[videoindex]->time_base;
//        
//        AVRational time_base_q={1,AV_TIME_BASE};
//        
//        int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
//        
//        int64_t now_time = av_gettime() - start_time;
//        
//        if(pts_time > now_time)
//            
//        av_usleep(pts_time - now_time);
//        
//    }



-(void)test{
//    avcodec_register_all();
//    avformat_network_init();
//    av_register_all();
//    
//    AVFormatContext *pFormatCtx = avformat_alloc_context();
//    AVInputFormat *iformat = av_find_input_format("dshow");
//    printf("========VFW Device Info======\n");
//   int avf =  avformat_open_input(&pFormatCtx,"list",iformat,NULL);
//    printf("=============================\n");
//    if(avf!=0){
//        printf("Couldn't open input stream.\n");
//    }
//    AVFormatContext *pFmtCtx = avformat_alloc_context();
//    AVDeviceInfoList *device_info = NULL;
//    AVDictionary* options = NULL;
//    av_dict_set(&options, "list_devices", "true", 0);
//    AVInputFormat *iformat = av_find_input_format("dshow");
//    printf("Device Info=============\n");
//    avformat_open_input(&pFmtCtx, "video=dummy", iformat, &options);
//    printf("========================\n");
    
//    NSString*command =@"ffmpeg -re -i temp.h264 -vcodec copy -f flv rtmp://www.velab.com.cn/live/livestream";
    
    
//    NSArray * argv_array=[command strcomponentsSeparatedByString:(@" ")];
    
//    NSArray * argv_array= [command componentsSeparatedByString:@" "];
//    int argc=(int)argv_array.count;
//    char** argv=(char**)malloc(sizeof(char*)*argc);
//    for(int i=0;i<argc;i++){
//        
//        argv[i]=(char*)malloc(sizeof(char)*1024);
//        
//        strcpy(argv[i],[[argv_array objectAtIndex:i]UTF8String]);
//        
//    }
    
//    ffmpegmain(argc,argv);
    
//    unsigned char*aviobuffer=(unsigned char*)av_malloc(32768);
//    
//    AVIOContext*avio=avio_alloc_context(aviobuffer,32768,0,NULL,setbuffer,NULL,NULL);
//    
//    pFormatCtx->pb=avio;
//    
//    if(avformat_open_input(&pFormatCtx,NULL,NULL,NULL)!=0){
//        
//        printf("Couldn't open inputstream.（无法打开输入流）\n");
//        
////        return -1;
//        
//    }
    
    
    AVOutputFormat *ofmt = NULL;
    //输入对应一个AVFormatContext，输出对应一个AVFormatContext
    //（Input AVFormatContext and Output AVFormatContext）
    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx = NULL;
    AVPacket pkt;
    const char *in_filename, *out_filename;
    int ret, i;
    int videoindex=-1;
    int frame_index=0;
    int64_t start_time=0;
    //in_filename  = "cuc_ieschool.mov";
    //in_filename  = "cuc_ieschool.mkv";
    //in_filename  = "cuc_ieschool.ts";
    //in_filename  = "cuc_ieschool.mp4";
    //in_filename  = "cuc_ieschool.h264";
    in_filename  = "cuc_ieschool.flv";//输入URL（Input file URL）
    //in_filename  = "shanghai03_p.h264";
    
    out_filename = "rtmp://localhost/publishlive/livestream";//输出 URL（Output URL）[RTMP]
    //out_filename = "rtp://233.233.233.233:6666";//输出 URL（Output URL）[UDP]
    
    av_register_all();
    //Network
    avformat_network_init();
    //输入（Input）
    if ((ret = avformat_open_input(&ifmt_ctx, in_filename, 0, 0)) < 0) {
        printf( "Could not open input file.");
        goto end;
    }
    if ((ret = avformat_find_stream_info(ifmt_ctx, 0)) < 0) {
        printf( "Failed to retrieve input stream information");
        goto end;
    }
    
    for(i=0; i<ifmt_ctx->nb_streams; i++)
        if(ifmt_ctx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
            videoindex=i;
            break;
        }
    
    av_dump_format(ifmt_ctx, 0, in_filename, 0);
    
    //输出（Output）
    
    avformat_alloc_output_context2(&ofmt_ctx, NULL, "flv", out_filename); //RTMP
    //avformat_alloc_output_context2(&ofmt_ctx, NULL, "mpegts", out_filename);//UDP
    
    if (!ofmt_ctx) {
        printf( "Could not create output context\n");
        ret = AVERROR_UNKNOWN;
        goto end;
    }
    ofmt = ofmt_ctx->oformat;
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        //根据输入流创建输出流（Create output AVStream according to input AVStream）
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec);
        if (!out_stream) {
            printf( "Failed allocating output stream\n");
            ret = AVERROR_UNKNOWN;
            goto end;
        }
        //复制AVCodecContext的设置（Copy the settings of AVCodecContext）
        ret = avcodec_copy_context(out_stream->codec, in_stream->codec);
        if (ret < 0) {
            printf( "Failed to copy context from input to output stream codec context\n");
            goto end;
        }
        out_stream->codec->codec_tag = 0;
        if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
            out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
    }
    //Dump Format------------------
    av_dump_format(ofmt_ctx, 0, out_filename, 1);
    //打开输出URL（Open output URL）
    if (!(ofmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            printf( "Could not open output URL '%s'", out_filename);
            goto end;
        }
    }
    //写文件头（Write file header）
    ret = avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        printf( "Error occurred when opening output URL\n");
        goto end;
    }
    
    start_time=av_gettime();
    while (1) {
        AVStream *in_stream, *out_stream;
        //获取一个AVPacket（Get an AVPacket）
        ret = av_read_frame(ifmt_ctx, &pkt);
        if (ret < 0)
            break;
        //FIX：No PTS (Example: Raw H.264)
        //Simple Write PTS
        if(pkt.pts==AV_NOPTS_VALUE){
            //Write PTS
            AVRational time_base1=ifmt_ctx->streams[videoindex]->time_base;
            //Duration between 2 frames (us)
            int64_t calc_duration=(double)AV_TIME_BASE/av_q2d(ifmt_ctx->streams[videoindex]->r_frame_rate);
            //Parameters
            pkt.pts=(double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
            pkt.dts=pkt.pts;
            pkt.duration=(double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
        }
        //Important:Delay
        if(pkt.stream_index==videoindex){
            AVRational time_base=ifmt_ctx->streams[videoindex]->time_base;
            AVRational time_base_q={1,AV_TIME_BASE};
            int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
            int64_t now_time = av_gettime() - start_time;
            if (pts_time > now_time)
                av_usleep(pts_time - now_time);
            
        }
        
        in_stream  = ifmt_ctx->streams[pkt.stream_index];
        out_stream = ofmt_ctx->streams[pkt.stream_index];
        /* copy packet */
        //转换PTS/DTS（Convert PTS/DTS）
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
        pkt.pos = -1;
        //Print to Screen
        if(pkt.stream_index==videoindex){
            printf("Send %8d video frames to output URL\n",frame_index);
            frame_index++;
        }
        //ret = av_write_frame(ofmt_ctx, &pkt);
        ret = av_interleaved_write_frame(ofmt_ctx, &pkt);
        
        if (ret < 0) {
            printf( "Error muxing packet\n");
            break;
        }
        
        av_free_packet(&pkt);
        
    }
    //写文件尾（Write file trailer）
    av_write_trailer(ofmt_ctx);
end:
    avformat_close_input(&ifmt_ctx);
    /* close output */
    if (ofmt_ctx && !(ofmt->flags & AVFMT_NOFILE))
        avio_close(ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);
    if (ret < 0 && ret != AVERROR_EOF) {
        printf( "Error occurred.\n");
        return ;
    }  
    return ;

    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory=[paths objectAtIndex:0];
//    NSLog(@"地址>%@",[documentsDirectory stringByAppendingPathComponent:@"myVidio.mov"]);
//    
////    NSURL *url = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"myVidio.mov"]];
//    
//    char input_str_full[500]={0};
//    char output_str_full[500]={0};
//    
////    NSString *input_str1= [NSString stringWithFormat:@"resource.bundle/%@",@"war3end.mp4"];
//    NSString *input_str= [documentsDirectory stringByAppendingPathComponent:@"myVidioo.mov"];
////    NSString *input_nsstr=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:input_str];
////     NSURL *url = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"myVidioo.mov"]];
//    NSString *output = @"rtmp://www.velab.com.cn/live/livestream";
//    sprintf(input_str_full,"%s",[input_str UTF8String]);
//    sprintf(output_str_full,"%s",[output UTF8String]);
//    
//    printf("Input Path:%s\n",input_str_full);
//    printf("Output Path:%s\n",output_str_full);
////
//    AVOutputFormat *ofmt = NULL;
//    //Input AVFormatContext and Output AVFormatContext
//    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx = NULL;
//    AVPacket pkt;
//    char in_filename[500]={0};
//    char out_filename[500]={0};
//    int ret, i;
//    int videoindex=-1;
//    int frame_index=0;
//    int64_t start_time=0;
//    //in_filename  = "cuc_ieschool.mov";
//    //in_filename  = "cuc_ieschool.h264";
//    //in_filename  = "cuc_ieschool.flv";//Input file URL
//    //out_filename = "rtmp://localhost/publishlive/livestream";//Output URL[RTMP]
//    //out_filename = "rtp://233.233.233.233:6666";//Output URL[UDP]
//    
//    strcpy(in_filename,input_str_full);
//    strcpy(out_filename,output_str_full);
//    
//    av_register_all();
//    //Network
//    avformat_network_init();
//    //Input
//    if ((ret = avformat_open_input(&ifmt_ctx, in_filename, 0, 0)) < 0) {
//        printf( "Could not open input file.");
//        goto end;
//    }
//    if ((ret = avformat_find_stream_info(ifmt_ctx, 0)) < 0) {
//        printf( "Failed to retrieve input stream information");
//        goto end;
//    }
//    
//    for(i=0; i<ifmt_ctx->nb_streams; i++)
//        if(ifmt_ctx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
//            videoindex=i;
//            break;
//        }
//    
//    av_dump_format(ifmt_ctx, 0, in_filename, 0);
//    
//    //Output
//    
//    avformat_alloc_output_context2(&ofmt_ctx, NULL, "flv", out_filename); //RTMP
//    //avformat_alloc_output_context2(&ofmt_ctx, NULL, "mpegts", out_filename);//UDP
//    
//    if (!ofmt_ctx) {
//        printf( "Could not create output context\n");
//        ret = AVERROR_UNKNOWN;
//        goto end;
//    }
//    ofmt = ofmt_ctx->oformat;
//    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
//        
//        AVStream *in_stream = ifmt_ctx->streams[i];
//        AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec);
//        if (!out_stream) {
//            printf( "Failed allocating output stream\n");
//            ret = AVERROR_UNKNOWN;
//            goto end;
//        }
//        
//        ret = avcodec_copy_context(out_stream->codec, in_stream->codec);
//        if (ret < 0) {
//            printf( "Failed to copy context from input to output stream codec context\n");
//            goto end;
//        }
//        out_stream->codec->codec_tag = 0;
//        if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
//            out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
//    }
//    //Dump Format------------------
//    av_dump_format(ofmt_ctx, 0, out_filename, 1);
//    //Open output URL
//    if (!(ofmt->flags & AVFMT_NOFILE)) {
//        ret = avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
//        if (ret < 0) {
//            printf( "Could not open output URL '%s'", out_filename);
//            goto end;
//        }
//    }
//    
//    ret = avformat_write_header(ofmt_ctx, NULL);
//    if (ret < 0) {
//        printf( "Error occurred when opening output URL\n");
//        goto end;
//    }
//    
//    start_time=av_gettime();
//    while (1) {
//        AVStream *in_stream, *out_stream;
//        //Get an AVPacket
//        ret = av_read_frame(ifmt_ctx, &pkt);
//        if (ret < 0)
//            break;
//        //FIX：No PTS (Example: Raw H.264)
//        //Simple Write PTS
//        if(pkt.pts==AV_NOPTS_VALUE){
//            //Write PTS
//            AVRational time_base1=ifmt_ctx->streams[videoindex]->time_base;
//            //Duration between 2 frames (us)
//            int64_t calc_duration=(double)AV_TIME_BASE/av_q2d(ifmt_ctx->streams[videoindex]->r_frame_rate);
//            //Parameters
//            pkt.pts=(double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
//            pkt.dts=pkt.pts;
//            pkt.duration=(double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
//        }
//        //Important:Delay
//        if(pkt.stream_index==videoindex){
//            AVRational time_base=ifmt_ctx->streams[videoindex]->time_base;
//            AVRational time_base_q={1,AV_TIME_BASE};
//            int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
//            int64_t now_time = av_gettime() - start_time;
//            if (pts_time > now_time)
//                av_usleep(pts_time - now_time);
//            
//        }
//        
//        in_stream  = ifmt_ctx->streams[pkt.stream_index];
//        out_stream = ofmt_ctx->streams[pkt.stream_index];
//        /* copy packet */
//        //Convert PTS/DTS
//        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
//        pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
//        pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
//        pkt.pos = -1;
//        //Print to Screen
//        if(pkt.stream_index==videoindex){
//            printf("Send %8d video frames to output URL\n",frame_index);
//            frame_index++;
//        }
//        //ret = av_write_frame(ofmt_ctx, &pkt);
//        ret = av_interleaved_write_frame(ofmt_ctx, &pkt);
//        
//        if (ret < 0) {
//            printf( "Error muxing packet\n");
//            break;
//        }
//        
//        av_free_packet(&pkt);
//        
//    }
//    //写文件尾（Write file trailer）
//    av_write_trailer(ofmt_ctx);
//end:
//    avformat_close_input(&ifmt_ctx);
//    /* close output */
//    if (ofmt_ctx && !(ofmt->flags & AVFMT_NOFILE))
//        avio_close(ofmt_ctx->pb);
//    avformat_free_context(ofmt_ctx);
//    if (ret < 0 && ret != AVERROR_EOF) {
//        printf( "Error occurred.\n");
//        return;
//    }
//    return;

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
