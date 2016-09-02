//
//  ImageViewController.m
//  TCP
//
//  Created by qijia on 16/8/1.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "ImageViewController.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import "UIButton+style.h"
#define CELL_IFIERR @"celll"

@interface CGViewTestt1 : UIView{
}
@end

@implementation CGViewTestt1
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self baseImageFilter];
}
//listing 1 应用过滤器在iOS图像的基础知识
-(void)baseImageFilter{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *image = [[CIImage alloc]initWithCGImage:[UIImage imageNamed:@"comment_head.png"].CGImage];
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@0.8 forKey:kCIInputIntensityKey];
    //    [filter setValue:[UIColor redColor] forKey:kCIInputColorKey];
    
    CIImage *result = [filter valueForKey:kCIInputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    imgView.image=[UIImage imageWithCGImage:cgImage];
    [self addSubview:imgView];
    CGImageRelease(cgImage);
    
    //遍历每种滤镜下的滤镜名
    NSLog(@"%@",[CIFilter filterNamesInCategories:@[@"CICategoryBlur"]]);
    NSLog(@"%@",[CIFilter filterNamesInCategories:@[@"CICategoryVideo"]]);
    NSLog(@"%@",[CIFilter filterNamesInCategories:@[@"CICategoryStillImage"]]);
    NSLog(@"%@",[CIFilter filterNamesInCategories:@[@"CICategoryBuiltIn"]]);
    //    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}
@end


@interface CGViewTestt2 : UIView{
}
@end
@implementation CGViewTestt2
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self hueAdjust];
}

//listing 3
-(void)hueAdjust{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter * hueAdjust = nil;
    CIImage *myCIImage = [[CIImage alloc]initWithCGImage:[UIImage imageNamed:@"about-logo.png"].CGImage];
    //第一种写法
    //    hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    //    [hueAdjust setDefaults];
    //    [hueAdjust setValue: myCIImage forKey: kCIInputImageKey];
    //    [hueAdjust setValue: @2.094f forKey: kCIInputAngleKey];
    
    //紧凑型 第二种写法
    hueAdjust = [CIFilter filterWithName:@"CIHueAdjust" withInputParameters:@{
                                                                              kCIInputImageKey: myCIImage,
                                                                              kCIInputAngleKey: @2.094f,
                                                                              }];
    CIImage *result = [hueAdjust valueForKey: kCIOutputImageKey];//输出图像
    
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    imgView.image=[UIImage imageWithCGImage:cgImage];
    [self addSubview:imgView];
    CGImageRelease(cgImage);
}

@end

@interface CGViewTestt3 : UIView{
}
@end
@implementation CGViewTestt3
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    
    [self chaungFilters];
}

//连接过滤器 多个组合
-(void)chaungFilters{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //第一种组合
    CIFilter * hueAdjust = nil;
    CIImage *myCIImage = [[CIImage alloc]initWithCGImage:[UIImage imageNamed:@"about-logo.png"].CGImage];
    hueAdjust = [CIFilter filterWithName:@"CIHueAdjust" withInputParameters:@{
                                                                              kCIInputImageKey: myCIImage,
                                                                              kCIInputAngleKey: @2.094f,
                                                                              }];
    CIImage *result = [hueAdjust valueForKey: kCIOutputImageKey];//输出图像
    
    //第二种组合
    CIFilter *gloom = [CIFilter filterWithName:@"CIGloom"];
    [gloom setDefaults];
    [gloom setValue:result forKey:kCIInputImageKey];
    [gloom setValue:@10.0 forKey:kCIInputRadiusKey];//半径
    [gloom setValue:@0.75 forKey:kCIInputIntensityKey];//输入强度 亮度
    
    result = [gloom valueForKey: kCIOutputImageKey];//输出图像 但不绘制图像
    
    CGRect extent = [result extent];
    //获取图像
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    //显示
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    imgView.image=[UIImage imageWithCGImage:cgImage];
    [self addSubview:imgView];
    CGImageRelease(cgImage);
}
@end

@interface CGViewTestt4 : UIView{
}
@end
@implementation CGViewTestt4
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    
    [self bumpDistortion];
}

