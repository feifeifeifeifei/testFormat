//
//  ViewController.m
//  testFormat
//
//  Created by zhaofeiyu on 2017/4/13.
//  Copyright © 2017年 zhaofeiyu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *sellPrice;

@property (nonatomic, copy) NSString *displayType;

@property (nonatomic, assign) BOOL max;

@property (nonatomic, assign) BOOL circusActFlag;

@property (nonatomic, copy) NSString *a;

@property (nonatomic, copy) NSString *b;

@property (nonatomic, copy) NSString *c;

@property (nonatomic, copy) NSString *d;

@property (nonatomic, copy) NSString *e;

@property (nonatomic, copy) NSString *f;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (1) {
        return;
    }
    RouteHeaderViewModel *numberModel = [RouteHeaderViewModel generateRouteHeaderViewModelWithDataSource:@{
        @"title": [NSString stringWithFormat:@"交通%zd", i + 1],
        @"bgColor": [UIColor whiteColor],
        @"hideBottomLine": @1,
        @"totalHeight": @(40)
    }];
    
    UIViewController *vc = [[LVMediator sharedMediator]LVMediator_RouteCjyChooseControllerWithAdultQuantity:adultQuantity ChildQuantity:childQuantity Quantity:quantity TravelType:travelType ProdPackageGroups:prodPackageGroups CategoryType:categoryType Delegate:self Index:@(row) RouteInputOrder:self.dataManager.routeInputOrder];
}

@end
