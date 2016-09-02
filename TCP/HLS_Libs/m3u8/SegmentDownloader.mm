//
//  SegmentDownloader.m
//  XB
//
//  Created by luoxubin on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SegmentDownloader.h"

@implementation SegmentDownloader
@synthesize fileName,tmpFileName,delegate,downloadUrl,filePath,status,progress;


-(void)start
{
    
//    NSLog(@"download segment start, fileName = %@,url = %@",self.fileName,self.downloadUrl);
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[self.downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [request setTemporaryFileDownloadPath: self.tmpFileName];
//    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//    NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.filePath];
//    NSString *saveTo = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.filePath];
//    [request setDownloadDestinationPath:[saveTo stringByAppendingPathComponent:self.fileName]];
//    [request setDelegate:self];
//    [request setDownloadProgressDelegate:self];
//    request.allowResumeForFileDownloads = YES;
//    [request setNumberOfTimesToRetryOnTimeout:2];
//    [request startAsynchronous];
    
    
    //    NSDictionary *paramaterDic= @{@"jsonString":[@{@"userid":@"2332"} JSONString]?:@""};
    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.filePath];
    [self downloadFileWithOption:@{@"userid":@"123123"}
                   withInferface:[self.downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       savedPath:[saveTo stringByAppendingPathComponent:self.fileName]
                 downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if(delegate && [delegate respondsToSelector:@selector(segmentDownloadFinished:)])
                     {
                         [delegate segmentDownloadFinished:self];
                     }
                 } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                     if (error.code != 3)
                     {
                         [self stop];
                         NSLog(@"Download failed.");
                         if(delegate && [delegate respondsToSelector:@selector(segmentDownloadFailed:)])
                         {
                             [delegate segmentDownloadFailed:self];
                         }
                     }
                 } progress:^(float progress) {
                     
                 }];
    
    status = ERUNNING;
}

/**
 *  @author Jakey
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
    //
    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //
    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPMethod:@"POST"];
    //
    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
        NSLog(@"下载失败");
        
        
    }];
    
    [operation start];
    
}

-(void)stop
{
//    NSLog(@"download stoped");
    if(request && status == ERUNNING)
    {
//        request.delegate = nil;
        [request cancel];
    }
    status = ESTOPPED;
}

-(void)clean
{
//    NSLog(@"download clean");
    if(request && status == ERUNNING)
    {
//        request.delegate = nil;
//        [request cancelAuthentication];
//        [request removeTemporaryDownloadFile];
        NSError *Error = nil;
//        if (![ASIHTTPRequest removeFileAtPath:[request downloadDestinationPath] error:&Error]) {
////            NSLog(@"clean file err:%@",Error);
//        }
    }
    status = ESTOPPED;
    progress = 0.0;
}

-(id)initWithUrl:(NSString *)url andFilePath:(NSString *)path andFileName:(NSString *)_fileName{
    self = [super init];
    if(self != nil)
    {
        self.downloadUrl = url;
        self.fileName = _fileName;
        self.filePath = path;
        
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.filePath];
        NSString *downloadingFileName = [[[NSString alloc] initWithString:[saveTo stringByAppendingPathComponent:[fileName stringByAppendingString:kTextDownloadingFileSuffix]]] autorelease];
        self.tmpFileName = downloadingFileName;
        BOOL isDir = NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        if(!([fm fileExistsAtPath:saveTo isDirectory:&isDir] && isDir))
        {
            [fm createDirectoryAtPath:saveTo withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.progress = 0.0;
        status = ESTOPPED;
        
    }
    return  self;
}

-(void)dealloc
{
    [self stop];
    [fileName release];
    [tmpFileName release];
    [delegate release];
    [downloadUrl release];
    [super dealloc];
}


//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSLog(@"download finished!");
//    if(delegate && [delegate respondsToSelector:@selector(segmentDownloadFinished:)])
//    {
//        [delegate segmentDownloadFinished:self];
//    }
//}

//- (void)requestFailed:(ASIHTTPRequest *)aRequest
//{
//    NSError *err = aRequest.error;
//    if (err.code != 3) 
//    {
//        [self stop];
//        NSLog(@"Download failed.");
//        if(delegate && [delegate respondsToSelector:@selector(segmentDownloadFailed:)])
//        {
//            [delegate segmentDownloadFailed:self];
//        }
//    }
//}

- (void)setProgress:(float)newProgress
{
    progress = newProgress;
    // NSLog(@"newprogress :%f",newProgress);
}

@end
