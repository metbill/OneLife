//
//  XWPageViewCtrl.m
//  XWPageViewControllerDemo
//
//  Created by hitomedia on 16/7/29.
//  Copyright © 2016年 hitu. All rights reserved.
//

#import "XWPageViewCtrl.h"
#import "XWPageTopView.h"
#import "XWPageViewAppearance.h"

@interface XWPageViewCtrl ()<UIScrollViewDelegate,XWPageTopViewDelegate>

@end

@implementation XWPageViewCtrl{
    BOOL _showSearchView;               //是否显示搜索视图,默认为NO
    NSArray *_controllers;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if( self ){
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    
//    [self initData];
}

- (void)initData{
    _showSearchView = NO;
    _apearance = [[XWPageViewAppearance alloc] init];
}

#pragma mark - View Life Cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Public Methods

- (void)resetViewCtrls:(NSArray<UIViewController *> *)ctrls titles:(NSArray<NSString *> *)titles{
    if( ctrls.count != titles.count  || ctrls.count <= 0 ) return;
    
    self.topView.itemTitles = titles;
    
    _controllers = ctrls;
    
    CGFloat contentSizeW = 0;
    for( int i=0; i<MIN(ctrls.count, titles.count); i++){
        UIViewController *ctrl = ctrls[i];
        
        [self addChildViewController:ctrl];
        [self.scrollView addSubview:ctrl.view];
        
        CGRect of = ctrl.view.frame;
        of.origin.x = ctrl.view.frame.size.width * i;
        of.size.height = CGRectGetHeight(_scrollView.frame);
        ctrl.view.frame = of;
        
        contentSizeW += ctrl.view.frame.size.width;
    }
    
    self.scrollView.contentSize = CGSizeMake(contentSizeW, CGRectGetHeight(_scrollView.frame));
    CGFloat offsetX = self.apearance.currItemIndex *(contentSizeW/titles.count);
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0)];
}

#pragma mark - Private Methods

- (void)scrollToPage:(NSUInteger)index{
    if( _delegate && [_delegate respondsToSelector:@selector(pageViewCtrl:scrollToPage:)] ){
        [_delegate pageViewCtrl:self scrollToPage:index];
    }
}


- (void)scrollFromPage:(NSUInteger)index{
    if( _delegate && [_delegate respondsToSelector:@selector(pageViewCtrl:scrollFromPage:)] ){
        [_delegate pageViewCtrl:self scrollFromPage:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self scrollFromPage:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat percent = (scrollView.contentOffset.x )/(scrollView.contentSize.width);    
    [self.topView scrollLineViewWithPercent:percent];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSUInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self scrollToPage:index];
}

#pragma mark - XWPageTopViewDelegate

- (void)pageTopViewHandleItem:(UIButton *)item itemIndex:(NSUInteger)index{

    [self scrollViewWillBeginDragging:self.scrollView];
    
    CGFloat iw = CGRectGetWidth(self.scrollView.frame);
    CGFloat desOffx = index*iw;
    
    [self.scrollView setContentOffset:CGPointMake(desOffx, 0) animated:YES];
    
    [self scrollToPage:index];
}

- (void)pageTopView:(XWPageTopView *)ptView searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if( _delegate && [_delegate respondsToSelector:@selector(pageViewCtrl:searchTextDidChange:)] ){
        
        NSUInteger idx = [_controllers indexOfObject:_delegate];
        [self.scrollView setContentOffset:CGPointMake(idx*self.scrollView.frame.size.width, 0)];
        
        [_delegate pageViewCtrl:self searchTextDidChange:searchText];
    }
}

- (void)pageTopView:(XWPageTopView *)ptView searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if( _delegate && [_delegate respondsToSelector:@selector(pageViewCtrlSearchBtnClicked:)] ){
        [_delegate pageViewCtrlSearchBtnClicked:self];
    }
}

#pragma mark - Propertys

- (UIScrollView *)scrollView{
    if( !_scrollView ){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        CGFloat iy = CGRectGetMaxY(self.topView.frame);
        _scrollView.frame = CGRectMake(0, iy, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-iy);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;

        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (XWPageTopView *)topView {
    if( !_topView ){
        _topView = [[XWPageTopView alloc] init];
        CGFloat iy = 0;
        CGFloat ih = 80;

        iy = self.apearance.topViewOriginY;
        ih = self.apearance.topViewHeight;
        
        _topView.frame = CGRectMake(0, iy, CGRectGetWidth(self.view.frame), ih);
        _topView.showSearchView = YES;
        _topView.delegate = self;
        _topView.apearance = self.apearance;
        
        [self.view addSubview:_topView];
    }
    return _topView;
}

@end







