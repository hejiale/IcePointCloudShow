//
//  IPCSaleserProduct.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/25.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCSaleserProduct : NSObject

@property (nonatomic, copy, readonly) NSString * prodName;
@property (nonatomic, copy, readonly) NSString * prodType;
@property (nonatomic, copy, readonly) NSString * prodId;
@property (nonatomic, copy, readonly) NSString * prodCode;

@property (nonatomic, assign, readonly) BOOL      batchAdd;
@property (nonatomic, assign, readonly) double    suggestPrice;
@property (nonatomic, assign, readwrite) double   updatePrice;//选择规格后的价格

///OrderDetail Product
@property (nonatomic, assign, readonly) NSInteger productCount;//The order quantity
@property (nonatomic, copy, readonly) NSString *   thumbnailURL;
@property (nonatomic, assign, readonly) double     afterDiscountPrice;//折后价
@property (nonatomic, assign, readonly) double     afterIntegralDeductionPrice;//折后总价
@property (nonatomic, copy, readonly) NSString *   batchDegree;//batchdegree
@property (nonatomic, copy, readonly) NSString *   sph;//SPH
@property (nonatomic, copy, readonly) NSString *   cyl;//CYL

- (IPCTopFilterType)filterType;

@end
