//
//  TRMapViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "UIBarButtonItem+TRBarItem.h"
#import "TRDataManager.h"
#import "TRDeal.h"
#import "TRAnnotation.h"
#import "TRBusiness.h"

@interface TRMapViewController ()<MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
//发送服务器的城市名字
@property (nonatomic, strong) NSString *cityName;
@end

@implementation TRMapViewController

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加关闭的item
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_back" withHighLightedImage:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;

    self.manager = [CLLocationManager new];
    //iOS8+ (Info.plist)
    [self.manager requestWhenInUseAuthorization];
    
    //假定用户允许定位
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置delegate
    self.mapView.delegate = self;
}

- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //设定参数; 发送请求
    //city(根据反地理编码:北京/上海/深圳)
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *cityName = placemark.addressDictionary[@"City"];
        //北京市 --> 北京(前提:语言中文的)
        self.cityName = [cityName substringToIndex:cityName.length - 1];
    }];
    //手动调用region方法(设定参数+发送请求)
    [self mapView:mapView regionDidChangeAnimated:YES];
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //如果城市名字为空,直接返回
    if (!self.cityName) {
        return;
    }
    
    //设定参数(city/地图中心经纬度/半径);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.cityName;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @3000;
    //发送请求
    DPAPI *api = [DPAPI new];
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //重用机制
    static NSString *identifier = @"annotation";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annoView) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annoView.canShowCallout = YES;
    }
    
    TRAnnotation *anno = (TRAnnotation *)annotation;
    annoView.annotation = anno;
    annoView.image = anno.image;
    
    return annoView;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"result:%@", result);
    //需求:服务器返回数据;获取经纬度;添加大头针对象
    NSArray *resultArray = [TRDataManager parseDealsResult:result];
    for (TRDeal *deal in resultArray) {
        //businessArray[Dic, Dic] -->  businessArray[TRBusiness, TRBusiness]
        NSArray *businessArray = [TRDataManager getAndParseBusiness:deal];
        //给定订单模型对象,返回该订单所属的分类模型对象
        TRCategory *category = [TRDataManager getCategoryWithDeal:deal];
        for (TRBusiness *business in businessArray) {
            //添加大头针对象到地图视图上
            TRAnnotation *annotation = [TRAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotation.title = business.name;
            annotation.subtitle = deal.desc;
            //设置图片
            if (category) {
                annotation.image = [UIImage imageNamed:category.map_icon];
            } else {
                NSLog(@"无法找到对应的分类");
            }
            
            //排除已经添加好的大头针对象
            if ([self.mapView.annotations containsObject:annotation]) {
                continue;
            }
            
            [self.mapView addAnnotation:annotation];
        }
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"失败:%@", error.userInfo);
}









@end
