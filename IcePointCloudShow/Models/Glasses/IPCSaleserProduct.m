//
//  IPCSaleserProduct.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/25.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserProduct.h"

@implementation IPCSaleserProduct

- (IPCTopFilterType)filterType
{
    if (!self.prodId && !self.prodId.length)return IPCTopFIlterTypeNone;
    
    if ([self.prodType isEqualToString:@"FRAMES"]) {
        return IPCTopFIlterTypeFrames;
    }else if ([self.prodType isEqualToString:@"SUNGLASSES"]){
        return IPCTopFilterTypeSunGlasses;
    }else if ([self.prodType isEqualToString:@"CUSTOMIZED"]){
        return IPCTopFilterTypeCustomized;
    }else if ([self.prodType isEqualToString:@"READING_GLASSES"]){
        return IPCTopFilterTypeReadingGlass;
    }else if ([self.prodType isEqualToString:@"LENS"]){
        return IPCTopFilterTypeLens;
    }else if ([self.prodType isEqualToString:@"CONTACT_LENSES"]){
        return IPCTopFilterTypeContactLenses;
    }else if ([self.prodType isEqualToString:@"ACCESSORY"]){
        return IPCTopFilterTypeAccessory;
    }
    return IPCTopFilterTypeOthers;
}

@end
