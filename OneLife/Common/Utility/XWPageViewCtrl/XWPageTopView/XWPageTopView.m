//
//  XWPageTopView.m
//  XWPageViewControllerDemo
//
//  Created by hitomedia on 16/7/29.
//  Copyright © 2016年 hitu. All rights reserved.
//

#import "XWPageTopView.h"
#import "XWSearchView.h"
#import "UIColor+XW.h"
#import "XWPageViewAppearance.h"

static CGFloat const gItemTagBase = 100;

@interface XWPageTopView()<UISearchBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *lineScrollView;
@property (nonatomic, strong) XWSearchView *searchView;
@property (nonatomic, strong) UIView       *lineView;

@end

@implementation XWPageTopView{
    BOOL _showSearchV;              //是否展示搜索视图
    CGFloat _lineViewWidth;         //滑动线条宽度，0为自动计算。
    CGFloat _itemMinWidth;          //item 最小的宽度。
    CGFloat _itemXGap;              //item 水平方向的间距
    CGFloat _itemEdgeDistance;      //距离左右边框的距离。
    CGFloat _itemCenterXDistance;   //item 中心点之间的x距离
    CGFloat _itemTitleFontSize;     //item 标题字号
    UIColor *_itemTitleColor;        //item 标题颜色
    UIColor *_itemSelectedTitleColor;
    UIColor *_lineColor;
    NSUInteger _itemMaxCount;       //item 最大数量。0 为不限制
    NSUInteger _currItemIndex;      //当前选择的item的索引
}

#pragma mark - Init

