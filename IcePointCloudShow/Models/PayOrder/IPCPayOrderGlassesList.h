//
//  IPCPayOrderGlassesList.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/24.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderGlassesList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCSaleserProduct *> *glassesList;
@property (nonatomic, assign, readwrite) NSInteger  totalCount;

- (instancetype)initWithResponseValue:(id)responseValue;

@end
