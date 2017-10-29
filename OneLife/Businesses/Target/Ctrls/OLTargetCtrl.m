//
//  OLTargetCtrl.m
//  OneLife
//
//  Created by wkun on 2017/10/21.
//  Copyright © 2017年 wkun. All rights reserved.
//

#import "OLTargetCtrl.h"
#import "UIViewController+Ext.h"
#import "OLTargetModel.h"
#import "OLTargetCell.h"
#import "OLAddTargetCtrl.h"

@interface OLTargetCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation OLTargetCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelf];
    self.navigationItem.title = @"目标";
//    [self addRightBarItemWithTitle:@"+" imgName:@"add_white_16*16"
//                        selImgName:nil
//                            action:@selector(handleAddTarget)
//                     textAlignment:NSTextAlignmentRight];
    [self addRightBarItemWithTitle:@"+" imgName:nil selImgName:nil action:@selector(handleAddTarget) titleColor:[UIColor colorWithRgb102] titleFont:[UIFont systemFontOfSize:28]];
    
    [self loadDatas];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)loadDatas{
    
    _datas =
    [self.dataProcess targetListWithType];
    [self.tableView reloadData];
    
    return;
    NSMutableArray *arr = [NSMutableArray new];
    NSArray *dates = @[@"65/10000h",@"900/1000h",@"95/200h",@"1025/10000h",@"25/1500h"];
    NSArray *cnts = @[@"吃饭",@"读财务自由书单，简七理财",@"睡觉",@"打豆豆",@"都都是谁"];
    for( NSUInteger i=0;i <5; i++ ){
        
        OLTargetModel *sm = [OLTargetModel new];
        sm.needHours = dates[i];
        sm.name = cnts[i];//@"去奥林匹克骑行";
        sm.endDate = @"截止时间：2020-10-10";
        sm.status = i%2==0?OLTargetStatusCompleted:OLTargetStatusContinue;
        if( i==4 ) sm.status = OLTargetStatusExpired;
        [arr addObject:sm];
    }
    _datas = arr;
    [self.tableView reloadData];
}

#pragma mark - Public

- (void)reloadDatas{
    [self loadDatas];
}

#pragma mark - TouchEvents

- (void)handleAddTarget{
    [self pushViewCtrl:[OLAddTargetCtrl new]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseid = @"reuseid";
    OLTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if( !cell ){
        cell = [[OLTargetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = (OLTargetModel*)[self modelAtIndex:indexPath.row datas:_datas modelClass:[OLTargetModel class]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if([self isShowRecord]){
//        OLRecordTimeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell->_timeIntevalL.hidden = !cell->_timeIntevalL.isHidden;
//    }
//    else{
//        OLScheduleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        OLScheduleStatus status = cell.model.scheduleStatus;
//        OLScheduleStatus toStatus = (status==OLScheduleStatusTobeDone)?OLScheduleStatusCompleted:OLScheduleStatusTobeDone;
//        
//        [_scheduleData updateModelStatus:toStatus atIndex:indexPath.row];
//        [tableView reloadData];
//    }
}


#pragma mark - Propertys


- (UITableView *)tableView {
    if( !_tableView ){
        _tableView = [[UITableView alloc] init];
        CGFloat iy = NAVGATION_VIEW_HEIGHT;
        CGFloat ih = SCREEN_HEIGHT-iy;
        _tableView.frame = CGRectMake(0, iy, SCREEN_WIDTH, ih);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
