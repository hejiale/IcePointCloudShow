//
//  GlasslistCollectionViewCell.h
//  IcePointCloudShow
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GlasslistCollectionViewCellDelegate;

@interface IPCGlasslistCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *noStockImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noStockWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (nonatomic, copy) IPCGlasses *glasses;
@property (weak, nonatomic) id<GlasslistCollectionViewCellDelegate>delegate;

@end

@protocol GlasslistCollectionViewCellDelegate <NSObject>

- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell;
- (void)reloadProductList:(IPCGlasslistCollectionViewCell *)cell;

@end
