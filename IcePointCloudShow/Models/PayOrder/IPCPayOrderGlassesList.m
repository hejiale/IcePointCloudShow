//
//  IPCPayOrderGlassesList.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/24.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderGlassesList.h"

@implementation IPCPayOrderGlassesList

- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        [self.glassesList removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            id listValue = responseValue[@"resultList"];
            if ([listValue isKindOfClass:[NSArray class]] && listValue) {
                [listValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ( ![obj isKindOfClass:[NSNull class]]) {
                        IPCSaleserProduct * glasses = [IPCSaleserProduct mj_objectWithKeyValues:obj];
                        [self.glassesList addObject:glasses];
                    }
                }];
            }
            self.totalCount = [responseValue[@"pageCount"] integerValue];
        }
    }
    return self;
}


- (NSMutableArray<IPCSaleserProduct *> *)glassesList{
    if (!_glassesList)
        _glassesList = [[NSMutableArray alloc]init];
    return _glassesList;
}

@end
