//
//  IPCSaleserExtractOrderDetailCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserExtractOrderDetailCell.h"

@implementation IPCSaleserExtractOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mainView addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGlasses:(IPCSaleserProduct *)glasses
{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productNameLabel setText:_glasses.prodName];
        [self.prePriceLabel setText:[NSString stringWithFormat:@"￥%.2f", _glasses.suggestPrice]];
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f", _glasses.afterDiscountPrice]];
        [self.countNumLabel setText:[NSString stringWithFormat:@"x%d", _glasses.productCount]];
    }
}

@end
