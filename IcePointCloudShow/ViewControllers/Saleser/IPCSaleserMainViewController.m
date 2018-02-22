//
//  IPCPayOrderMainViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserMainViewController.h"
#import "IPCSaleserPayCashViewController.h"
#import "IPCSaleserShopperViewController.h"
#import "IPCProcessViewController.h"
#import "IPCOptometryViewController.h"
#import "IPCSaleserSettingViewController.h"

@interface IPCSaleserMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation IPCSaleserMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"冰点云"];
    [self.userNameLabel setText:[NSString stringWithFormat:@"欢迎您，%@", [IPCAppManager sharedManager].storeResult.employee.name]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    [self hidenLeftBack];
}

#pragma mark //Clicked Events

- (IBAction)payOrderAction:(id)sender {
    IPCSaleserPayCashViewController * cashVC = [[IPCSaleserPayCashViewController alloc]initWithNibName:@"IPCSaleserPayCashViewController" bundle:nil];
    [self.navigationController pushViewController:cashVC animated:YES];
}


- (IBAction)shopperAction:(id)sender {
    IPCSaleserShopperViewController * shopperVC = [[IPCSaleserShopperViewController alloc]initWithNibName:@"IPCSaleserShopperViewController" bundle:nil];
    [self.navigationController pushViewController:shopperVC animated:YES];
}


- (IBAction)optometryAction:(id)sender {
    IPCOptometryViewController * optometryVC = [[IPCOptometryViewController alloc]initWithNibName:@"IPCOptometryViewController" bundle:nil];
    [self.navigationController pushViewController:optometryVC animated:YES];
}


- (IBAction)processAction:(id)sender {
    IPCProcessViewController * processVC = [[IPCProcessViewController alloc]initWithNibName:@"IPCProcessViewController" bundle:nil];
    [self.navigationController pushViewController:processVC animated:YES];
}


- (IBAction)settingAction:(id)sender {
    IPCSaleserSettingViewController * settingVC = [[IPCSaleserSettingViewController alloc]initWithNibName:@"IPCSaleserSettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
