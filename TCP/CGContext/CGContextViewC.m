
#import "CGContextViewC.h"


@interface CGViewTest1 : UIView
{
 
}
@end

@implementation CGViewTest1



-(void)drawRect:(CGRect)rect{
    
    
    //画一个垂直线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 90, 101);
    CGContextAddLineToPoint(ctx, 100, 90);
    CGContextAddLineToPoint(ctx, 110, 101);
    // 从箭头杆子上裁掉一个三角形，使用清除混合模式
    //    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //    CGContextFillPath(ctx);
    CGContextClosePath(ctx);
    CGContextAddRect(ctx, CGContextGetClipBoundingBox(ctx));
    //使用奇偶规则，裁剪区域为矩形减去三角形区域
    CGContextEOClip(ctx);
    
    
    CGContextMoveToPoint(ctx, 100, 100);
    CGContextAddLineToPoint(ctx, 100, 19);
    CGContextSetLineWidth(ctx, 20);
    CGContextStrokePath(ctx);

    //绘制三角形
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextMoveToPoint(ctx, 80, 25);
    CGContextAddLineToPoint(ctx, 100, 0);
    CGContextAddLineToPoint(ctx, 120, 25);
    CGContextFillPath(ctx);

    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
//    CGContextMoveToPoint(ctx, 80, 125);
//    CGContextAddLineToPoint(ctx, 100, 100);
//    CGContextAddLineToPoint(ctx, 120, 125);
    CGContextAddRect(ctx, CGRectMake(100, 150, 80, 80));
//    CGContextFillPath(ctx);//填充
//    CGContextStrokePath(ctx);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);//要是使用必须先关闭路径
    
//    UIBezierPath *p = [UIBezierPath bezierPath];
//    [p moveToPoint:CGPointMake(100, 100)];
//    [p addLineToPoint:CGPointMake(100, 19)];
//    [p setLineWidth:20];
//    [p stroke];
//    [[UIColor redColor] set];
//    [p removeAllPoints];
//    [p moveToPoint:CGPointMake(80, 25)];
//    [p addLineToPoint:CGPointMake(100, 0)];
//    [p addLineToPoint:CGPointMake(120, 25)];
//    [p fill];
//    [p removeAllPoints];
//    [p moveToPoint:CGPointMake(90, 101)];
//    [p addLineToPoint:CGPointMake(100, 90)];
//    [p addLineToPoint:CGPointMake(110, 101)];
//    [p fillWithBlendMode:kCGBlendModeClear alpha:1.0];
    
}

@end

@interface CGViewTest2 : UIView

@end

@implementation CGViewTest2

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 3);
    UIBezierPath *pa = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 100, 100, 100) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
    [pa stroke];
}

@end


@interface CGViewTest3 : UIView{
       CGColorRef _coloredPatternColor;
}

@end

@implementation CGViewTest3
void ColoredPatternCallback(void *info, CGContextRef context)
{
    // Dark Blue
    CGContextSetRGBFillColor(context, 29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, 8.0, 8.0));
    CGContextFillRect(context, CGRectMake(8.0, 8.0, 8.0, 8.0));
    
    // Light Blue
    CGContextSetRGBFillColor(context, 204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00);
    CGContextFillRect(context, CGRectMake(8.0, 0.0, 8.0, 8.0));
    CGContextFillRect(context, CGRectMake(0.0, 8.0, 8.0, 8.0));
}

- (CGColorRef)coloredPatternColor
{
    if(!_coloredPatternColor){
        CGPatternCallbacks coloredPatternCallbacks = {0,ColoredPatternCallback,NULL};
        CGPatternRef coloredPattern = CGPatternCreate(NULL, CGRectMake(0.0, 0.0, 16, 16), CGAffineTransformIdentity, 16.0, 16.0, kCGPatternTilingNoDistortion, true, &coloredPatternCallbacks);
        CGColorSpaceRef coloredPatternColorSpace = CGColorSpaceCreatePattern(NULL);
        CGFloat alpha = 1.0;
        _coloredPatternColor = CGColorCreateWithPattern(coloredPatternColorSpace, coloredPattern, &alpha);//获取颜色
        CGColorSpaceRelease(coloredPatternColorSpace);
        CGPatternRelease(coloredPattern);
    }
    return _coloredPatternColor;
    
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetFillColorWithColor(context, self.coloredPatternColor);
//    CGContextFillRect(context, CGRectMake(10.0, 80.0, 90.0, 90.0));
//    MyDrawStencilStar(NULL, context);
    MyStencilPatternPainting(context,NULL);
}

