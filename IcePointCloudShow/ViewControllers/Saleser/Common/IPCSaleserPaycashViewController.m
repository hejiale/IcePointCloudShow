//
//  IPCPayGlassesViewController.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserPayOrderViewController.h"
#import "IPCSaleserGlassesListView.h"
#import "IPCSaleserCartListView.h"
#import "IPCSaleserPayOrderView.h"

@interface IPCSaleserPayOrderViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IPCSaleserGlassesListView * glassesListView;
@property (strong, nonatomic) IPCSaleserCartListView * cartListView;
@property (strong, nonatomic) IPCSaleserPayOrderView * payOrderView;

@end

@implementation IPCSaleserPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.contentScrollView addSubview:self.glassesListView];
    [self.contentScrollView addSubview:self.cartListView];
    [self.contentScrollView addSubview:self.payOrderView];
    
    [self.bottomView addTopLine];
}

#pragma mark //Set UI
- (IPCSaleserGlassesListView *)glassesListView
{
    if (!_glassesListView) {
        _glassesListView = [[IPCSaleserGlassesListView alloc]initWithFrame:CGRectMake(0, 0, 580, self.contentView.jk_height)];
    }
    return _glassesListView;
}

- (IPCSaleserCartListView *)cartListView
{
    if (!_cartListView) {
        _cartListView = [[IPCSaleserCartListView alloc]initWithFrame:CGRectMake(self.glassesListView.jk_right+5, 0, self.contentView.jk_width - self.glassesListView.jk_right - 10, self.contentView.jk_height)];
    }
    return _cartListView;
}

- (IPCSaleserPayOrderView *)payOrderView
{
    if (!_payOrderView) {
        _payOrderView = [[IPCSaleserPayOrderView alloc]initWithFrame:CGRectMake(self.cartListView.jk_right+5, 0, 580, self.contentView.jk_height)];
    }
    return _payOrderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