//凹凸变形过滤器 凸块失真三个参数：指定的效果的中心，该效果的半径的位置，以及输入的比例。
-(void)bumpDistortion{
    CIContext *context = [CIContext contextWithOptions:nil];
    //第一种组合
    CIFilter * hueAdjust = nil;
    CIImage *myCIImage = [[CIImage alloc]initWithCGImage:[UIImage imageNamed:@"about-logo.png"].CGImage];
    hueAdjust = [CIFilter filterWithName:@"CIHueAdjust" withInputParameters:@{
                                                                              kCIInputImageKey: myCIImage,
                                                                              kCIInputAngleKey: @2.094f,
                                                                              }];
    CIImage *result = [hueAdjust valueForKey: kCIOutputImageKey];//输出图像
    
    CIFilter *bumpDis = [CIFilter filterWithName:@"CIBumpDistortion"];
    [bumpDis setDefaults];
    [bumpDis setValue:result forKey:kCIInputImageKey];
    //凹凸位置
    [bumpDis setValue:[CIVector vectorWithX:50 Y:25] forKey:kCIInputCenterKey];
    //半径
    [bumpDis setValue:@100 forKey:kCIInputRadiusKey];
    //设置输入规模为3的输入刻度指定方向及效果的量。默认值是-0.5。范围为-10.0至10.0。0值指定没有影响。负值创建一个向外凸起; 正值创建一个向内凸起。
    [bumpDis setValue:@3.0 forKey:kCIInputScaleKey];
    result =[bumpDis valueForKey: kCIOutputImageKey];//输出图像
    
    CGRect extent = [result extent];
    //获取图像
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    //显示
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 100, 100)];
    imgView.image=[UIImage imageWithCGImage:cgImage];
    [self addSubview:imgView];
    CGImageRelease(cgImage);
}

@end


@interface CGViewTestt5 : UIView{
}
@end
@implementation CGViewTestt5
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    NSLog(@"没有开发完成");
}
//设置过渡效果
//获取的图像和设置计时器
static CIImage *sourceImage;
static CIImage *targetImage;
static NSDate *base;
static CIFilter *transition;
CGFloat thumbnailWidth;
CGFloat thumbnailHeight;
-(void)awakeFromNib{
    NSTimer *timer;
    
    thumbnailWidth  = 340.0;
    thumbnailHeight = 240.0;
    CIImage *myCIImage = [[CIImage alloc]initWithCGImage:[UIImage imageNamed:@"about-logo.png"].CGImage];
    [self setSourceImage: myCIImage];
    CIImage *myTgCIImage = [[CIImage alloc]initWithCGImage:[UIImage imageNamed:@"comment_head.png"].CGImage];
    [self setTargetImage: myTgCIImage];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/30.0
                                             target: self
                                           selector: @selector(timerFired:)
                                           userInfo: nil
                                            repeats: YES];
    //    base = [NSDate timeIntervalSinceReferenceDate];
    [[NSRunLoop currentRunLoop] addTimer: timer
                                 forMode: NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer: timer
                                 forMode: UITrackingRunLoopMode];
}


//- (void)drawRect: (NSRect)rectangle
//{
//    CGRect  cg = CGRectMake(NSMinX(rectangle), NSMinY(rectangle),
//                            NSWidth(rectangle), NSHeight(rectangle));
//
//    CGFloat t = 0.4 * ([NSDate timeIntervalSinceReferenceDate] - base);
//    if (context == nil) {
//        context = [CIContext contextWithCGContext:
//                   [[NSGraphicsContext currentContext] graphicsPort]
//                                          options: nil];
//    }
//    if (transition == nil) {
//        [self setupTransition];
//    }
//    [context drawImage: [self imageForTransition: t + 0.1]
//                inRect: cg
//              fromRect: cg];
//}

- (void)setupTransition
{
    CGFloat w = thumbnailWidth;
    CGFloat h = thumbnailHeight;
    
    CIVector *extent = [CIVector vectorWithX: 0  Y: 0  Z: w  W: h];
    
    transition  = [CIFilter filterWithName: @"CICopyMachineTransition"];
    // Set defaults on OS X; not necessary on iOS.
    [transition setDefaults];
    [transition setValue: extent forKey: kCIInputExtentKey];
}

-(void)timerFired:(id)sender{
    //    [self.view setNeedsDisplay: YES];
    [self setNeedsDisplay];
}

- (void)setSourceImage: (CIImage *)source
{
    sourceImage = source;
}

- (void)setTargetImage: (CIImage *)target
{
    targetImage = target;
}
@end



@interface CGViewTestt6 : UIView{
    UIImage *originalImage;
    UIImageView *imageview;
    
     UIImageView *qr_imageview;
     UIImage *qr_originalImage;
    
