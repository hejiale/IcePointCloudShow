//
//  PersonBaseView.m
//  IcePointCloudShow
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPersonBaseView.h"
#import "IPCPersonHeadCell.h"
#import "IPCPersonTitleCell.h"
#import "IPCPersonMenuCell.h"

static NSString * const headIdentifier  = @"PersonHeadCellIdentifier";
static NSString * const titleIdentifier = @"PersonTitleCellIdentifier";
static NSString * const menuIdentifier  = @"PersonMenuCellIdentifier";

@interface IPCPersonBaseView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personTableView;
@property (weak, nonatomic) IBOutlet UIButton *logouOutButton;
@property (copy, nonatomic) void(^LogoutBlock)();
@property (copy, nonatomic) void(^WareHouseBlock)();
@property (copy, nonatomic) void(^PriceStrategyBlock)();

@end

@implementation IPCPersonBaseView

- (instancetype)initWithFrame:(CGRect)frame
                       Logout:(void(^)())logout
               WareHouseBlock:(void(^)())wareHouse
           PriceStrategyBlock:(void(^)())priceStrategy
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCPersonBaseView" owner:self];
        [self addSubview:view];
        
        self.LogoutBlock  = logout;
        self.WareHouseBlock = wareHouse;
        self.PriceStrategyBlock = priceStrategy;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.personTableView setTableHeaderView:[[UIView alloc]init]];
    [self.personTableView setTableFooterView:[[UIView alloc]init]];
    self.personTableView.estimatedSectionHeaderHeight = 0;
    self.personTableView.estimatedSectionFooterHeight = 0;
    [self.personTableView reloadData];
}

#pragma mark //Request Data
- (void)logoutRequest
{
    [IPCUserRequestManager userLogoutWithSuccessBlock:^(id responseValue) {
        if (self.LogoutBlock)
            self.LogoutBlock();
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:@"用户退出登录失败"];
    }];
}

#pragma mark //Clicked Events
- (IBAction)logoutAction:(id)sender {
    [self logoutRequest];
}

- (void)reload{
    [self.personTableView reloadData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    else
        return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCPersonHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPersonHeadCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else{
        if (indexPath.row == 0) {
            IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.companyTitleLabel setText:@"所属店铺"];
            [cell.companyNameLabel setText:[IPCAppManager sharedManager].storeResult.storeName];
            return cell;
        }else if (indexPath.row == 1) {
            if ([IPCAppManager sharedManager].priceStrategy.strategyArray.count <= 1) {
                IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
                if (!cell) {
                    cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                }
                [cell.companyTitleLabel setText:@"价格策略"];
                [cell.companyNameLabel setText:[IPCAppManager sharedManager].currentStrategy.strategyName];
                
                return cell;
            }else{
                IPCPersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:menuIdentifier];
                if (!cell) {
                    cell = [[UINib nibWithNibName:@"IPCPersonMenuCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                }
                [cell.menuTitleLabel setText:@"价格策略"];
                [cell.menuValueTitle setText: [IPCAppManager sharedManager].currentStrategy.strategyName];
                
                return cell;
            }
        }else if (indexPath.row == 2) {
            if ([IPCAppManager sharedManager].storeResult.wareHouseId) {
                IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
                if (!cell) {
                    cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                }
                [cell.companyTitleLabel setText:@"仓库"];
                [cell.companyNameLabel setText:[IPCAppManager sharedManager].storeResult.wareHouseName];
                return cell;
            }else{
                IPCPersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:menuIdentifier];
                if (!cell) {
                    cell = [[UINib nibWithNibName:@"IPCPersonMenuCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                }
                [cell.menuTitleLabel setText:@"仓库"];
                [cell.menuValueTitle setText:[IPCAppManager sharedManager].currentWareHouse.wareHouseName];
                
                return cell;
            }
        }else{
            IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.companyTitleLabel setText:@"公司"];
            [cell.companyNameLabel setText:[IPCAppManager sharedManager].storeResult.companyName];
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 140;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        if (indexPath.row == 1 && [IPCAppManager sharedManager].priceStrategy.strategyArray.count  > 1) {
            if (self.PriceStrategyBlock) {
                self.PriceStrategyBlock();
            }
        }else  if (indexPath.row == 2 && ![IPCAppManager sharedManager].storeResult.wareHouseId) {
            if (self.WareHouseBlock) {
                self.WareHouseBlock();
            }
        }
    }
}

@end
