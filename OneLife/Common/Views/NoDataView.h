//
//  NoDataView.h
//  HiTravelService
//
//  Created by hitomedia on 2017/5/5.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView
- (id)initWithFrame:(CGRect)fr text:(NSString*)text action:(SEL)loadDataSel target:(UIViewController*)target;

@property (nonatomic, assign) BOOL hideReloadBtn;   //默认为NO
@property (nonatomic, strong) NSString *text;

@end
