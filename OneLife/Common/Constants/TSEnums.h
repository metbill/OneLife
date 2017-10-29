//
//  TSEnums.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/24.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#ifndef TSEnums_h
#define TSEnums_h

typedef NS_ENUM(NSUInteger, TSFoodOrderStatus){
    TSFoodOrderStatusCancled = 0,  //已取消
    TSFoodOrderStatusNotDelivery,  //未配送
    TSFoodOrderStatusNotConfirm,   //未确认
    TSFoodOrderStatusNotComplete,  //未完成
    TSFoodOrderStatusCompleted,    //已完成
    TSFoodOrderStatusOther
};

typedef NS_ENUM(NSUInteger, TSFoodOrderType){
    TSFoodOrderTypeAll = 0,
    TSFoodOrderTypeNotDelivery,  //未配送
    TSFoodOrderTypeNotConfirm,   //未确认
    TSFoodOrderTypeNotComplete,  //未完成
    TSFoodOrderTypeCompleted     //已完成
};


#endif /* TSEnums_h */
