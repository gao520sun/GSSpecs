//
//  CTMediator+ZJTestActions.m
//  TCP
//
//  Created by qijia on 16/9/2.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "CTMediator+ZJTestActions.h"
NSString * const kCTMediatorTargetA = @"A";

NSString * const kCTMediatorActionNativFetchDetailViewController = @"nativeFetchDetailViewController";
@implementation CTMediator (ZJTestActions)

- (UIViewController *)CTMediator_viewControllerForDetail:(id)parms{
    UIViewController *viewController = [self performTarget:kCTMediatorTargetA
                                                    action:kCTMediatorActionNativFetchDetailViewController
                                                    params:@{@"m":@"m"}];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }

}

@end
