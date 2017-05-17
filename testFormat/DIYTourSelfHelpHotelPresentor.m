//
//  DIYTourSelfHelpHotelPresentor.m
//  驴妈妈出境游
//
//  Created by 贺嘉炜 on 2017/4/1.
//  Copyright © 2017年 贺嘉炜. All rights reserved.
//

#import "DIYTourSelfHelpHotelPresentor.h"
#import "RouteCjyDetailBaseViewModel.h"

#import "DIYTourHotelInfoTableViewCell.h"
#import "DIYTourPackageTitleCell.h"
#import "DIYTourPackageShowMoreCell.h"
#import "TourDepartureDateAndTouristsPresentor.h"

@import ReactiveCocoa;
@import LvmmModel;
@import LvmmMediator;

static CGFloat const FOOT_HEIGHT = 10;

@interface DIYTourSelfHelpHotelPresentor ()

@property (nonatomic, strong) NSMutableArray *contentViewModels;
/** 产品数据数组 */
@property (nonatomic, strong) NSArray<ProdPackageGroup *> *prodPackageGroups;

@property (nonatomic, strong) NSArray<ProductBranch *> *combHotelBranchVoList;

/** 拿到选择日期展示器 */
@property (nonatomic, weak) TourDepartureDateAndTouristsPresentor *departureDatePresentor;

@property (nonatomic, assign) DIYTourFreedomPackageHotelStyle style;
@end

@implementation DIYTourSelfHelpHotelPresentor

+ (instancetype)presentorWithProdPackageGroups:(NSArray<ProdPackageGroup *> *)prodPackageGroups
                        departureDatePresentor:(TourDepartureDateAndTouristsPresentor *)departureDatePresentor
                                         Style:(DIYTourFreedomPackageHotelStyle)style {
    DIYTourSelfHelpHotelPresentor *presentor = [[DIYTourSelfHelpHotelPresentor alloc] init];
    presentor.departureDatePresentor = departureDatePresentor;
    //这句要在前面，为酒店类型赋值
    presentor.style = style;
    presentor.prodPackageGroups = prodPackageGroups;
    return presentor;
}

+ (instancetype)presentorWithCombHotelBranchs:(NSArray<ProductBranch *> *)combHotelBranchVoList
                       departureDatePresentor:(TourDepartureDateAndTouristsPresentor *)departureDatePresentor
                                        Style:(DIYTourFreedomPackageHotelStyle)style {
    DIYTourSelfHelpHotelPresentor *presentor = [[DIYTourSelfHelpHotelPresentor alloc] init];
    presentor.departureDatePresentor = departureDatePresentor;
    //这句要在前面，为酒店类型赋值
    presentor.style = style;
    presentor.combHotelBranchVoList = combHotelBranchVoList;

    return presentor;
}

#pragma mark - Getter
- (NSArray<RouteCjyDetailBaseViewModel *> *)viewModels {
    //猜你喜欢section Header
    NSMutableArray *sectionsHotel = [NSMutableArray array];

    DIYTourPackageTitleCell *titleCell = [LVMM_ROUTE_CJY_BUNDLE loadNibNamed:@"DIYTourPackageTitleCell" owner:nil options:nil].firstObject;
    if (self.style == DIYTourFreedomPackageHotelStyleDefault) {
        titleCell.title = @"酒店";
    } else if (self.style == DIYTourFreedomPackageHotelStyleCombo) {
        titleCell.title = @"酒店套餐";
    }

    RouteCjyDetailBaseViewModel *titleCellVM = [[RouteCjyDetailBaseViewModel alloc] initWithCell:titleCell cellHeight:44];
    [sectionsHotel addObject:titleCellVM];

    [sectionsHotel addObjectsFromArray:self.contentViewModels];

    [sectionsHotel addObject:[[RouteCjyDetailBaseViewModel alloc] initClearSectionCellHeight:FOOT_HEIGHT]];

    return [sectionsHotel copy];
}

#pragma mark - Setter
/** 在下单页传入的是ProductBranch模型 */
- (void)setCombHotelBranchVoList:(NSArray<ProductBranch *> *)combHotelBranchVoList {
    _combHotelBranchVoList = combHotelBranchVoList;
    self.contentViewModels = [NSMutableArray array];
    for (ProductBranch *productBranch in combHotelBranchVoList) {

        //显示酒店或者酒店套餐的那个cell
        DIYTourHotelInfoTableViewCell *hotelInfoTableViewCell = [DIYTourHotelInfoTableViewCell cellWithStyle:self.style];
        hotelInfoTableViewCell.productBranch = productBranch;
        //如果是酒店套餐返回95，如果是普通酒店，返回85
        CGFloat cellHeight = self.style ? 95 : 85;
        RouteCjyDetailBaseViewModel *hotelInfoCellVM = [[RouteCjyDetailBaseViewModel alloc] initWithCell:hotelInfoTableViewCell cellHeight:cellHeight];
        [self.contentViewModels addObject:hotelInfoCellVM];
        //        combHotelBranch
    }
}

