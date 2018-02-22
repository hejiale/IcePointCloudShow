//
//  GlasslistCollectionViewCell.m
//  IcePointCloudShow
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlasslistCollectionViewCell.h"

@implementation IPCGlasslistCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self) weakSelf = self;
    [self.productImageView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showDetailAction];
    }];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses)
    {
        //Reload Product Image And Auto Fit
        IPCGlassesImage * glassImage = [self.glasses imageWithType:IPCGlassesImageTypeThumb];
        
        __block CGFloat scale = 0;
        if (glassImage.width > glassImage.height) {
            scale = glassImage.width/glassImage.height;
        }else{
            scale = glassImage.height/glassImage.width;
        }
        __block CGFloat width = 280;
        __block CGFloat height = width/scale;
        self.imageHeight.constant = MIN(height, 120);
        
        [self.productImageView setImageWithURL:[NSURL URLWithString:glassImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];

        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",_glasses.price]];
        [self.productNameLabel setSpaceWithText:_glasses.glassName LineSpace:10 WordSpace:0];
        //Get Name Text Height And Auto Fit
       CGFloat labelHeight = [self.productNameLabel.text jk_heightWithFont:self.productNameLabel.font constrainedToWidth:self.productNameLabel.jk_width];
        self.labelHeightConstraint.constant = labelHeight + 10;
        
        //Glasses Try Icon And Stock Icon
        if (_glasses.isTryOn) {
            [self.defaultImageView setHidden:NO];
            self.tryWidth.constant = 39;
        }else{
            [self.defaultImageView setHidden:YES];
            self.tryWidth.constant = 0;
        }
        
        if (_glasses.stock > 0) {
            [self.noStockImageView setHidden:YES];
            self.noStockWidth.constant = 0;
        }else{
            [self.noStockImageView setHidden:NO];
            self.noStockWidth.constant = 39;
        }
        
        if (_glasses.isTryOn && _glasses.stock > 0) {
            self.tryLeft.constant = 0;
        }else{
            self.tryLeft.constant = 5;
        }
    }
}

- (void)showDetailAction
{
    if ([self.delegate respondsToSelector:@selector(showProductDetail:)]) {
        [self.delegate showProductDetail:self];
    }
}


@end
