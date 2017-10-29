//
//  JLBtnListView.m
//  JLTravel
//
//  Created by 张舒雯 on 15/11/24.
//  Copyright (c) 2015年 端倪. All rights reserved.
//

#import "JLBtnListView.h"

#define BLVIEW_TAG_PERFIX 910
#define BLVIEW_BTN_DEFAULT_HEIGHT 35

@implementation JLBtnListView{
    NSMutableArray *_selectIndexes;
    NSUInteger _itemCount;              //当前的项目的数量
}

-(id)init{
    self = [super init];
    if( self ){
        self.frame =CGRectZero;
        [self initData];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self){
        [self initData];
    }
    return self;
}

-(void)initData{
    
    self.isCanMultiSelect = NO;
    self.btnOfEdgeIsNeedTitleAtEdge = NO;
    self.isCanSelected = YES;
    _currSelectedSingleBtnIndex = -1;
    _selectIndexes = [[NSMutableArray alloc] initWithCapacity:5];
    _itemCount = 0;
}

- (void)setCurrSelectedMultiBtnIndexes:(NSArray<NSNumber *> *)currSelectedMultiBtnIndexes{
    _currSelectedMultiBtnIndexes = currSelectedMultiBtnIndexes;
    _selectIndexes = [[NSMutableArray alloc] initWithArray:currSelectedMultiBtnIndexes];
    if( self.currSelectedMultiBtnIndexes.count ){
        _currSelectedSingleBtnIndex = ((NSNumber*)(currSelectedMultiBtnIndexes[0])).intValue;
    }
    
}

#pragma mark - Private
-(void)doLayout{

    if( self.delegate && [self.delegate respondsToSelector:@selector(btnListViewColumnCount:)] ){
        if( [self.delegate respondsToSelector:@selector(btnListViewTitles:)] ){

            NSArray *titles = [self.delegate btnListViewTitles:self];
            if( titles==nil || titles.count ==0 ) return;
            
            CGFloat viewWidth = 0.0;
            if( [self superview] ){
                viewWidth = [self superview].frame.size.width - self.frame.origin.x*2;
            }
            NSInteger columnCount = [self.delegate btnListViewColumnCount:self];
            CGFloat yGap = [self getYgap];
            CGFloat ih = BLVIEW_BTN_DEFAULT_HEIGHT;
            if( self.delegate && [self.delegate respondsToSelector:@selector(btnListViewBtnHeight:)]){
                ih = [self.delegate btnListViewBtnHeight:self];
            }

            NSUInteger i=0;
            NSUInteger calculateRows = 0;
            CGFloat xGap = [self getXgap];
            CGFloat lastBtnRight = 0;
            for(NSString *title in titles){
                
                NSInteger btnTag = i+BLVIEW_TAG_PERFIX;
                UIButton *btn = [self viewWithTag:btnTag];
                //如果按钮不存在，则添加
                if( !btn ){
                    btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self addSubview:btn];
                }
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = [self getBtnCornerRadius];

                btn.titleLabel.font = [self getBtnTitleFont];
                [btn setTitleColor:[self getBtnTitleColor] forState:UIControlStateNormal];
                [btn setTitleColor:[self getSelectedBtnTitleColor] forState:UIControlStateSelected ];
                [btn setTitle:title forState:UIControlStateNormal];
                btn.tag = btnTag;
                btn.selected = [self btnIsSelectedWithIndex:btn.tag-BLVIEW_TAG_PERFIX];
                [self updateBtnBg:btn];
                if( [_delegate respondsToSelector:@selector(btnListViewBtnSelectedImage:)] ){
                    UIImage *img = [_delegate btnListViewBtnSelectedImage:self];
                    [btn setImage:img forState:UIControlStateSelected];
                }

                if( columnCount > 0 ){
                    
                    CGFloat iw = (viewWidth - (columnCount-1)*xGap)/columnCount;
                    NSUInteger xIndex= i%columnCount;
                    CGFloat ix = ((CGFloat)xIndex)*(xGap+iw);
                    NSUInteger res = i/columnCount;     //行索引
                    CGFloat iy = res * (yGap+ih);
                    if( self.btnOfEdgeIsNeedTitleAtEdge ){
                        if( xIndex ==0 ){
                            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
                            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        }
                        else if( xIndex == columnCount-1 ){
                            btn.titleLabel.textAlignment = NSTextAlignmentRight;
                            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        }
                        else{
                            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        }
                    }
                    btn.frame = CGRectMake(ix, iy, iw, ih);
                }
                
                //当按钮的列数为0或者-1 时，则自动根据按钮的标题计算其长度。 超过父视图的宽度则换行
                else{
                    
                    CGFloat iw = [self lableSizeWithText:btn.titleLabel.text font:btn.titleLabel.font width:viewWidth].width;
                    
                    //在当前行剩余的宽度.可用来放置按钮的宽度
                    CGFloat surplusWidthAtRow = viewWidth - lastBtnRight - xGap;
                    CGFloat ix = 0.0;
                    
                    //当按钮的宽度 小于等于本行可用的宽度时
                    if( surplusWidthAtRow >= iw  ){
                        
                        ix = lastBtnRight +xGap;
                    }
                    //当按钮的宽度大于可用宽度。换行
                    else{
                        calculateRows++;
                        ix = 0.0;
                    }
                    
                    if( i==0 && calculateRows ==0 ){
                        ix = 0.0;
                    }
                    
                    lastBtnRight = (ix+iw);
                    
                    
                    CGFloat iy = calculateRows*(yGap+ih);
                    btn.frame = CGRectMake(ix, iy, iw, ih);
                }
                
                [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                i++;
            }
            
            for( NSUInteger i=titles.count; i<_itemCount; i++ ){
                UIView *btn = [self viewWithTag:i+BLVIEW_TAG_PERFIX];
                [btn removeFromSuperview];
                btn = nil;
            }
            _itemCount = titles.count;
            
            //计算frame
            CGRect fr = self.frame;
            NSUInteger rows = calculateRows+1;
            if( columnCount>0 ){
                NSUInteger mod = titles.count % columnCount;
                rows = titles.count / columnCount  ;
                if( mod ){
                    rows+=1;
                }
            }
            
            CGFloat vH = (rows-1)*(yGap+ih) + ih;
            fr.size.height = vH;
            fr.size.width = viewWidth;
            self.frame = fr;
            
            if( self.delegate && [_delegate respondsToSelector:@selector(btnListView:loadDataCompleteWithViewHeight:)] ){
                [_delegate btnListView:self loadDataCompleteWithViewHeight:fr.size.height];
            }
        }
    }
}

