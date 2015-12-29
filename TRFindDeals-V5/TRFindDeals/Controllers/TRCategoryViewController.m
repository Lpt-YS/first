//
//  TRCategoryViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCategoryViewController.h"
#import "TRDataManager.h"
#import "TRCategory.h"
#import "TRTableViewCell.h"

@interface TRCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
//存储所有分类数据
@property (nonatomic, strong) NSArray *categoryArray;
@end

@implementation TRCategoryViewController

- (NSArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [TRDataManager getAndParseCategory];
    }
    return _categoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置contentSize
    self.preferredContentSize = CGSizeMake(340, 480);
}

#pragma mark - tableView dataSource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        //左边
        return self.categoryArray.count;
    } else {
        //左边选中的行号
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoryArray[selectedRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //左边
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withHighlightedImageName:@"bg_dropdown_left_selected"];
        cell.category = self.categoryArray[indexPath.row];
        return cell;
    } else {
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withHighlightedImageName:@"bg_dropdown_right_selected"];
        //右边tableView
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoryArray[selectedRow];
        //设置cell的text
        cell.textLabel.text = category.subcategories[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //刷新右边tableView
        [self.subTableView reloadData];
        //没有子分类
        TRCategory *category = self.categoryArray[indexPath.row];
        if (category.subcategories.count == 0) {
            //发送通知(参数:category)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryDidChange" object:self userInfo:@{@"TRCategory" : category}];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        //有子分类(参数:分类模型对象和子分类名字)
        //左边和右边行号
        NSInteger leftRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger rightRow = [self.subTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoryArray[leftRow];
        NSString *subCategroyName = category.subcategories[rightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryDidChange" object:self userInfo:@{@"TRCategory":category, @"TRSubCategory":subCategroyName}];
        
        [self dismissViewControllerAnimated:YES completion:nil];
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

@end
