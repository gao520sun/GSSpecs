//
//  IDSignRecordModel.m
//  iDoctor9Patient
//
//  Created by 000000 on 16/8/13.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "IDSignModel.h"

@implementation IDSignModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data":@"IDSignListModel"
             };
}

@end

@implementation IDSignListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"fmSignList":@"IDSignRecordModel"
             };
}

@end

@implementation IDSignRecordModel


@end


