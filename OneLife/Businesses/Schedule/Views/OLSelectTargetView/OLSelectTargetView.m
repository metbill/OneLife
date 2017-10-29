//
//  OLSelectTargetView.m
//  OneLife
//
//  Created by hitomedia on 2017/10/26.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLSelectTargetView.h"
#import "UILabel+Ext.h"
#import "UIColor+Ext.h"
#import "UIView+LayoutMethods.h"
#import "OLTargetModel.h"

@interface OLSelectTargetView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation OLSelectTargetView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        [self.collectionView registerClass:[OLSelectTargetViewCell class] forCellWithReuseIdentifier:[self reuseCellId]];
    }
    return self;
}

- (void)setDatas:(NSArray<OLTargetModel *> *)datas{
    _datas = datas;
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iy = 5;
    self.collectionView.frame = CGRectMake(0, iy, self.width, self.height-2*iy);
}

#pragma mark - Private
- (NSString*)reuseCellId{
    return @"selectTargetViewReuseCellId";
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OLSelectTargetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseCellId] forIndexPath:indexPath];
    if( indexPath.row < self.datas.count ){
        cell.model = _datas[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[self superview] endEditing:YES];
    if( self.handleItemBlock ){
        self.handleItemBlock(indexPath.row);
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self superview] endEditing:YES];
}

#pragma mark __layoutDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

#pragma mark - Propertys

- (UICollectionView *)collectionView {
    if( !_collectionView ){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(77, 35);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


@end


@implementation OLSelectTargetViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self )
    {
        _titleL = [UILabel getLabelWithTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter frame:CGRectMake(0, 0, 0, 0) superView:self.contentView];
        
        _titleL.backgroundColor = [UIColor colorWithRgb_101_186_127];
        _titleL.layer.masksToBounds = YES;
        _titleL.layer.cornerRadius = 4;
    }
    return self;
}

- (void)setModel:(OLTargetModel *)model {
    _model = model;
    _titleL.text = model.name;
    
    if( model.timeType == OLTimeTypeWaste ){
        _titleL.backgroundColor = [UIColor colorWithRgb_236_78_59];
    }
    else if( model.timeType == OLTimeTypeSleep ){
        _titleL.backgroundColor = [UIColor colorWithRgb_0_168_226];
    }
    else if( model.timeType == OLTimeTypeRoutine ){
        _titleL.backgroundColor = [UIColor colorWithRgb_255_158_28];
    }else {
        //投资
//        _titleL.backgroundColor = []
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat xy = 5;
    _titleL.frame = CGRectMake(xy, xy, (self.width-xy*2), (self.height-xy*2));
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];

    UIColor *bdColor = [UIColor clearColor];
    
    if( selected ){
        bdColor = [UIColor colorWithRgb_229_28_35];
    }
    self.layer.masksToBounds = YES;
    self.layer.borderColor = bdColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
}

@end
