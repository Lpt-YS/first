//
//  TRRegionViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRRegionViewController.h"
#import "TRDataManager.h"
#import "TRRegion.h"
#import "TRTableViewCell.h"
#import "TRCityGroupViewController.h"

@interface TRRegionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
//存储某个城市的所有区域
@property (nonatomic, strong) NSArray *regionArray;
@end

@implementation TRRegionViewController
////懒加载初始化区域数组
//- (NSArray *)regionArray {
//    if (!_regionArray) {
//#warning TODO: 指定城市名字
//        _regionArray = [TRDataManager getRegionsByCityName:@"北京"];
//    }
//    return _regionArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置视图控制器的contentSize
    self.preferredContentSize = CGSizeMake(340, 560);
    
    //监听通知(添加观察者)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCityChange:) name:@"TRCityDidChange" object:nil];
}

- (void)didCityChange:(NSNotification *)noti {
    //noti获取城市名字
    NSString *cityName = noti.userInfo[@"TRCityName"];
    //更新数据源
    self.regionArray = [TRDataManager getRegionsByCityName:cityName];
    //刷新tableView
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}

- (IBAction)changeCity:(id)sender {

    TRCityGroupViewController *cityGroupViewController = [TRCityGroupViewController new];
    //设置弹出控制器的style
    cityGroupViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:cityGroupViewController animated:YES completion:nil];
    
}

#pragma mark - tableView datasource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        //左边的tableView(主区域的个数)
        return self.regionArray.count;
    } else {
        //右边的tableView
        //获取左边选中的行号
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionArray[selectedRow];
        return region.subregions.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //重用
        //cell背景图片
        //cell文本
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withHighlightedImageName:@"bg_dropdown_left_selected"];
        //数据源
        TRRegion *region = self.regionArray[indexPath.row];
        //cell的text
        cell.textLabel.text = region.name;
        //cell accessoryView
        if (region.subregions.count > 0) {
            //有子区域(右箭头)
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        } else {
            cell.accessoryView = nil;
        }
        return cell;
    } else {
        //重用
        //cell背景图片
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withHighlightedImageName:@"bg_dropdown_right_selected"];
        //cell文本
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionArray[selectedRow];
        cell.textLabel.text = region.subregions[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //刷新右边tableView
        [self.subTableView reloadData];
        //没有子区域
        TRRegion *region = self.regionArray[indexPath.row];
        if (region.subregions.count == 0) {
            //发送通知(参数:region)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRRegion" : region}];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        //有子区域(参数:区域模型对象和子区域名字)
        //左边和右边行号
        NSInteger leftRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger rightRow = [self.subTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionArray[leftRow];
        NSString *subRegionName = region.subregions[rightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRRegion":region, @"TRSubRegion":subRegionName}];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}






@end
