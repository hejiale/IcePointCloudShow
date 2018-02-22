//
//  IPCMenuCustomerTableViewCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCMenuCustomerTableViewCell.h"

@implementation IPCMenuCustomerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView * selectedView = [[UIView alloc]initWithFrame:self.bounds];
    [selectedView setBackgroundColor:[UIColor colorWithHexString:@"#F0F2F5"]];
    [self setSelectedBackgroundView:selectedView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomer:(IPCDetailCustomer *)customer
{
    _customer = customer;
    
    if (_customer) {
        [self.customerInfoView setHidden:NO];
        [self.customerNameLabel setText:_customer.customerName];
        [self.phoneLabel setText:_customer.customerPhone];
        [self.pointLabel setText:[NSString stringWithFormat:@"积分: %d", _customer.integral]];
        [self.balanceLabel setText:[NSString stringWithFormat:@"储值: %.2f", _customer.balance]];
        [self.discountLabel setText:[NSString stringWithFormat:@"折扣: %.f%%%", _customer.discount ? _customer.discount*10 : 100]];
    }
}

@end
