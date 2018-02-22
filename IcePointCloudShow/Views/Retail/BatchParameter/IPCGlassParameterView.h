//
//  GlassParameterView.h
//  IcePointCloudShow
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCSaleserProduct.h"
#import "IPCShoppingCartItem.h"

@interface IPCGlassParameterView : UIView

@property (nonatomic, copy) IPCSaleserProduct * glasses;
@property (nonatomic, copy) IPCShoppingCartItem * cartItem;

- (instancetype)initWithFrame:(CGRect)frame Complete:(void (^)())complete;

- (void)show;

@end

