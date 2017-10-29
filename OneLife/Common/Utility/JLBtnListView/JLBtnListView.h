//
//  JLBtnListView.h
//  JLTravel
//
//  Created by 张舒雯 on 15/11/24.
//  Copyright (c) 2015年 端倪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLBtnListView;
@protocol JLBtnListViewDelegate <NSObject>


@required
/**
 *    按钮列表中，各按钮的标题的数组
 *
 *  @param btnList JLBtnListView实利
 *
 *  @return 按钮的标题数组
 */
-(NSArray<NSString*>*)btnListViewTitles:(JLBtnListView*)btnList;

/**
 *  每行多少列即每行几个按钮
 *
 *  @param btnList JLBtnListView实例
 *
 *  @return 每行的列数。
 *  
 */
-(NSInteger)btnListViewColumnCount:(JLBtnListView*)btnList;

@optional

/**
 *  点击了某个按钮
 *
 *  @param btnList JLBtnListView实例
 *  @param index   点击的按钮的索引
 */
-(void)btnListView:(JLBtnListView*)btnList didSelectedBtnAtIndex:(NSUInteger)index;
/**
 *  取消选择某个按钮
 *
 *  @param btnList <#btnList description#>
 *  @param index   取消的按钮的索引
 */
-(void)btnListView:(JLBtnListView *)btnList didUnSelectedBtnAtIndex:(NSUInteger)index;

/**
 *  按钮的高度
 *
 *  @return 按钮的高度
 */
-(CGFloat)btnListViewBtnHeight:(JLBtnListView*)btnList;

/**
 *  按钮间的Y方向上的间距。以及按钮距离视图的边距
 *
 *  @param btnList JLBtnListView实例，
 *
 *  @return 间距
 */
-(CGFloat)btnListViewBtnYGap:(JLBtnListView*)btnList;

/**
 *  按钮间的X方向上的间距。以及按钮距离视图的边距
 *
 *  @param btnList JLBtnListView实例
 *
 *  @return 间距
 */
-(CGFloat)btnListViewBtnXGap:(JLBtnListView *)btnList;

/**
 *  按钮的圆角度
 *
 *  @param btnList JLBtnListView实例
 *
 *  @return 圆角度数
 */
-(CGFloat)btnListViewBtnCornerRadius:(JLBtnListView*)btnList;

/**
 *  按钮选中时的背景色
 *
 *  @param btnList
 *
 *  @return 按钮的选中时背景色
 */
-(UIColor*)btnListViewBtnSelectedBgColor:(JLBtnListView*)btnList;

/**
 *  按钮标题的字体
 *
 *  @param btnList JLBtnListView实例
 *
 *  @return 字体
 */
-(UIFont*)btnListViewBtnTitleFont:(JLBtnListView*)btnList;

/**
 *  按钮标题的颜色
 *
 *  @param btnList JLBtnListView实例
 *
 *  @return 颜色
 */
-(UIColor*)btnListViewBtnTitleColor:(JLBtnListView*)btnList;

/**
 *  选中时，按钮标题的颜色
 *
 *  @param btnList <#btnList description#>
 *
 *  @return <#return value description#>
 */
-(UIColor*)btnListViewBtnSelectedTitleColor:(JLBtnListView *)btnList;

/**
 *  按钮的背景色
 *
 *  @param btnList
 *
 *  @return UIColor 实例
 */
-(UIColor*)btnListViewBtnBgColor:(JLBtnListView *)btnList;

/**
 *  数据加载完成后，
 *
 *  @param btnList    按钮列表实例
 *  @param viewHeight 加载完数据，计算的view的高度
 */
- (void)btnListView:(JLBtnListView *)btnList loadDataCompleteWithViewHeight:(CGFloat)viewHeight;

- (UIImage*)btnListViewBtnSelectedImage:(JLBtnListView*)btnLit;

@end


/**
 *  会自动根据按钮的数量 和 每行的个数 以及按钮的高度 自动计算本视图的宽高。其中宽为 （本视图的父视图的宽度 - 本视图的X坐标的*2）。边缘按钮距离本视图各边的间距均为0
 */
@interface JLBtnListView : UIView

@property (nonatomic, assign) id<JLBtnListViewDelegate> delegate;
@property (nonatomic, assign) BOOL isCanMultiSelect;          //是否可以多选,默认为NO
@property (nonatomic, assign) BOOL btnOfEdgeIsNeedTitleAtEdge;//边缘按钮的标题是否需要靠边对其。 默认为NO
@property (nonatomic, assign) BOOL isCanSelected;             //是否允许选择，默认为YES


@property (nonatomic, assign, readonly) NSInteger currSelectedSingleBtnIndex;     //当前选择的单选按钮的索引,默认为-1
@property (nonatomic, strong) NSArray <NSNumber*> *currSelectedMultiBtnIndexes;   //当前选择的多选按钮的索引数组，默认为nil

-(void)reloadData;

/**
 *  设置某个项目被选中
 *
 *  @param index 待选中的Item的索引
 */
- (void)selectBtnAtIndex:(NSUInteger)index;

/**
 *  设置某个项目 取消选中
 *
 *  @param index 待取消选中的Item的索引
 */
- (void)deselectBtnAtIndex:(NSUInteger)index;

@end


