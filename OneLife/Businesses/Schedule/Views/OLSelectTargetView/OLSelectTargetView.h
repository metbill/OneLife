//
//  OLSelectTargetView.h
//  OneLife
//
//  Created by hitomedia on 2017/10/26.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLTargetModel;
@interface OLSelectTargetView : UIView

@property (nonatomic, strong) NSArray<OLTargetModel*> *datas;
@property (nonatomic, copy) void(^handleItemBlock)(NSUInteger index);

@end


@interface OLSelectTargetViewCell : UICollectionViewCell{
    @public
    UILabel *_titleL;
}

@property (nonatomic, strong) OLTargetModel *model;
@end

