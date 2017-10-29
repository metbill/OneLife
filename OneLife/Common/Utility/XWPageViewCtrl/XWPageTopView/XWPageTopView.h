//
//  XWPageTopView.h
//  XWPageViewControllerDemo
//
//  Created by hitomedia on 16/7/29.
//  Copyright © 2016年 hitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWPageViewAppearance;
@protocol XWPageTopViewDelegate;
@interface XWPageTopView : UIView

@property (nonatomic, assign) BOOL showSearchView;      //是否展示搜索视图，默认为NO
@property (nonatomic, strong) NSArray* itemTitles;      //各页顶部的标题

@property (nonatomic, assign) id<XWPageTopViewDelegate> delegate;

@property (nonatomic, strong) XWPageViewAppearance *apearance;

- (void)scrollLineViewWithPercent:(CGFloat)percent;

@end


@protocol XWPageTopViewDelegate <NSObject>

@optional
/**
 *  点击item事件
 *
 *  @param item 被触发事件的item
 */
- (void)pageTopViewHandleItem:(UIButton*)item itemIndex:(NSUInteger)index;

- (void)pageTopView:(XWPageTopView*)ptView searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

- (void)pageTopView:(XWPageTopView*)ptView searchBarSearchButtonClicked:(UISearchBar *)searchBar;
@end


