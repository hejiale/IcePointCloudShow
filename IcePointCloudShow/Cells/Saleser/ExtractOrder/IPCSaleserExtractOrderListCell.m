//
//  IPCSaleserExtractOrderListCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserExtractOrderListCell.h"

@implementation IPCSaleserExtractOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderMode:(IPCCustomerOrderMode *)orderMode
{
    _orderMode = orderMode;
    
    if (_orderMode){
        [self.orderDateLabel setText: _orderMode.orderDate];
        [self.employeeNameLabel setText:_orderMode.empName];
        [self.customerInfoLabel setText:[_orderMode.contactorName stringByAppendingString:_orderMode.contactorPhone]];
    }
}


- (void)updateBorderStatus:(BOOL)isSelect
{
    if (isSelect) {
        [self.mainView addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        [self.orderDateLabel setTextColor:COLOR_RGB_BLUE];
        [self.employeeNameLabel setTextColor:COLOR_RGB_BLUE];
        [self.customerInfoLabel setTextColor:COLOR_RGB_BLUE];
    }else{
        [self.mainView addBorder:0 Width:0 Color:nil];
        [self.orderDateLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [self.employeeNameLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [self.customerInfoLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    }
}

@end