- (instancetype)init{
    self = [super init];
    if( self ){
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if( self ){
        [self initData];
    }
    return self;
}

- (void)initData{
    _showSearchView = NO;
    _showSearchV = NO;
    
    _lineViewWidth = 0;
    _itemMinWidth = 30;
    _itemXGap = 0;
    _itemEdgeDistance = 0;
    _currItemIndex = 0;
    
    _itemTitleFontSize = 14.0;
    _itemTitleColor = [UIColor colorWithR:51 G:51 B:51];
    _lineColor = [UIColor redColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self doLayout];
}

- (void)doLayout{
    
    if( self.itemTitles.count ){
        CGSize size = self.frame.size;
        CGFloat iy = 0;
        if( _showSearchView ){
            iy = CGRectGetMaxY(self.searchView.frame);
        }
        
        self.lineScrollView.frame = CGRectMake(0, iy, size.width, size.height-iy);
        
        CGFloat itemWidth = (size.width-(self.itemTitles.count-1)*_itemXGap-_itemEdgeDistance*2)/self.itemTitles.count;
        if( itemWidth < _itemMinWidth ){
            itemWidth = _itemMinWidth;
        }
        
        _itemCenterXDistance = itemWidth + _itemXGap;
        
        CGFloat lineH = 1;
        CGFloat lvWidth = _lineViewWidth;
        if( self.itemTitles.count ){
            if( lvWidth > CGRectGetWidth(self.frame)/self.itemTitles.count || lvWidth <=0 ){
                lvWidth = CGRectGetWidth(self.frame)/self.itemTitles.count;
                _lineViewWidth = lvWidth;
            }
        }
        CGFloat lvX = [ self lineViewOriginXWithItemWidth:itemWidth
                                                    itemX:_itemEdgeDistance
                                                lineViewW:lvWidth];
        self.lineView.frame = CGRectMake(lvX, CGRectGetHeight(_lineScrollView.frame)-lineH, lvWidth, lineH);
        
        iy = 0;
        CGFloat ih = CGRectGetHeight(_lineScrollView.frame)-lineH;
        CGFloat ix = 0 ;
        
        NSUInteger i=0;
        CGFloat contentW = 0;
        for( NSString *title in self.itemTitles ){
            
            UIButton *item = [self.lineScrollView viewWithTag:i+gItemTagBase];
            if( item == nil ){
                 item = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            UIColor *titleColor = _itemTitleColor;
            if( _currItemIndex == i ){
                titleColor = _itemSelectedTitleColor;
            }
            ix = _itemEdgeDistance + (i*(itemWidth+_itemXGap));
            item.frame = CGRectMake(ix, iy, itemWidth, ih);
            UIColor *bgColor = [UIColor clearColor];
            if(_apearance.topViewItemColor ){
                bgColor = _apearance.topViewItemColor;
            }
            item.backgroundColor = bgColor;
            [item setTitleColor:titleColor forState:UIControlStateNormal];
            [item setTitle:title forState:UIControlStateNormal];
            item.titleLabel.font = [UIFont systemFontOfSize:_itemTitleFontSize];
            item.tag = i+gItemTagBase;
            [item addTarget:self action:@selector(handleItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.lineScrollView addSubview:item];
            i++;
            
            if( i == self.itemTitles.count ){
                contentW = CGRectGetMaxX(item.frame);
                if( contentW < size.width ){
                    contentW = size.width;
                }
            }
        }
        _lineScrollView.contentSize = CGSizeMake(contentW, CGRectGetHeight(_lineScrollView.frame));
        self.backgroundColor = _apearance.topViewBackColor;
        self.lineScrollView.backgroundColor = _apearance.lineScrollViewBackColor;
    }
}

#pragma mark - Public

- (void)setShowSearchView:(BOOL)showSearchView{
    _showSearchView = showSearchView;
    _showSearchV = showSearchView;
}

-  (void)setItemTitles:(NSArray *)itemTitles{
    _itemTitles = itemTitles;
    
    [self doLayout];
}

- (void)setApearance:(XWPageViewAppearance *)apearance{
    _apearance = apearance;
    _lineViewWidth = apearance.lineViewWidth;         //滑动线条宽度，0为自动计算。
    _itemMinWidth = apearance.itemMinWidth;          //item 最小的宽度。
     _itemXGap= apearance.itemXGap;              //item 水平方向的间距
    _itemEdgeDistance= apearance.itemEdgeDistance;      //距离左右边框的距离。
    _itemCenterXDistance = apearance.itemCenterXDistance;   //item 中心点之间的x距离
    _itemTitleFontSize = apearance.itemTitleFontSize;     //item 标题字号
    _itemTitleColor = apearance.itemTitleColor;        //item 标题颜色
    _itemSelectedTitleColor = apearance.itemSelectedTitleColor;
    
    _itemMaxCount = apearance.itemMaxCount;       //item 最大数量。0 为不限制
    _currItemIndex = apearance.currItemIndex;      //当前选择的item的索引
    _lineColor = apearance.lineColor;
    
//    self.lineView.backgroundColor = _lineColor;
//    self.backgroundColor = apearance.topViewBackColor;
//    self.lineScrollView.backgroundColor = self.backgroundColor;
}

- (void)scrollLineViewWithPercent:(CGFloat)percent{
    
    CGRect fr = self.lineView.frame;
    fr.origin.x = percent * (self.lineScrollView.contentSize.width-2*_itemEdgeDistance)+_itemEdgeDistance + fabs((_itemCenterXDistance-_itemXGap-_lineViewWidth)/2);
    
    self.lineView.frame = fr;
    
    NSLog(@"%lf",percent);
    
    CGFloat itemMaxW = ((self.lineScrollView.contentSize.width-2*_itemEdgeDistance)/self.itemTitles.count);
    CGFloat result = self.lineView.center.x / itemMaxW;
    NSUInteger zResult = (NSUInteger)result;
    _currItemIndex =  result-zResult > 0 ?zResult:zResult-1;

    if( self.apearance ){
        if( _apearance.currItemIndex != _currItemIndex ){
            UIButton *lastView = [self.lineScrollView viewWithTag:_apearance.currItemIndex+gItemTagBase];
            if( [lastView isKindOfClass:[UIButton class]] ){
                [lastView setTitleColor:_apearance.itemTitleColor forState:UIControlStateNormal];
            }
            
            UIButton *currView = [self.lineScrollView viewWithTag:_currItemIndex+gItemTagBase];
            if( [currView isKindOfClass:[UIButton class]] ){
                [currView setTitleColor:_apearance.itemSelectedTitleColor forState:UIControlStateNormal];
            }
        }
    }
    _apearance.currItemIndex = _currItemIndex;
}

#pragma mark - Touch Events

- (void)handleItem:(UIButton*)btn{
    if( _delegate && [_delegate respondsToSelector:@selector(pageTopViewHandleItem:itemIndex:)] ){
        [_delegate pageTopViewHandleItem:btn itemIndex:btn.tag-gItemTagBase];
    }
}

#pragma mark - Private

- (CGFloat)lineViewOriginXWithItemWidth:(CGFloat)itemWidth itemX:(CGFloat)itemX lineViewW:(CGFloat)lvW{
//        return (itemWidth-lvW)/2+itemX;
    
    CGFloat lineEdgeDistance = (itemWidth-lvW)/2+itemX;
    return (lineEdgeDistance + lvW)*_currItemIndex + lineEdgeDistance;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (_delegate && [_delegate respondsToSelector:@selector(pageTopView:searchBar:textDidChange:)] ){
        [_delegate pageTopView:self searchBar:searchBar textDidChange:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    if( [_delegate respondsToSelector:@selector(pageTopView:searchBarSearchButtonClicked:)] ){
        [_delegate pageTopView:self searchBarSearchButtonClicked:searchBar];
    }
}

#pragma mark - Propertys
- (UIScrollView *)lineScrollView{
    if( !_lineScrollView ){
        _lineScrollView = [[UIScrollView alloc] init];
        _lineScrollView.backgroundColor = [UIColor colorWithR:240 G:240 B:240];
        _lineScrollView.showsVerticalScrollIndicator = NO;
        _lineScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_lineScrollView];
        
        _lineScrollView.delegate =self;
    }
    return _lineScrollView;
}

- (XWSearchView *)searchView {
    if( !_searchView ){
        _searchView = [[XWSearchView alloc] init];
        _searchView.searchBar.delegate = self;
        [self addSubview:_searchView];
    }
    return _searchView;
}

- (UIView *)lineView {
    if( !_lineView ){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = _lineColor;//[UIColor colorWithR:24 G:148 B:209];
        
        [self.lineScrollView addSubview:_lineView];
    }
    return _lineView;
}

@end




