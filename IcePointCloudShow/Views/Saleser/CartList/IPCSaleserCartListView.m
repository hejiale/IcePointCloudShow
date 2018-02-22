//
//  IPCCartListView.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserCartListView.h"
#import "IPCSaleserShoppingCartView.h"

@interface IPCSaleserCartListView()

@property (weak, nonatomic) IBOutlet UIView *orderInfoView;
@property (weak, nonatomic) IBOutlet UIView *cartListContentView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrePirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWidth;


@property (strong, nonatomic) IPCSaleserShoppingCartView * cartView;

@end

@implementation IPCSaleserCartListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserCartListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:IPCShoppingCartCountKey object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cartListContentView addSubview:self.cartView];
}

#pragma mark //Set UI
- (IPCSaleserShoppingCartView *)cartView
{
    if (!_cartView) {
        _cartView = [[IPCSaleserShoppingCartView alloc]initWithFrame:self.cartListContentView.bounds Complete:nil];
    }
    return _cartView;
}

#pragma mark //Clicked Events
- (void)updateInfo
{
    NSString * priceStr = [NSString stringWithFormat:@"￥%.2f", [[IPCShoppingCart sharedCart] allGlassesTotalPrice]];
    NSInteger width = [priceStr jk_sizeWithFont:self.totalPriceLabel.font constrainedToHeight:self.totalPriceLabel.jk_height].width;
    self.priceWidth.constant = width;
    
    [self.totalPriceLabel setText:priceStr];
    [self.totalPrePirceLabel setText:[NSString stringWithFormat:@"￥%.2f", [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice]]];
    [self.discountLabel setText:[NSString stringWithFormat:@"￥%.2f", [IPCPayOrderManager sharedManager].discountAmount]];
}

@end
