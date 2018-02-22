//
//  IPCPayOrderRequestManager.h
//  IcePointCloudShow
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequest.h"

@interface IPCPayOrderRequestManager : IPCRequest

+ (void)payOrderWithCurrentStatus:(NSString *)currentStatus
                        EndStatus:(NSString *)endStatus
                     SuccessBlock:(void (^)(id responseValue))success
                     FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY EMPLOYE
 *
 *  @param keyword
 *  @param success
 *  @param failure
 */
+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure;


/**
 Query Integral Rule

 @param success 
 @param failure
 */
+ (void)queryIntegralRuleWithSuccessBlock:(void (^)(id responseValue))success
                             FailureBlock:(void (^)(NSError *error))failure;


/**
 Query Pay List Type

 @param success
 @param failure 
 */
+ (void)queryPayListTypeWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure;


/**
 Get CompanyConfig

 @param success
 @param failure 
 */
+ (void)getCompanyConfigWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure;



/**
 Query List Order Type

 @param page
 @param success
 @param failure 
 */
+ (void)queryListPrototypeOrderWithPage:(NSInteger)page
                                Keyword:(NSString *)keyword
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError *))failure;


/**
 Get Goods List

 @param page
 @param storeId
 @param keyword
 @param type
 @param success
 @param failure 
 */
+ (void)getProductsListWithPage:(NSInteger)page
                        StoreId:(NSString *)storeId
                        Keyword:(NSString *)keyword
                           Type:(NSString *)type
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *))failure;

@end