#define PSIZE 30    // size of the pattern cell

void MyDrawStencilStar (void *info, CGContextRef myContext)
{
    int k;
    double r, theta;
    
    r = 0.8 * PSIZE / 2;
    theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees
    
    CGContextTranslateCTM (myContext, PSIZE/2, PSIZE/2);
    
    CGContextMoveToPoint(myContext, 0, r);
    for (k = 1; k < 5; k++) {
        CGContextAddLineToPoint (myContext,
                                 r * sin(k * theta),
                                 r * cos(k * theta));
    }
    CGContextClosePath(myContext);
//    CGContextFillPath(myContext);
    CGContextDrawPath(myContext, kCGPathEOFill);
//    CGPatternRef pattern;
//    CGColorSpaceRef baseSpace;
//    CGColorSpaceRef patternSpace;
//    
//    baseSpace = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);// 1
//    patternSpace = CGColorSpaceCreatePattern (baseSpace);// 2
//    CGContextSetFillColorSpace (myContext, patternSpace);// 3
//    CGColorSpaceRelease(patternSpace);// 4
//    CGColorSpaceRelease(baseSpace);
}

void MyStencilPatternPainting (CGContextRef myContext,
                               const Rect *windowRect)
{
    MyDrawStencilStar(NULL,myContext);
    CGPatternRef pattern;
    CGColorSpaceRef baseSpace;
    CGColorSpaceRef patternSpace;
    static const CGFloat color[4] = { 0, 1, 0, 1 };// 1
//    static const CGFloat colorr[4] = { 0, 1, 1, 1 };// 1
    static const CGPatternCallbacks callbacks = {0, &MyDrawStencilStar, NULL};// 2
    
    //3和4一起  4参数等于NULL不添加色彩表示显示原始图案  否则后面添加图片
    baseSpace = CGColorSpaceCreateDeviceRGB ();// 3//提供色彩
    patternSpace = CGColorSpaceCreatePattern (baseSpace);// 4//创建从RGB设备颜色空间的图案色彩空间的对象
    CGContextSetFillColorSpace (myContext, patternSpace);// 5 //填充颜色
    CGColorSpaceRelease (patternSpace);
    CGColorSpaceRelease (baseSpace);
    //创建一个模式对象。注意，第二到最后一个参数，所述isColored参数是false。模板模式不提供的颜色，所以您必须传递false此参数。所有其它参数类似于传递的着色图案的例子。
    pattern = CGPatternCreate(NULL, CGRectMake(0, 0, PSIZE, PSIZE),// 6
                              CGAffineTransformIdentity, PSIZE, PSIZE,
                              kCGPatternTilingConstantSpacing,
                              false, &callbacks);
    CGContextSetFillPattern (myContext, pattern, color);// 7设置填充图案，传递先前声明的颜色数组。
//    CGContextSetStrokePattern(myContext, pattern, colorr);
    //
//    CGFloat alpha = 1.0;
//    CGColorRef colorRef =  CGColorCreateWithPattern(patternSpace, pattern, &alpha);//获取
//    CGContextSetFillColorWithColor(myContext, colorRef);
    
    CGPatternRelease (pattern);// 8
    CGContextFillRect (myContext,CGRectMake (0,0,PSIZE*20,PSIZE*20));// 9
}

@end



@interface CGViewTest4 : UIView{
    
}
@property(nonatomic, readwrite) CGFloat dashPhase;
@end

@implementation CGViewTest4

