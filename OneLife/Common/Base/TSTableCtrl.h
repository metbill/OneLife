//
//  TSTableCtrl.h
//  HiTravelService
//
//  Created by hitomedia on 2017/4/18.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef TSTABLECTRL
#define TSTABLECTRL
typedef NS_ENUM(NSUInteger,TSTableCtrlShowType){
    TSTableCtrlShowTypePush = 0,
    TSTableCtrlShowTypePresent
};
#endif

@class TSCellModel;
@class TSCellParameter;
@protocol TSTableCtrlDelegate;
@interface TSTableCtrl : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id<TSTableCtrlDelegate> delegate;
@property (nonatomic, strong) NSArray<TSCellModel*> *datas;
@property (nonatomic, strong) TSCellParameter *cellParameter;
- (void)tc_registerCellClass:(NSString*)cellClassName;
- (void)tc_reloadData;

@end

@protocol TSTableCtrlDelegate <NSObject>

@optional
- (void)tableCtrl:(TSTableCtrl*)tableCtrl selectCellAtIndex:(NSUInteger)index;

@end

@interface TSTableCtrlTheme : NSObject

@end