/** 在详情页传入的对象是ProdPackageGroup模型 */
- (void)setProdPackageGroups:(NSArray<ProdPackageGroup *> *)prodPackageGroups {
    _prodPackageGroups = prodPackageGroups;
    self.contentViewModels = [NSMutableArray array];
    NSInteger index = 0;
    //处理数据
    for (ProdPackageGroup *prodPackageGroup in prodPackageGroups) {
        prodPackageGroup.startDayArray = [prodPackageGroup.prodPackageGroupHotelVo.stayDays componentsSeparatedByString:@","];
        ProdPackageDetail *detail = [prodPackageGroup.prodPackageDetails objectAtIndex:prodPackageGroup.selectedPackageIndex];
        ProductBranch *branch = detail.productBranch;

        int start = 0;
        if ([LvmmUtil lvValidateNumber:[prodPackageGroup.startDayArray firstObject]]) {
            start = [[prodPackageGroup.startDayArray firstObject] intValue] - 1;
        }

        int end = 1;
        if ([LvmmUtil lvValidateNumber:[prodPackageGroup.startDayArray lastObject]]) {
            end = [[prodPackageGroup.startDayArray lastObject] intValue];
        }

        NSString *visitDate = self.departureDatePresentor.selectedProdGroupDateVo.specDate;
        //算出第几晚-第几晚
        NSString *selectedVisitDate = [NSDate lvStringFromStringFormatteryyyyMMddSeparateByHorizontal:visitDate withDays:start];
        NSString *selectedEndDate = [NSDate lvStringFromStringFormatteryyyyMMddSeparateByHorizontal:visitDate withDays:end];
        //将算出的内容组装数据
        branch.recommendGoodsBase1.selectedVisitDate = selectedVisitDate;
        branch.recommendGoodsBase1.selectedEndDate = selectedEndDate;
        //显示酒店或者酒店套餐的那个cell
        DIYTourHotelInfoTableViewCell *hotelInfoTableViewCell = [DIYTourHotelInfoTableViewCell cellWithStyle:self.style];
        hotelInfoTableViewCell.prodPackageGroup = prodPackageGroup;
        //如果是酒店套餐返回95，如果是普通酒店，返回85
        CGFloat cellHeight = self.style ? 95 : 85;
        RouteCjyDetailBaseViewModel *hotelInfoCellVM = [[RouteCjyDetailBaseViewModel alloc] initWithCell:hotelInfoTableViewCell cellHeight:cellHeight];
        [self.contentViewModels addObject:hotelInfoCellVM];

        DIYTourPackageShowMoreCell *showMoreCell = [LVMM_ROUTE_CJY_BUNDLE loadNibNamed:@"DIYTourPackageShowMoreCell" owner:nil options:nil].firstObject;
        // 酒套餐和酒店区分查看更多文案
        if (self.style == DIYTourFreedomPackageHotelStyleDefault) {
            showMoreCell.showMoreTxt = @"查看其他酒店";
        } else if (self.style == DIYTourFreedomPackageHotelStyleCombo) {
            showMoreCell.showMoreTxt = @"查看其他套餐";
        }
        showMoreCell.selectedSignal = [RACSubject subject];
        [showMoreCell.selectedSignal subscribeNext:^(id x) {
            TourDepartureDateAndTouristsPresentor *departurePresentor = self.departureDatePresentor;
            RouteProductVisitInfo visitInfo = departurePresentor.visitInfo;

            NSString *adultQuantity = [NSString stringWithFormat:@"%ld", visitInfo.adultQuantity];
            NSString *childQuantity = [NSString stringWithFormat:@"%ld", visitInfo.childQuantity];
            NSString *quantity = [NSString stringWithFormat:@"%ld", visitInfo.quantity];

            NSNumber *travelType = @(TravelType_CJY);
            NSNumber *categoryType = @(prodPackageGroup.categoryId);

            UIViewController *vc = [[LVMediator sharedMediator] LVMediator_RouteCjyChooseControllerWithAdultQuantity:adultQuantity
                                                                                                       ChildQuantity:childQuantity
                                                                                                            Quantity:quantity
                                                                                                          TravelType:travelType
                                                                                                   ProdPackageGroups:prodPackageGroups
                                                                                                        CategoryType:categoryType
                                                                                                            Delegate:self
                                                                                                               Index:@(index);
                                                                                                     RouteInputOrder:nil];

            [[LVAdapterManager currentNavigationService] pushVC:vc animated:YES];
        }];

        RouteCjyDetailBaseViewModel *showMoreCellVM = [[RouteCjyDetailBaseViewModel alloc] initWithCell:showMoreCell cellHeight:44];
        [self.contentViewModels addObject:showMoreCellVM];
        index++;
    }
}

@end
