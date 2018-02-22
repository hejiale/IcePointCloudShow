//
//  CustomerOrderListObject.h
//  IcePointCloudShow
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerOrderMode;
@interface IPCCustomerOrderList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomerOrderMode *> * list;
@property (nonatomic, assign, readwrite) NSInteger  totalCount;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerOrderMode : NSObject

@property (nonatomic, copy, readonly) NSString * orderCode;
@property (nonatomic, copy, readonly) NSString * orderDate;
@property (nonatomic, assign, readonly) double   orderPrice;
@property (nonatomic, copy, readonly)  NSString *  empName;
@property (nonatomic, copy, readonly) NSString *  contactorName;
@property (nonatomic, copy, readonly) NSString *  contactorPhone;

@end

