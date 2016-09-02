//
//  IDSignRecordModel.h
//  iDoctor9Patient
//
//  Created by 000000 on 16/8/13.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDSignModel : NSObject
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *message;
@end

@interface IDSignListModel : NSObject
/*结构数据源*/
@property (nonatomic,strong) NSMutableArray *fmSignList;
@property (nonatomic,assign) BOOL isNewRecord;
@end


@interface IDSignRecordModel : NSObject
/*记录id*/
@property (nonatomic,copy) NSString *accountId;
/*医生id*/
//@property (nonatomic,copy) NSString *doctorId;
/*医生姓名*/
@property (nonatomic,copy) NSString *signDoctor;
/*团队id*/
@property (nonatomic,copy) NSString *fmTeamId;
/*服务包名*/
@property (nonatomic,copy) NSString *servicePage;
/*申请日期*/
@property (nonatomic,copy) NSString *createDate;
/*医生工作地址*/
@property (nonatomic,copy) NSString *hospitalName;
/*记录状态  1.未处理 2.已生效 3.已拒绝 4.已取消  9.待生效*/
@property (nonatomic,copy) NSString *state;
/*患者ID*/
@property (nonatomic,copy) NSString  *basePatientId;
/*患者姓名*/
@property (nonatomic,copy) NSString *signer;
/*患者图片*/
@property (nonatomic,copy) NSString *photoUrl;
/*户主*/
@property (nonatomic,copy) NSString *housermaster;
/*组织*/
@property (nonatomic,copy) NSString *familys;

@end


