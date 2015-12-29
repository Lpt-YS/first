//
//  TRSearchViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRSearchViewController.h"
#import "UIBarButtonItem+TRBarItem.h"

@interface TRSearchViewController ()<UISearchBarDelegate>

@end

@implementation TRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //item
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_back" withHighLightedImage:@"icon_back_highligted" withTarget:self withAction:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
    //searchBar
    UISearchBar *bar = [UISearchBar new];
    bar.placeholder = @"请输入搜索关键字";
    bar.delegate = self;
    //添加
    self.navigationItem.titleView = bar;
    
    //设置view的颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SearchBarDelegate
//监听用户点击软键盘的搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //发送请求
    [self loadNewDeals];
    
    //键盘收回
    [searchBar resignFirstResponder];
}

//实现父类声明的设置参数的方法
- (void)settingRequestParams:(NSMutableDictionary *)params {
    //city
    params[@"city"] = self.cityName;
    //keyword
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}





@end
