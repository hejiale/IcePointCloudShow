//
//  IPCGlassesListCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserGlassesListCell.h"

@implementation IPCSaleserGlassesListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setGlasses:(IPCSaleserProduct *)glasses
{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productNameLabel setText:glasses.prodName];
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.suggestPrice]];
        
        __block NSInteger glassCount = [[IPCShoppingCart sharedCart]singleGlassesCount:_glasses];
        
        if (glassCount > 0) {
            [self.reduceCartButton setHidden:NO];
            [self.cartNumLabel setHidden:NO];
            [self.cartNumLabel setText:[[NSNumber numberWithInteger:glassCount]stringValue]];
            
            //Judge Cart Count
            __block NSInteger cartCount = [[IPCShoppingCart sharedCart] singleGlassesCount:_glasses];
            
            if (([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) && _glasses.batchAdd)
            {
                [self.reduceCartButton setImage:[UIImage imageNamed:@"icon_cart_edit"] forState:UIControlStateNormal];
            }else{
                [self.reduceCartButton setImage:[UIImage imageNamed:@"icon_subtract"] forState:UIControlStateNormal];
            }
        }
    }
}


#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender
{
    if (self.glasses) {
        if (([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) && _glasses.batchAdd)
        {
            if ([self.delegate respondsToSelector:@selector(chooseParameter:)]) {
                [self.delegate chooseParameter:self];
            }
        }else{
            [[IPCShoppingCart sharedCart] plusGlass:self.glasses];
            
            if ([self.delegate respondsToSelector:@selector(reload:)]) {
                [self.delegate reload:self];
            }
        }
    }
}


- (IBAction)reduceCartAction:(id)sender
{
    if (self.glasses) {
        if (([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) && _glasses.batchAdd)
        {
            if ([self.delegate respondsToSelector:@selector(editBatchParameter:)]) {
                [self.delegate editBatchParameter:self];
            }
        }else{
            [[IPCShoppingCart sharedCart] removeGlasses:self.glasses];
            
            if ([self.delegate respondsToSelector:@selector(reload:)]) {
                [self.delegate reload:self];
            }
        }
    }
}

@end
