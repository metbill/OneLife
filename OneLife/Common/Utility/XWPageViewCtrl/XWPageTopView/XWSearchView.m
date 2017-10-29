//
//  XWSearchView.m
//  XWPageViewControllerDemo
//
//  Created by hitomedia on 16/7/29.
//  Copyright © 2016年 hitu. All rights reserved.
//

#import "XWSearchView.h"
#import "UIColor+XW.h"

@interface XWSearchView()
@end

@implementation XWSearchView

@synthesize searchBar = _searchBar;

- (instancetype)init{
    self = [super init ];
    if( self ){
        [self initSelf];
    }
    return self;
}

- (void)initSelf{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake(0, 0, size.width, 46);
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.02;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    CGFloat ih = 27+10;
    self.searchBar.frame = CGRectMake(0, (CGRectGetHeight(self.frame)-ih)/2, size.width, ih);
    [self setSearchTextFieldBackgroundColor:[UIColor colorWithR:240 G:239 B:244]];
    [self addSubview:self.searchBar];
}

- (void)setSearchBarTextFieldBackColor:(UIColor *)searchBarTextFieldBackColor{
    _searchBarTextFieldBackColor = searchBarTextFieldBackColor;
    [self setSearchTextFieldBackgroundColor:searchBarTextFieldBackColor];
}

- (void)dismissKeyBoard{
    [self.searchBar resignFirstResponder];
}

- (void)inputAccessView{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
}

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    
    BOOL IsiOS7OrLater = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
    if (IsiOS7OrLater) {
        // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
        self.searchBar.barTintColor = [UIColor whiteColor];
        searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
        for (UIView *subView in self.searchBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchTextField = subView;
            }
        }
    }
    searchTextField.backgroundColor = backgroundColor;
}

- (UISearchBar *)searchBar{
    if( !_searchBar)
    {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder= @"请输入车站名字、首字母、全拼或简拼";
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        _searchBar.searchBarStyle = UIBarStyleBlackOpaque;

        UITextField *tf = [_searchBar valueForKey:@"_searchField"];
        tf.font = [UIFont systemFontOfSize:14.0];
        
        //移除背景
        for (UIView *view in _searchBar.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _searchBar;
}


@end






