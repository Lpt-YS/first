//
//  TRBaseCollectionViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRBaseCollectionViewController.h"
#import "TRNavLeftView.h"
#import "UIBarButtonItem+TRBarItem.h"
#import "TRSortViewController.h"
#import "TRCategoryViewController.h"
#import "TRRegionViewController.h"
#import "TRCategory.h"
#import "TRRegion.h"
#import "TRSort.h"
#import "DPAPI.h"
#import "TRDataManager.h"
#import "TRCollectionViewCell.h"
#import "TRDeal.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "TRNavController.h"
#import "TRMapViewController.h"
#import "TRDetailViewController.h"
#import "UIView+AutoLayout.h"

@interface TRBaseCollectionViewController ()<DPRequestDelegate>

//订单数组(可变:适应上拉加载逻辑)
@property (nonatomic, strong) NSMutableArray *dealsArray;
//请求的页数
@property (nonatomic, assign) int page;
//最新发送请求对象
@property (nonatomic, strong) DPRequest *latestRequest;
//没有数据的imageView
@property (nonatomic, strong) UIImageView *nodataImageView;
@end

@implementation TRBaseCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

//懒加载初始化订单数组
- (NSMutableArray *)dealsArray {
    if (!_dealsArray) {
        _dealsArray = [NSMutableArray array];
    }
    return _dealsArray;
}

//设定collectionView的layout
- (id)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //itemSize
    layout.itemSize = CGSizeMake(305, 305);
    //inset
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //注册TRCollectionViewCell类(xib)
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    //加载上拉控件
    [self addRefreshControl];
    
    //创建nodataImageView
    [self setupNodataImageView];
}

- (void)setupNodataImageView {
    self.nodataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
    self.nodataImageView.hidden = YES;
    
    //加载
    [self.view addSubview:self.nodataImageView];
    //设置约束
    [self.nodataImageView autoCenterInSuperview];
}

#pragma mark - 上拉控件
- (void)addRefreshControl {
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
}

#pragma mark - 发送请求方法
//加载更多订单
- (void)loadMoreDeals {
    self.page++;
    [self sendRequestToServer];
}
//第一次发送请求
- (void)loadNewDeals {
    self.page = 1;
    [self sendRequestToServer];
}
//发送请求
- (void)sendRequestToServer {
    //api
    DPAPI *api = [DPAPI new];
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //设置发送请求的参数(子类设置参数)
    /**
     main视图控制器设置参数:city/sort/region/category
     search视图控制器设置参数:city/keyword
     */
    [self settingRequestParams:params];

    //page
    params[@"page"] = @(self.page);
    
    NSLog(@"发送的参数为:%@", params.allValues);
    //request
    self.latestRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}
#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSLog(@"result:%@", result);
    //如果老的请求,直接返回不响应
    if (self.latestRequest != request) {
        return;
    }
    
    NSArray *resultArray = [TRDataManager parseDealsResult:result];
    if (self.page == 1) {
        //第一次发送请求
        [self.dealsArray removeAllObjects];
    }
    //20条数据添加到dealsArray
    [self.dealsArray addObjectsFromArray:resultArray];
    
    //刷新collectionView
    [self.collectionView reloadData];
    
    //停止上拉控件的动画
    [self.collectionView.mj_footer endRefreshing];
    
    //设置nodataImageView
    self.nodataImageView.hidden = (self.dealsArray.count != 0);
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"失败:%@", error.userInfo);
    
    //创建MBProgressHUD控件
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置属性
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"网络繁忙,请稍后再试";
    hud.margin = 10;
    //延迟时间
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
    
    //停止上拉控件的动画
    [self.collectionView.mj_footer endRefreshing];
}



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

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dealsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    //设置cell的6个属性(数据源)
    TRDeal *deal = self.dealsArray[indexPath.row];
    
    if ([deal.title isEqualToString:@"管氏翅吧(洋桥店)"]) {
        NSLog(@"hahahha");
    }
    
    cell.deal = deal;
    return cell;
}
#pragma mark <UICollectionViewDelegate>
//点中item的触发方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TRDetailViewController *detailViewController = [TRDetailViewController new];
    //数据源
    TRDeal *deal = self.dealsArray[indexPath.row];
    
    //h5的url传参
    detailViewController.dealUrlStr = deal.deal_h5_url;
    
    //显示
    [self presentViewController:detailViewController animated:YES completion:nil];
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
