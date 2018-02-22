//
//  ExpandableShoppingCartCell.m
//  IcePointCloudShow
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCSaleserCartListCell.h"

@interface IPCSaleserCartListCell()

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;

@end

@implementation IPCSaleserCartListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem
{
    _cartItem = cartItem;
    
    if (_cartItem) {
        self.glassesNameLbl.text = _cartItem.glasses.prodName;
        self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", _cartItem.prePrice]];
        
        if ([self.cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass && self.cartItem.glasses.batchAdd){
            if (self.cartItem.batchReadingDegree.length) {
                [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",self.cartItem.batchReadingDegree]];
            }
        }else if (([self.cartItem.glasses filterType] == IPCTopFilterTypeLens || [self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses) && self.cartItem.glasses.batchAdd){
            if (self.cartItem.batchSph.length && self.cartItem.bacthCyl.length) {
                [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",self.cartItem.batchSph,self.cartItem.bacthCyl]];
            }
        }else{
            [self.parameterLabel setText:@""];
        }
    }
}

@end
