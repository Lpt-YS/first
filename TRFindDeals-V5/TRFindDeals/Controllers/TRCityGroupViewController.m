//
//  TRCityGroupViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCityGroupViewController.h"
#import "TRDataManager.h"
#import "TRCityGroup.h"

@interface TRCityGroupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *cityGroupTableView;
//存储城市组
@property (nonatomic, strong) NSArray *cityGroupArray;
@end

@implementation TRCityGroupViewController
- (NSArray *)cityGroupArray {
    if (!_cityGroupArray) {
        _cityGroupArray = [TRDataManager getAndParseCityGroup];
    }
    return _cityGroupArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)clickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView DataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //重用机制
    static NSString *identifier = @"cityGroup";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //cell的text
    TRCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [self.cityGroupArray valueForKeyPath:@"title"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (TRCityGroup *cityGroup in self.cityGroupArray) {
        [array addObject:cityGroup.title];
    }
    return [array copy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    //发送通知(参数:城市名字)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCityDidChange" object:self userInfo:@{@"TRCityName" : cityGroup.cities[indexPath.row]}];
    //dismiss收回
    [self dismissViewControllerAnimated:YES completion:nil];
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
