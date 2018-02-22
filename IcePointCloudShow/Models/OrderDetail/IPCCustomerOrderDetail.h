//
//  CustomOrderDetailObject.h
//  IcePointCloudShow
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayRecord.h"

@class IPCCustomerOrderInfo;
@interface IPCCustomerOrderDetail : NSObject

+ (IPCCustomerOrderDetail *)instance;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCSaleserProduct *> *  products;
@property (nonatomic, strong, readwrite) NSMutableArray<IPCPayRecord *> * recordArray;
@property (nonatomic, strong, readwrite) IPCCustomerOrderInfo               *  orderInfo;
@property (nonatomic, strong, readwrite) IPCOptometryMode                    *  optometryMode;
@property (nonatomic, strong, readwrite) IPCEmployee                              *  employee;

- (void)parseResponseValue:(id)responseValue;

@end

@interface IPCCustomerOrderInfo : NSObject

@property (nonatomic, copy, readonly) NSString *  customerId;
@property (nonatomic, copy, readonly) NSString *  status;
@property (nonatomic, copy, readonly) NSString *  orderCode;
@property (nonatomic, assign, readwrite) double    totalPrice;
@property (nonatomic, copy, readonly) NSString *  orderNumber;
@property (nonatomic, copy, readonly) NSString *  orderTime;
@property (nonatomic, copy, readonly) NSString *  operatorName;
@property (nonatomic, copy, readonly) NSString *  finishTime;
@property (nonatomic, copy, readonly) NSString *  dispatchTime;
@property (nonatomic, copy, readonly) NSString *  remark;
@property (nonatomic, assign, readonly) NSInteger    integralGiven;
@property (nonatomic, assign, readwrite) double   totalDonationAmount;
@property (nonatomic, assign, readwrite) BOOL     isPackUpOptometry;
@property (nonatomic, assign, readwrite) double   totalSuggestAmount;
@property (nonatomic, assign, readwrite) double   totalPayAmount;
@property (nonatomic, assign, readwrite) double    remainAmount;//订单详情中剩余付款金额
@property (nonatomic, copy, readonly) NSString * auditResult;
@property (nonatomic, copy, readonly) NSString * auditStatus;
@property (nonatomic, copy, readonly) NSString *optometryId;

@end



