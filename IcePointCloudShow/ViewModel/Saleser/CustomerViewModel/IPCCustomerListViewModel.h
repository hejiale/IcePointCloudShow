//
//  IPCCustomerListViewModel.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/2/1.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCustomerListViewModel : NSObject

@property (nonatomic, copy) CompleteBlock    completeBlock;
//Search Customer Data
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString * searchWord;
//Refresh Status
@property (nonatomic, assign) LSRefreshDataStatus status;

@property (nonatomic, strong) NSMutableArray<IPCCustomerMode *> * customerArray;


/**
 Load Customer List Data
 */
- (void)queryCustomerList:(void(^)(NSError *error))complete;


/**
 Query Customer Detail
 @param complete
 */
- (void)queryCustomerDetail:(void(^)())complete;


/**
 Validation Member
 @param code
 @param complete
 */
- (void)validationMemberRequest:(NSString *)code Complete:(void(^)())complete;


/**
 Clear All Data
 */
- (void)resetData;


@end