-(id)init{
    if(self == [super init]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 200, 69, 69);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"变换" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(bButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)bButton
{
    self.dashPhase +=0.5;
    [self setNeedsDisplay];
}

typedef struct {
    CGFloat pattern[5];
    size_t count;
} Pattern;

static Pattern patterns[] = {
    {{10.0, 10.0}, 2},
    {{10.0, 20.0, 10.0}, 3},
    {{10.0, 20.0, 30.0}, 3},
    {{10.0, 20.0, 10.0, 30.0}, 4},
    {{10.0, 10.0, 20.0, 20.0}, 4},
    {{10.0, 10.0, 20.0, 30.0, 50.0}, 5},
};

-(void)drawRect:(CGRect)rect{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    CGContextSetLineDash(ref, self.dashPhase, patterns[1].pattern, sizeof(CGFloat) * (patterns[1].count));
//    CGContextMoveToPoint(ref, 10.0, 70.0);
//    CGContextAddLineToPoint(ref, 310.0, 70.0);
    CGContextAddRect(ref, CGRectMake(10.0, 80.0, 100.0, 100.0));
    CGContextSetLineWidth(ref, 2.0);
    CGContextStrokePath(ref);
}

@end


@interface CGViewTest5 : UIView{
    CGImageRef _imge;
}
@end

@implementation CGViewTest5
-(id)init{
    if(self == [super init]){
        UIImageView *imagev = [[UIImageView alloc]init];
        imagev.image = [UIImage imageNamed:@"comment_head.png"];
        imagev.frame = CGRectMake(0, 80, 80, 80);
        [self addSubview:imagev];
    }
    return self;
}

-(CGImageRef )image{
    if(!_imge){
        UIImage *img = [UIImage imageNamed:@"about-logo.png"];
        NSLog(@"改变前图片的宽度为%f,图片的高度为%f",img.size.width,img.size.height);
        _imge = CGImageRetain(img.CGImage);
    }
    return _imge;
}



-(void)drawRect:(CGRect)rect{
//第一种方法
//    UIImage *mars = [UIImage imageNamed:@"about-logo.png"];
//    CGSize sz = [mars size];
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width/2.0, sz.height), NO, 0);
//    [mars drawAtPoint:CGPointMake(-sz.width/2.0, 0)];
//    
//    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
//    iv.frame = CGRectMake(0, 0, sz.width/2.0, sz.height);
//    [self addSubview:iv];
    
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 60), NO, 0);
//    UIImage *logo = [UIImage imageNamed:@"about-logo.png"];
//
    
    //第三种
    CGRect imageRect;
    imageRect.origin = CGPointMake(0.0, 0.0);
    imageRect.size = CGSizeMake(60.0, 60.0);
    CGImageRef imageRef = nil;
    imageRef = CGImageCreateWithImageInRect(self.image, imageRect);
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIGraphicsBeginImageContext(imageRect.size);
    CGContextTranslateCTM(context, 0, imageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, -45);
    CGContextDrawImage(context, imageRect, imageRef);
    
    
    
    UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
    
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    
    
    
    //第二种
//    UIImage *logo = [UIImage imageNamed:@"about-logo.png"];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect bounds = CGRectMake(0.0f, 0.0f,80, 80);
//    // Create a new path
//    CGMutablePathRef path = CGPathCreateMutable();
//
//    CGPathAddEllipseInRect(path, NULL, bounds);//这句话就是剪辑作用
//    CGContextAddPath(context, path);
//    
//    // Clip to the circle and draw the logo  必须有路径
//    CGContextClip(context);
//    [logo drawInRect:bounds];
//    CFRelease(path);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageView *imagev = [[UIImageView alloc]init];
//    imagev.image = img;
//    imagev.frame = CGRectMake(0, 180, 80, 80);
//    [self addSubview:imagev];
    
}

@end
@interface CGViewTest6 : UIView{
}
@end

@implementation CGViewTest6
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    MyDrawWithShadows(ref,rect.size.width,rect.size.height);
}