- (BOOL)btnIsSelectedWithIndex:(NSUInteger)idx{
    for(NSNumber *num in self.currSelectedMultiBtnIndexes ){
        if( idx == num.integerValue ){
            return YES;
        }
    }
    
    return NO;
}

-(void)updateBtnStateWithLastClickBtnTag:(NSUInteger)lastBtnTag{
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(btnListViewTitles:)] )
    {
        NSArray *btnTitles = [self.delegate btnListViewTitles:self];
        if( btnTitles && btnTitles.count ){
            NSUInteger i=0;
            while (i<btnTitles.count) {
                
                NSUInteger btnTag = i+BLVIEW_TAG_PERFIX;
                
                UIButton *btn = (UIButton*)[self viewWithTag:btnTag];
                if( [btn isKindOfClass:[UIButton class]] == NO)
                    return;
                
                if( !self.isCanMultiSelect ){
             
                    //单选时，除了最后一次单击的按钮，其他都置为未选中状态
                    if( btnTag != lastBtnTag ){
                        btn.selected = NO;
                    }
                }
                
                [self updateBtnBg:btn];
            
                i++;
            }
        }
    }
}

-(void)updateBtnBg:(UIButton*)btn{
    UIColor *bgColor = nil;
    if( btn.selected ){
        if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnSelectedBgColor:)] ){
            bgColor = [_delegate btnListViewBtnSelectedBgColor:self];
        }
        if( bgColor == nil )
            bgColor = [UIColor colorWithRed:167.0/255 green:209/255.0 blue:1.0 alpha:1.0];
    }
    else{
        
        if( [_delegate respondsToSelector:@selector(btnListViewBtnBgColor:)] ){
            bgColor = [_delegate btnListViewBtnBgColor:self];
        }
        
        if( bgColor == nil )
            bgColor = [UIColor whiteColor];
    }
    
    btn.backgroundColor = bgColor;
}

-(UIFont*)getBtnTitleFont{
    if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnTitleFont:)] ){
        return [_delegate btnListViewBtnTitleFont:self];
    }
    return [UIFont systemFontOfSize:11.0];
}

-(UIColor*)getBtnTitleColor{

    UIColor *c = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnTitleColor:)] ){
        c = [_delegate btnListViewBtnTitleColor:self];
    }
    return c;
}

-(UIColor*)getSelectedBtnTitleColor{
    
    UIColor *c = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnSelectedTitleColor:)] ){
        c = [_delegate btnListViewBtnSelectedTitleColor:self];
    }
    return c;
}

-(CGFloat)getBtnCornerRadius{
    CGFloat cr = 2.0;
    if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnCornerRadius:)] ){
        cr = [_delegate btnListViewBtnCornerRadius:self];
    }
    return cr;
}

