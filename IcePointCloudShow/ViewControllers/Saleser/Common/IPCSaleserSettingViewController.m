//
//  IPCSaleserSettingViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/17.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserSettingViewController.h"

@interface IPCSaleserSettingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceStategyLabel;
@property (weak, nonatomic) IBOutlet UILabel *wareHouseLabel;

@end

@implementation IPCSaleserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"设置"];
    [self setNavigationBarStatus:NO];
    
    if ([[IPCAppManager sharedManager].storeResult.sex isEqualToString:@"女"]) {
        [self.headImageView setImage:[UIImage imageNamed:@"icon_login_head_femal"]];
    }else{
        [self.headImageView setImage:[UIImage imageNamed:@"icon_login_head_male"]];
    }
    [self.userNameLabel setText:[IPCAppManager sharedManager].storeResult.employee.name];
    [self.phoneLabel setText:[IPCAppManager sharedManager].storeResult.contacterPhone];
    [self.storeLabel setText:[IPCAppManager sharedManager].storeResult.storeName];
    [self.priceStategyLabel setText:[IPCAppManager sharedManager].currentStrategy.strategyName];
    [self.wareHouseLabel setText:[IPCAppManager sharedManager].currentWareHouse.wareHouseName];
}

#pragma mark //Clicked Events
- (IBAction)logOutAction:(id)sender {
    [[IPCAppManager sharedManager] logout];
}

- (IBAction)updatePasswordAction:(id)sender {
}

- (IBAction)cleanCacheAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
