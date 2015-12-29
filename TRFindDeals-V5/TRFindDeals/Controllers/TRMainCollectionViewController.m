//
//  TRMainCollectionViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRMainCollectionViewController.h"
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
#import "TRSearchViewController.h"

@interface TRMainCollectionViewController ()
//分类视图
@property (nonatomic, strong) TRNavLeftView *categoryView;
//区域视图
@property (nonatomic, strong) TRNavLeftView *regionView;
//排序视图
@property (nonatomic, strong) TRNavLeftView *sortView;
//排序视图控制器
@property (nonatomic, strong) TRSortViewController *sortViewController;
//分类视图控制器
@property (nonatomic, strong) TRCategoryViewController *categoryViewController;
//区域视图控制器
@property (nonatomic, strong) TRRegionViewController *regionViewController;
//主分类名字
@property (nonatomic, strong) NSString *selectedCategory;
//子分类名字
@property (nonatomic, strong) NSString *selectedSubCategory;
//城市名字
@property (nonatomic, strong) NSString *selectedCity;
//主区域名字
@property (nonatomic, strong) NSString *selectedRegion;
//子区域名字
@property (nonatomic, strong) NSString *selectedSubRegion;
//排序值
@property (nonatomic, assign) int selectedSort;
@end

@implementation TRMainCollectionViewController

static NSString * const reuseIdentifier = @"deal";

//懒加载分类视图控制器
- (TRCategoryViewController *)categoryViewController {
    if (!_categoryViewController) {
        _categoryViewController = [TRCategoryViewController new];
    }
    return _categoryViewController;
}

//懒加载区域视图控制器
- (TRRegionViewController *)regionViewController {
    if (!_regionViewController) {
        _regionViewController = [TRRegionViewController new];
    }
    return _regionViewController;
}
//懒加载排序视图控制器
- (TRSortViewController *)sortViewController {
    if (!_sortViewController) {
        _sortViewController = [TRSortViewController new];
    }
    return _sortViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    //创建左边的四个item
    [self setupLeftItems];
    
    //创建右边的两个item
    [self setupRightItems];
    
    //监听通知
    [self listenNotifications];
    
}

//移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 创建六个Item
- (void)setupRightItems {
    //地图item
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImage:@"icon_map" withHighLightedImage:@"icon_map_highlighted" withTarget:self withAction:@selector(clickMapItem)];
    //搜索item
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" withHighLightedImage:@"icon_search_highlighted" withTarget:self withAction:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

