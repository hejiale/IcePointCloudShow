//
//  IPCPayOrderRequestManager.m
//  IcePointCloudShow
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderRequestManager.h"
#import "IPCPayOrderParameter.h"

@implementation IPCPayOrderRequestManager

+(void)payOrderWithCurrentStatus:(NSString *)currentStatus EndStatus:(NSString *)endStatus SuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    IPCPayOrderParameter * parameter = [[IPCPayOrderParameter alloc]init];
    
    [self postRequest:[parameter orderParameterWithCurrentStatus:currentStatus EndStatus:endStatus] RequestMethod:PayOrderRequest_PayOrderWithStatus CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure
{
    NSDictionary * responseParameter = @{@"pageNo":@(1),
                                         @"maxPageSize":@(10000),
                                         @"keyWord":keyword,
                                         @"isOnJob":@"false",
                                         @"storeId" : [IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @""
                                         };
    [self postRequest:responseParameter RequestMethod:PayOrderRequest_EmployeeList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryIntegralRuleWithSuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:PayOrderRequest_IntegralRule CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryPayListTypeWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure
{
    [self postRequest:nil RequestMethod:PayOrderRequest_ListPayType CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getCompanyConfigWithSuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:PayOrderRequest_CompanyConfig CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryListPrototypeOrderWithPage:(NSInteger)page Keyword:(NSString *)keyword SuccessBlock:(void (^)(id responseValue))success FailureBlock:(void (^)(NSError *))failure
{
    NSDictionary * parameter = @{
                                 @"filterCols":
                                     @[
                                         @{@"colName":@"orderStatus",
                                           @"opType": @"IN",
                                           @"dataType":@"ENUM",
                                           @"values":@"PROTOTYPE"}
                                         ] ,
                                 @"pageNo": @(page),
                                 @"pageLimit": @"15",
                                 @"orderObjectType": @"FOR_SALES",
                                 @"storeId" : [IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @""
                                 };
    
    [self postRequest:parameter RequestMethod:PayOrderRequest_ListOrderType CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getProductsListWithPage:(NSInteger)page StoreId:(NSString *)storeId Keyword:(NSString *)keyword Type:(NSString *)type SuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    NSDictionary * parameter = @{@"orderType":@"FOR_SALES",
                                 @"storeId": [IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @"",
                                 @"pageSize": @"200",
                                 @"pageIndex": @(page),
                                 @"nameKeyword" : keyword,
                                 @"productType" : type,
                                 @"brandKeyword": @"",
                                 @"supplierToCompany" : @""};
    [self postRequest:parameter RequestMethod:PayOrderRequest_GoodsList CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