    UIImageView *text_imageview;
    UIImage *text_originalImage;
}
@end
@implementation CGViewTestt6
-(id)init{
    if(self == [super init]){
        
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    originalImage = [UIImage imageNamed:@"1.jpg"];
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    imageview.image = originalImage;
    [self addSubview:imageview];
    
    qr_originalImage = [UIImage imageNamed:@"123.png"];
    qr_imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, qr_originalImage.size.width, 100)];
    qr_imageview.image = qr_originalImage;
    [self addSubview:qr_imageview];
    
    text_originalImage = [UIImage imageNamed:@"321.jpg"];
    text_imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, text_originalImage.size.width, 100)];
    text_imageview.image = text_originalImage;
    [self addSubview:text_imageview];
    
    
    [self creatingFace];
    [self qrCodeFeature];
    [self rectangle];
    [self textFeature];
}

//
-(void)textFeature{
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };// 2
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeText
                                              context:context
                                              options:opts];
    CIImage *myImage = [[CIImage alloc]initWithCGImage:text_originalImage.CGImage];
    NSArray *features = [detector featuresInImage:myImage];
    UIView *resultView = [[UIView alloc] initWithFrame:text_imageview.frame];
    [self addSubview:resultView];
    for(CITextFeature *f in features){
        UIView* faceView = [[UIView alloc] initWithFrame:f.bounds];
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [UIColor orangeColor].CGColor;
        [resultView addSubview:faceView];
        NSLog(@"TEXT..X....%f  y....%f",f.bounds.origin.x,f.bounds.origin.y);
        NSLog(@"CITextFeature.....%@",f.subFeatures);
    }
}

//矩形识别
-(void)rectangle{
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };// 2
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeRectangle
                                              context:context
                                              options:opts];
    CIImage *myImage = [[CIImage alloc]initWithCGImage:qr_originalImage.CGImage];
    NSArray *features = [detector featuresInImage:myImage];
    for(CIRectangleFeature *f in features){
        NSLog(@"x...%f  y...%f",f.bounds.origin.x,f.bounds.origin.y);
    }
}

-(void)qrCodeFeature{
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };// 2
    //二维码识别
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:context
                                              options:opts];
    CIImage *myImage = [[CIImage alloc]initWithCGImage:qr_originalImage.CGImage];
    NSArray *features = [detector featuresInImage:myImage];
    NSString *content;
    for(CIQRCodeFeature *f in features){
        
        content = f.messageString;
        NSLog(@"conten....%@",content);
    }
}

-(void)creatingFace{
//
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };// 2
    //人脸识别
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];                    // 3
    //二维码识别
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
//                                              context:context
//                                              options:opts];
    CIImage *myImage = [[CIImage alloc]initWithCGImage:originalImage.CGImage];
//    opts = @{ CIDetectorImageOrientation :
//                  [[myImage properties] valueForKey:(NSString *)kCGImagePropertyOrientation] }; // 4
//    NSArray *features = [detector featuresInImage:myImage options:opts];        // 5
    UIView *resultView = [[UIView alloc] initWithFrame:imageview.frame];
    [self addSubview:resultView];
    NSArray *features = [detector featuresInImage:myImage];
    for(CIFaceFeature *f in features){
        
        
        UIView* faceView = [[UIView alloc] initWithFrame:f.bounds];
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [UIColor orangeColor].CGColor;
        [resultView addSubview:faceView];
//        NSLog(@"x = %f  y = %f ", f.bounds.origin.x,f.bounds.origin.y);
//        if(f.hasLeftEyePosition){
//            NSLog(@"Left eye %g %g", f.leftEyePosition.x, f.leftEyePosition.y);
//        }
//        
//        if (f.hasRightEyePosition) {
//            NSLog(@"Right eye %g %g", f.rightEyePosition.x, f.rightEyePosition.y);
//        }
//        if (f.hasMouthPosition) {
//            NSLog(@"Mouth %g %g", f.mouthPosition.x, f.mouthPosition.y);
//        }
        
    }
}

@end



@interface ImageViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"core iamge";
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    [btn setImage:[UIImage imageNamed:@"header_cry_icon"] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(0, 100, 400, 200);
//    [btn setTitle:@"小白" forState:UIControlStateNormal];
//    [btn SetbuttonType:buttonTypeBottom];
////    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:btn];
    
    
    self.dataArr = [[NSArray alloc]initWithObjects:@"应用过滤器",@"过滤器显示",@"连接过滤器,多个组合",@"凹凸变形过滤器,组合",@"设置过渡效果",@"图像检查人脸",nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IFIERR];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IFIERR];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    NSString *cS  = [NSString stringWithFormat:@"CGViewTestt%ld",(long)indexPath.row+1];
    UIView *view = [[NSClassFromString(cS) alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    [vc.view addSubview:view];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