- (void)setupLeftItems {
    //logoItem
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    //取消点击
    logoItem.enabled = NO;
    
    //categoryItem
    self.categoryView = [TRNavLeftView navView];
    [self.categoryView.imageButton addTarget:self action:@selector(clickCategoryView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:self.categoryView];
    
    //regionItem
    self.regionView = [TRNavLeftView navView];
    [self.regionView.imageButton addTarget:self action:@selector(clickRegionView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:self.regionView];
    
    //sortItem
    self.sortView = [TRNavLeftView navView];
    //sortView上的button添加方法
    [self.sortView.imageButton addTarget:self action:@selector(clickSortView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:self.sortView];
    //添加四个item
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];
}

#pragma mark - 通知相关方法
- (void)listenNotifications {
    //城市(city)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:@"TRCityDidChange" object:nil];
    //区域(region)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidChange:) name:@"TRRegionDidChange" object:nil];
    //分类(category)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidChange:) name:@"TRCategoryDidChange" object:nil];
    //排序(sort)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:@"TRSortDidChange" object:nil];
}

- (void)cityDidChange:(NSNotification *)notification {
    //获取城市的名字
    self.selectedCity = notification.userInfo[@"TRCityName"];
    //发送请求(api+params+request)
    [self loadNewDeals];
}

- (void)regionDidChange:(NSNotification *)notification {
    //主区域模型对象
    TRRegion *region = notification.userInfo[@"TRRegion"];
    if ([region.name isEqualToString:@"全部"]) {
        self.selectedRegion = nil;
    } else {
        self.selectedRegion = region.name;
        //子区域的名字
        NSString *subRegion = notification.userInfo[@"TRSubRegion"];
        if ([subRegion isEqualToString:@"全部"]) {
            self.selectedSubRegion = self.selectedRegion;
        } else {
            self.selectedSubRegion = subRegion;
        }
    }
    
    //两个label
    self.regionView.mainLabel.text = [NSString stringWithFormat:@"%@-%@",self.selectedCity, self.selectedRegion];
    self.regionView.subLabel.text = self.selectedSubRegion;
    //两个图片
    [self.regionView.imageButton setImage:[UIImage imageNamed:@"btn_changeCity"] forState:UIControlStateNormal];
    [self.regionView.imageButton setImage:[UIImage imageNamed:@"btn_changeCity_selected"] forState:UIControlStateHighlighted];
    
    //发送请求
    [self loadNewDeals];
}
- (void)categoryDidChange:(NSNotification *)notification {
    //主分类模型对象TRCategory
    TRCategory *category = notification.userInfo[@"TRCategory"];

    //情况一:如果用户点击"全部分类",主分类设置为nil(用户没有点击分类视图)
    if ([category.name isEqualToString:@"全部分类"]) {
        self.selectedCategory = nil;
    } else {
        //主分类的名字
        self.selectedCategory = category.name;
        //情况二:不允许用户点击"全部"
        NSString *subCategory = notification.userInfo[@"TRSubCategory"];
        if ([subCategory isEqualToString:@"全部"]) {
            //把主分类的名字赋值子分类的名字
            self.selectedSubCategory = self.selectedCategory;
        } else {
            //把从通知获取的子分类赋值选择的子分类
            self.selectedSubCategory = subCategory;
        }
    }
    
    self.categoryView.mainLabel.text = self.selectedCategory;
    self.categoryView.subLabel.text = self.selectedSubCategory;
    [self.categoryView.imageButton setImage:[UIImage imageNamed:category.icon] forState:UIControlStateNormal];
    [self.categoryView.imageButton setImage:[UIImage imageNamed:category.highlighted_icon] forState:UIControlStateHighlighted];
    
    [self loadNewDeals];
}
- (void)sortDidChange:(NSNotification *)notification {
    TRSort *sort = notification.userInfo[@"TRSort"];
    self.selectedSort = [sort.value intValue];
    //设置两个label
    self.sortView.mainLabel.text = @"排序";
    self.sortView.subLabel.text = sort.label;
    //两个图片
    [self.sortView.imageButton setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    [self.sortView.imageButton setImage:[UIImage imageNamed:@"icon_sort_highlighted"] forState:UIControlStateHighlighted];
    
    [self loadNewDeals];
}


#pragma mark - 点中item的触发方法
- (void)clickCategoryView {
    //设置控制器对象的四个属性(iOS9+)
    self.categoryViewController.modalPresentationStyle = UIModalPresentationPopover;
    //设置弹出区域(sortView)
    self.categoryViewController.popoverPresentationController.sourceView = self.categoryView;
    //设置弹出具体的位置
    self.categoryViewController.popoverPresentationController.sourceRect = self.categoryView.bounds;
    //设置箭头的方向(any:自动找最优的箭头方向)
    self.categoryViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //present控制器对象
    [self presentViewController:self.categoryViewController animated:YES completion:nil];
}

- (void)clickRegionView {
    //设置控制器对象的四个属性(iOS9+)
    self.regionViewController.modalPresentationStyle = UIModalPresentationPopover;
    //设置弹出区域(sortView)
    self.regionViewController.popoverPresentationController.sourceView = self.regionView;
    //设置弹出具体的位置
    self.regionViewController.popoverPresentationController.sourceRect = self.regionView.bounds;
    //设置箭头的方向(any:自动找最优的箭头方向)
    self.regionViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //present控制器对象
    [self presentViewController:self.regionViewController animated:YES completion:nil];
}

- (void)clickSortView {
    //创建弹出控制器对象(懒加载)
    //设置控制器对象的四个属性(iOS9+)
    self.sortViewController.modalPresentationStyle = UIModalPresentationPopover;
    //设置弹出区域(sortView)
    self.sortViewController.popoverPresentationController.sourceView = self.sortView;
    //设置弹出具体的位置
    self.sortViewController.popoverPresentationController.sourceRect = self.sortView.bounds;
    //设置箭头的方向(any:自动找最优的箭头方向)
    self.sortViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //present控制器对象
    [self presentViewController:self.sortViewController animated:YES completion:nil];
}

- (void)clickMapItem {
    TRMapViewController *mapViewController = [TRMapViewController new];
    TRNavController *nav = [[TRNavController alloc] initWithRootViewController:mapViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)clickSearchItem {
    
    TRSearchViewController *searchViewController = [TRSearchViewController new];
    //传参数(城市名字:用户选择的城市)
    if (self.selectedCity) {
        searchViewController.cityName = self.selectedCity;
    } else {
        searchViewController.cityName = @"北京";
    }

    TRNavController *nav = [[TRNavController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 设置请求参数
- (void)settingRequestParams:(NSMutableDictionary *)params {
    //城市(必须)
    //用户选择城市
    if (self.selectedCity) {
        params[@"city"] = self.selectedCity;
    } else {
        //用户没有选择城市(默认推送城市;或者通过定位)
        params[@"city"] = @"北京";
    }
    
    //分类
    //用户选择分类
    if (self.selectedCategory) {
        //如果有子分类
        if (self.selectedSubCategory) {
            params[@"category"] = self.selectedSubCategory;
        } else {
            //没有子分类
            params[@"category"] = self.selectedCategory;
        }
    }
    //区域
    if (self.selectedRegion) {
        //如果有子区域
        if (self.selectedSubRegion) {
            params[@"region"] = self.selectedSubRegion;
        } else {
            params[@"region"] = self.selectedRegion;
        }
    }
    //排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort);
    }
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