void MyDrawWithShadows (CGContextRef myContext, // 1
                        CGFloat wd, CGFloat ht)
{
    

    CGSize myshadowOffset = CGSizeMake(-15, 20);//阴影偏移量
 
    //保存状态
    CGContextSaveGState(myContext);
    //第一种 不设置阴影颜色
    CGContextSetShadow(myContext, myshadowOffset, 5);//设置阴影
    CGContextSetRGBFillColor(myContext, 0, 1, 0, 1);//填充颜色
    CGContextFillRect(myContext, CGRectMake (wd/3 + 75, ht/2 , wd/4, ht/4));//画矩形
    
    //第二种 设置阴影颜色
    CGFloat mycolorValue[] = {1,0,0,.6};//颜色
    CGColorRef myColor;//彩色基准储存
    CGColorSpaceRef mycolorSpace;//创建彩色控件储存
    mycolorSpace = CGColorSpaceCreateDeviceRGB();//是否要自已创建控件颜色
    myColor = CGColorCreate(mycolorSpace,mycolorValue);//颜色创建
    CGContextSetShadowWithColor(myContext, myshadowOffset, 5, myColor);//设置阴影偏移 5阴影边缘 设置阴影颜色
    CGContextSetRGBFillColor(myContext, 0, 0, 1, 1);//填充颜色
    CGContextFillRect (myContext, CGRectMake (wd/3-75,ht/2-100,wd/4,ht/4));//绘制矩形位置
    //释放
    CGColorRelease(myColor);
    CGColorSpaceRelease(mycolorSpace);
    CGContextRestoreGState(myContext);
}

@end


@interface CGViewTest7 : UIView{
}
@end

@implementation CGViewTest7
-(id)init{
    if(self == [super init]){
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    myContextRef(ref);
}

void myContextRef (CGContextRef myContext){
//    创建CGGradient对象，供给色空间，两个或更多个颜色分量的阵列，两个或多个位置的阵列，和物品的每两个阵列的数目。
//    通过调用涂料梯度CGContextDrawLinearGradient或CGContextDrawRadialGradient与供应背景下，CGGradient对象，绘图选项和说明，并（轴向渐变或圆的圆心和半径为径向渐变点）结束的几何形状。
//    释放CGGradient对象时，你不再需要它。
    CGGradientRef myGradient;
    CGColorSpaceRef myColorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0,1.0};
    CGFloat components[8] = {1.0,0.5,0.4,
                            0.8,0.8,0.3,1.0};
    myColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, num_locations);

    //绘制使用CGGradient对象的轴向梯度
    CGPoint myStartPoint, myEndPoint;
    myStartPoint.x = 0.0;
    myStartPoint.y = 0.0;
    myEndPoint.x = 1.0;
    myEndPoint.y = 1.0;
    CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, 0);
    
    //绘画使用CGGradient对象的径向渐变
//    CGPoint myStartPoint, myEndPoint;
    CGFloat myStartRadius, myEndRadius;
    myStartPoint.x = 0.15;
    myStartPoint.y = 0.15;
    myEndPoint.x = 0.5;
    myEndPoint.y = 0.5;
    myStartRadius = 0.1;
    myEndRadius = 0.25;
    CGContextDrawRadialGradient (myContext, myGradient, myStartPoint,
                                 myStartRadius, myEndPoint, myEndRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(myGradient);
}

static void myCalculateShadingValues (void *info,
                                      const CGFloat *in,
                                      CGFloat *out)
{
    CGFloat v;
    size_t k, components;
    static const CGFloat c[] = {1, 0, .5, 0 };
    
    components = (size_t)info;
    
    v = *in;
    for (k = 0; k < components -1; k++)
        *out++ = c[k] * v;
    *out++ = 1;
}

static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace)// 1
{
    size_t numComponents;
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0,// 2
        &myCalculateShadingValues,
        NULL };
    
    numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace);// 3
    return CGFunctionCreate ((void *) numComponents, // 4
                             1, // 5
                             input_value_range, // 6
                             numComponents, // 7
                             output_value_ranges, // 8
                             &callbacks);// 9
}

@end

#define CELL_IFIER @"cell"
@interface CGContextViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation CGContextViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CGContext";
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArr = [[NSArray alloc]initWithObjects:@"绘制箭头",@"绘制带有圆角的矩形",@"模式Pattern",@"Dash",@"裁剪", @"阴影",@"渐变",nil];
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
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    NSString *cS  = [NSString stringWithFormat:@"CGViewTest%ld",(long)indexPath.row+1];
    UIView *view = [[NSClassFromString(cS) alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    [vc.view addSubview:view];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
