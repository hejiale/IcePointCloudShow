//
//  IPCShopperCartListViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/2/5.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCShopperCartListViewController.h"
#import "IPCSaleserGlassesListView.h"
#import "IPCSaleserCartListView.h"

@interface IPCShopperCartListViewController ()

@property (strong, nonatomic) IPCSaleserGlassesListView * glassesListView;
@property (strong, nonatomic) IPCSaleserCartListView * cartListView;

@end

@implementation IPCShopperCartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.glassesListView];
    [self.view addSubview:self.cartListView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.glassesListView reload];
    [self.cartListView updateInfo];
}

#pragma mark //Set UI
- (IPCSaleserGlassesListView *)glassesListView
{
    if (!_glassesListView) {
        _glassesListView = [[IPCSaleserGlassesListView alloc]initWithFrame:CGRectMake(0, 0, 580, self.view.jk_height)];
    }
    return _glassesListView;
}

- (IPCSaleserCartListView *)cartListView
{
    if (!_cartListView) {
        _cartListView = [[IPCSaleserCartListView alloc]initWithFrame:CGRectMake(self.glassesListView.jk_right+5, 0, self.view.jk_width - self.glassesListView.jk_right - 10, self.view.jk_height)];
    }
    return _cartListView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
