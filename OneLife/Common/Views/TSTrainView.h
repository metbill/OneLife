//
//  TSTrainView.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/21.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTrainView : UIView
@property (nonatomic, strong) UILabel *departureStationL;     //始发站
@property (nonatomic, strong) UILabel *departureTimeL;        //出发时间
@property (nonatomic, strong) UILabel *arrivalStationL;       //目的地
@property (nonatomic, strong) UILabel *arrivalTimeL;          //到达时间
@property (nonatomic, strong) UILabel *trainNumL;             //车次
@property (nonatomic, strong) UILabel *tourTimeL;             //旅程时间或座位
@property (nonatomic, strong) UIImageView *tourLine;          //旅途线条

/**
 唯一初始化方法
 */
- (id)initWithFrame:(CGRect)frame;

@end