-(CGFloat)getXgap{
    CGFloat xp = 10.0;
    if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnXGap:)] ){
        xp = [_delegate btnListViewBtnXGap:self];
    }
    return xp;
}

-(CGFloat)getYgap{
    CGFloat xp = 10.0;
    if( _delegate && [_delegate respondsToSelector:@selector(btnListViewBtnYGap:)] ){
        xp = [_delegate btnListViewBtnYGap:self];
    }
    return xp;
}

- (void)removeSelectIndex:(NSUInteger)idx{
    for( NSNumber *num in _selectIndexes ){
        if( num.intValue == idx ){
            [_selectIndexes removeObject:num];
            break;
        }
    }
    
    _currSelectedMultiBtnIndexes = _selectIndexes;
}

- (void)addSelectIndex:(NSUInteger)idx{
    BOOL isNeed = YES;
    for(NSNumber *num in _selectIndexes ){
        if( num.intValue == idx ){
            isNeed = NO;
        }
    }
    
    if( isNeed ){
        [_selectIndexes addObject:@(idx)];
    }
    _currSelectedMultiBtnIndexes = _selectIndexes;
}


-(CGSize)lableSizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    
    if( text == nil || font == nil ){
        return CGSizeZero;
    }
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    return [ text boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark - IBAction

-(void)handleBtn:(UIButton*)btn{
    
    if( self.isCanSelected == NO ) return; //不允许选择
    
    if( self.isCanMultiSelect ){
        if( btn.selected ){

      #warning 因为修改状态tianjia
            btn.selected = !btn.selected;

            
            for( NSNumber *num in _selectIndexes ){
                if( num.integerValue == btn.tag - BLVIEW_TAG_PERFIX ){
                    [_selectIndexes removeObject:num];
                    break;
                }
            }
            _currSelectedMultiBtnIndexes = _selectIndexes;
            
            if( self.delegate && [self.delegate respondsToSelector:@selector(btnListView:didUnSelectedBtnAtIndex:)]){
                [self.delegate btnListView:self didUnSelectedBtnAtIndex:btn.tag-BLVIEW_TAG_PERFIX];
            }
        }
        else{
#warning 因为修改状态tianjia
            btn.selected = !btn.selected;

            [_selectIndexes addObject:[NSNumber numberWithInteger:btn.tag-BLVIEW_TAG_PERFIX]];
            _currSelectedMultiBtnIndexes = _selectIndexes;
            
            if( self.delegate && [self.delegate respondsToSelector:@selector(btnListView:didSelectedBtnAtIndex:)]){
                [self.delegate btnListView:self didSelectedBtnAtIndex:btn.tag-BLVIEW_TAG_PERFIX];
            }
        }
        
//        btn.selected = !btn.selected;
        [self updateBtnStateWithLastClickBtnTag:btn.tag];
    }
    else{
        if( btn.selected==NO ){
            
            _currSelectedSingleBtnIndex = btn.tag - BLVIEW_TAG_PERFIX;
            btn.selected = !btn.selected;
            [self updateBtnStateWithLastClickBtnTag:btn.tag];
        }
        
        if( _currSelectedSingleBtnIndex == -1 && self.currSelectedMultiBtnIndexes.count ){
            _currSelectedSingleBtnIndex = ((NSNumber*)(self.currSelectedMultiBtnIndexes[0])).intValue;
        }
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(btnListView:didSelectedBtnAtIndex:)]){
            [self.delegate btnListView:self didSelectedBtnAtIndex:_currSelectedSingleBtnIndex];
        }
    }
}

#pragma mark - Public
-(void)reloadData{
    [self doLayout];
}

- (void)selectBtnAtIndex:(NSUInteger)index{
    UIButton *btn = [self viewWithTag:index+BLVIEW_TAG_PERFIX];
    if( btn && [btn isKindOfClass:[UIButton class]] && btn.isSelected==NO ){
        btn.selected = YES;
        [self updateBtnBg:btn];
        [self addSelectIndex:index];
        
        _currSelectedSingleBtnIndex = index;
    }
}

- (void)deselectBtnAtIndex:(NSUInteger)index{
    UIButton *btn = [self viewWithTag:index+BLVIEW_TAG_PERFIX];
    if( btn && [btn isKindOfClass:[UIButton class]] && btn.isSelected==YES ){
        btn.selected = NO;
        [self updateBtnBg:btn];
        [self removeSelectIndex:index];
        if( index == _currSelectedSingleBtnIndex ){
            _currSelectedSingleBtnIndex = -1;
        }
    }
}

@end
