//
//  IPCSaleserCustomerViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserCustomerViewController.h"
#import "IPCSaleserCommonCustomerView.h"

@interface IPCSaleserCustomerViewController ()

@property (nonatomic, strong) IPCSaleserCommonCustomerView * customerView;

@end

@implementation IPCSaleserCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
