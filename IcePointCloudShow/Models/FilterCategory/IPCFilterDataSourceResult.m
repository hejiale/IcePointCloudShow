//
//  FilterDataSourceResult.m
//  IcePointCloudShow
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCFilterDataSourceResult.h"

@interface IPCFilterDataSourceResult()

@property (nonatomic, strong) NSMutableDictionary * filterSource;//All filter data collection
@property (nonatomic, copy) NSArray * filterKeysList;//Collection filter type name
@property (nonatomic, assign) BOOL  isTryOn;
@property (nonatomic, assign) BOOL  isCustomsized;

@end

@implementation IPCFilterDataSourceResult


- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


- (NSMutableDictionary *)filterSource{
    if (!_filterSource)
        _filterSource = [[NSMutableDictionary alloc]init];
    return _filterSource;
}


- (void)parseFilterData:(id)responseObject IsTry:(BOOL)isTry
{
    self.isTryOn = isTry;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        for (NSString * key in [responseObject allKeys]) {
            NSArray * array = responseObject[key];
            if ([array count] > 0 && key && key.length)
                [self.filterSource setObject:array forKey:key];
        }
        self.filterKeysList = self.filterSource.allKeys;
    }
}


- (NSArray<NSString *> *)allCategoryName{
    if (self.isTryOn)
        return @[@"镜架",@"太阳眼镜",@"定制类眼镜",@"老花眼镜"];
    return @[@"镜架",@"太阳眼镜",@"定制类眼镜",@"老花眼镜",@"镜片",@"隐形眼镜",@"配件",@"其它"];
}

- (NSString *)categoryName:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"FRAMES";
            break;
        case 1:
            return @"SUNGLASSES";
            break;
        case 2:
            return @"CUSTOMIZED";
            break;
        case 3:
            return @"READING_GLASSES";
            break;
        case 4:
            return @"LENS";
            break;
        case 5:
            return @"CONTACT_LENSES";
            break;
        case 6:
            return @"ACCESSORY";
            break;
        case 7:
            return @"OTHERS";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)payStatusCategoryName:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"FRAMES";
            break;
        case 1:
            return @"SUNGLASSES";
            break;
        case 2:
            return @"CUSTOMIZED";
            break;
        case 3:
            return @"BATCH_READING_GLASSES";
            break;
        case 4:
            return @"BATCH_LENS";
            break;
        case 5:
            return @"BATCH_CONTACT_LENSES";
            break;
        case 6:
            return @"ACCESSORY";
            break;
        case 7:
            return @"SOLUTION";
            break;
        case 8:
            return @"OTHERS";
            break;
        default:
            break;
    }
    return @"";
}

- (NSArray *)allFilterKeys{
    return self.filterKeysList;
}

- (NSDictionary *)allFilterValues{
    return self.filterSource;
}


@end
