//
//  TSTableCtrl.m
//  HiTravelService
//
//  Created by hitomedia on 2017/4/18.
//  Copyright © 2017年 hitumedia. All rights reserved.
//

#import "TSTableCtrl.h"
#import "UIView+LayoutMethods.h"
#import "UIColor+Ext.h"
#import "TSCellModel.h"
#import "TSTableCell.h"
#import "HTTableView.h"

@interface TSTableCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *naviBgView;
@property (nonatomic, strong) NSString *cellClassName;
@end

@implementation TSTableCtrl

#pragma mark - View Lifes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRgb_240_239_244];
}

#pragma mark - Public 
- (void)tc_registerCellClass:(NSString *)className{
    if( [className isKindOfClass:[NSString class]] ){
        _cellClassName = className;
    }
}

- (void)tc_reloadData{
    [self.tableView reloadData];
}

#pragma mark - Private
-(TSCellModel*)modelAtIndexPath:(NSIndexPath*)indexPath{
    if( self.datas.count > indexPath.row ){
        TSCellModel *cm  = self.datas[indexPath.row];
        if( [cm isKindOfClass:[TSCellModel class]] ){
            return cm;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseId = @"tstablecellreuseid";
    TSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if( cell==nil ){
        Class cellClass = NSClassFromString(_cellClassName);
        if( cellClass == nil ){
            cellClass = [TSTableCell class];
            NSLog(@"TSTableCtrl---err:no register cell class name,\nplase register cellclassname");
        }
//        if( self.cellParameter ){
            cell = [[cellClass alloc] initWithReuseId:reuseId parameter:self.cellParameter];
//        }else
//            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.model = [self modelAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self modelAtIndexPath:indexPath].height;
    if( height <= 0){
        NSLog(@"TSTableCtrl---err:model.height <=0");
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if( _delegate && [_delegate respondsToSelector:@selector(tableCtrl:selectCellAtIndex:)] ){
        [_delegate tableCtrl:self selectCellAtIndex:indexPath.row];
    }
}


#pragma mark - Property

- (UIView *)naviBgView {
    if( !_naviBgView ){
        UIView *bgView = [[UIView alloc] init];
        CGFloat navH = NAVGATION_VIEW_HEIGHT;
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, navH);
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        _naviBgView = bgView;
    }
    return _naviBgView;
}

- (UITableView *)tableView {
    if( !_tableView ){
        _tableView = [[HTTableView alloc] init];
        CGFloat iy = self.naviBgView.bottom;
        _tableView.frame = CGRectMake(0, iy, SCREEN_WIDTH, SCREEN_HEIGHT-iy);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

@implementation TSTableCtrlTheme
@end


