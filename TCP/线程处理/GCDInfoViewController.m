//
//  GCDInfoViewController.m
//  TCP
//
//  Created by qijia on 16/8/30.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "GCDInfoViewController.h"

@interface GCDInfoViewController ()

@end

@implementation GCDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.type==0){
        //简介:功能：把一项任务提交到队列中多次执行，具体是并行执行还是串行执行由队列本身决定.注意，dispatch_apply不会立刻返回，在执行完毕后才会返回，是同步的调用。
        [self dispatchApply];
    }else if(self.type ==1){
        [self dispatchAfter];
    }else if(self.type == 2){
//        同步添加操作。他是等待添加进队列里面的操作完成之后再继续执行
        [self dispatchSync];
    }else if(self.type == 3){
//        异步添加进任务队列，它不会做任何等待
        [self dispatchAsync];
    }else if(self.type == 4){
        [self serial];//串行队列
    }else if(self.type == 5){
        [self concurrent];
    }else if(self.type == 6){
        [self dispatchGroup];
    }else if(self.type == 7){
        [self dispatchSource];
    }else if(self.type == 8){
        [self dispatchSample];
    }
}

//同步操作执行次数
-(void)dispatchApply{
//    iterations 执行的次数
//    queue 提交到的队列
//    block 执行的任务
    NSMutableArray* muarray = [@[@"hello",@"hellolcg",@"goodbay lms"]mutableCopy];
    
    dispatch_apply(3,dispatch_get_global_queue(0,0),^(size_t time){
        NSLog(@"str=%@",muarray[time]);
        
    });
    NSLog(@"Dispatch_after in global queue is over");
    [self alt:@"Dispatch_after in global queue is over"];
}

//延迟
-(void)dispatchAfter{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"延迟1秒");
        [self alt:@"延迟1秒"];
    });
}


//同步机制
-(void)dispatchSync{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0 ; i < 5; i ++)
        {
            NSLog(@"%@=====%d"  , [NSThread currentThread] , i);
            [NSThread sleepForTimeInterval:0.1];
        }
    });
    NSLog(@"第一个同步代码");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                  , ^(void){
                      for (int i = 0 ; i < 5; i ++)
                      {
                          NSLog(@"%@-----%d"  , [NSThread currentThread] , i);
                          [NSThread sleepForTimeInterval:0.1];
                      }
                  });
    NSLog(@"第二个同步代码");
}

//异步添加进任务队列，它不会做任何等待
-(void)dispatchAsync{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"3");
    });
    NSLog(@"4");
}



//串行队列 不开线程,因为任务是同步的,只在当前线程执行
dispatch_queue_t serialQueue;//c

-(void)serial{
    // 依次将2个代码块提交给串行队列
    // 必须等到第1个代码块完成后，才能执行第2个代码块。
    serialQueue = dispatch_queue_create("fkjava.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        for (int i = 0 ; i < 5; i ++)
        {
            NSLog(@"%@=====%d"  , [NSThread currentThread] , i);
        }
    });
    NSLog(@"第一个");
    dispatch_async(serialQueue, ^(void)
                   {
                       for (int i = 0 ; i < 5; i ++)
                       {
                           NSLog(@"%@------%d" , [NSThread currentThread] , i);
                       }
    });
    NSLog(@"第二个");
}

dispatch_queue_t concurrentQueue;//b
//并发队列•并发功能只有在异步（dispatch_async）函数下才有效
-(void)concurrent{
    concurrentQueue = dispatch_queue_create("fkjava.queue"
                                            , DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        for (int i = 0 ; i < 5; i ++)
        {
            NSLog(@"%@=====%d"  , [NSThread currentThread] , i);
        }
    });
    NSLog(@"第一个");
    dispatch_async(serialQueue, ^(void)
                   {
                       for (int i = 0 ; i < 5; i ++)
                       {
                           NSLog(@"%@------%d" , [NSThread currentThread] , i);
                       }
                   });
    NSLog(@"第二个");
}

//灵活使用dispatch_group
//1创建dispatch_group_t
//2添加任务（block
//3添加结束任务（如清理操作、通知UI等）
-(void)dispatchGroup{
    __block BOOL b = NO;
    //1.创建group 和 队列
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("my.qjia.com", 0);
   
    //2添加任务
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        //
        NSLog(@"任务1");
        dispatch_group_leave(group);
    });
    //可以添加多个任务
    dispatch_group_async(group, queue, ^{
        //
        b = YES;
        NSLog(@"任务2");
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"一步1");
        });
    });
   
    
    //4.加入第三个任务
    dispatch_group_enter(group);
    NSLog(@"任务组3完成");
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"一步2");
    });
    dispatch_group_leave(group);
   
    
    
    //延迟
//    dispatch_group_enter(group);
//    dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC);
//    dispatch_after(tt, dispatch_get_main_queue(), ^{
//        NSLog(@"任务组4完成");
//        dispatch_group_leave(group);
//    });
    
//    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)));
    //结束任务
    dispatch_group_notify(group, queue, ^{
        NSLog(@"任务完成");
    });
    
}




static NSArray *array = nil;
-(void)dispatchSource{
    //用户事件 同步进行事件
//    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(0, 0));
//    dispatch_source_set_event_handler(source, ^{
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"source....%lu",dispatch_source_get_data(source));//获取结果
//            
//        });
//        
//    });
//    dispatch_resume(source);
//    array = [NSArray arrayWithObjects:@"1",@"3",@"4",@"5", nil];
//    
////    dispatch_queue_t queue = dispatch_queue_create("me.tutuge.test.gcd", DISPATCH_QUEUE_SERIAL);
//    
//    //同步进行
////    dispatch_apply(4, queue, ^(size_t index) {
////        NSLog(@"indx....%zu",index);
////        // do some work on data at index
////        dispatch_source_merge_data(source, index);
////    });
//    for(int  i = 0 ; i<10 ;i++){
//        dispatch_source_merge_data(source, 1);
//    }
    
    
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, STDIN_FILENO, 0, global);
    dispatch_source_set_event_handler(source, ^{
        char buf[1024];
        int len = read(STDIN_FILENO, buf, sizeof(buf));
        if(len > 0)
            NSLog(@"Got data from stdin: %.*s", len, buf);
    });
    dispatch_resume(source);
    for(int  i = 0 ; i<10 ;i++){
        dispatch_source_merge_data(source, 1);
    }

}


-(void)print:(unsigned long)index{
//    NSLog(@"array...%@.....%ld",array[index],index);
}


//信号量基于计数器的一种多线程同步机制。在多个线程访问共有资源时候，会因为多线程的特性而引发数据出错的问题。
-(void)dispatchSample{
    //1.建立全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.创建dispatch_semaphore_t对象
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);//1表示初始值
    //dispatch_time_t timeout:由dispatch_time_t类型值指定等待时间
    NSMutableArray *mArray = [NSMutableArray array];
    for(int i = 0 ; i<1000 ; i++){
        dispatch_async(global, ^{
            //数据进入,等待处理,信号量减1
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [mArray addObject:[NSNumber numberWithInt:i]];
             //数据处理完毕,信号量加1,等待下一次处理
            dispatch_semaphore_signal(semaphore);
        });
    }
    NSLog(@"marrray...%@",mArray);
    
}


















-(void)alt:(NSString *)message{
    UIAlertView *altc = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [altc show];
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
