//
//  OLEnums.h
//  OneLife
//
//  Created by wkun on 2017/10/22.
//  Copyright © 2017年 wkun. All rights reserved.
//

#ifndef OLEnums_h
#define OLEnums_h

typedef NS_ENUM(NSUInteger,OLScheduleStatus){
    OLScheduleStatusTobeDone = 0,  //等待完成
//    OLScheduleStatusDoing,     //进行中   (如：25号 买车票，到达25号时，该日程状态则为进行中，25号之前则为等待执行，25号之后则为已延期)
    OLScheduleStatusCompleted, //已完成
//    OLScheduleStatusDelayed    //已延期
};

typedef NS_ENUM(NSUInteger, OLTargetStatus){
    OLTargetStatusContinue = 0, //进行中
    OLTargetStatusCompleted, //已完成
    OLTargetStatusExpired //已过期
};

//时间分为四种
typedef NS_ENUM(NSUInteger, OLTimeType){
    OLTimeTypeInvestment = 0,//投资
    OLTimeTypeWaste, //浪费
    OLTimeTypeSleep, //睡眠
    OLTimeTypeRoutine //固定的时间，如走路，洗脸刷牙等
};

#endif /* OLEnums_h */
