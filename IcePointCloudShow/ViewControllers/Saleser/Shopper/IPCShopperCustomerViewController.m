//
//  IPCShopperCustomerViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/2/5.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCShopperCustomerViewController.h"
#import "IPCSaleserCommonCustomerView.h"

@interface IPCShopperCustomerViewController ()

@property (nonatomic, strong) IPCSaleserCommonCustomerView * customerView;

@end

@implementation IPCShopperCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.customerView];
}

- (IPCSaleserCommonCustomerView *)customerView
{
    if (!_customerView) {
        _customerView = [[IPCSaleserCommonCustomerView alloc]initWithFrame:self.view.bounds];
    }
    return _customerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
