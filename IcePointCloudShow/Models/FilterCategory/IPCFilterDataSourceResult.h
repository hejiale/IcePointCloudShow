//
//  FilterDataSourceResult.h
//  IcePointCloudShow
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

@interface IPCFilterDataSourceResult : NSObject

- (void)parseFilterData:(id)responseObject
                  IsTry:(BOOL)isTry;

- (NSArray<NSString *> *)allCategoryName;

- (NSString *)categoryName:(NSInteger)index;

- (NSString *)payStatusCategoryName:(NSInteger)index;

- (NSArray *)allFilterKeys;

- (NSDictionary *)allFilterValues;


@end
