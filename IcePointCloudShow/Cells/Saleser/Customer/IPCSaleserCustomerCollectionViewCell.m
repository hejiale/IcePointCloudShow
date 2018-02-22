//
//  IPCPayOrderCustomerCollectionViewCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSaleserCustomerCollectionViewCell.h"

@implementation IPCSaleserCustomerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer)
    {
        NSInteger width = [_currentCustomer.customerName jk_sizeWithFont:self.customerNameLabel.font constrainedToHeight:self.customerNameLabel.jk_height].width;
        self.nameWidth.constant = MAX(MIN(100, width), 35);
        
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.customerPhoneLabel setText:_currentCustomer.customerPhone];
        
        if (_currentCustomer.memberLevel) {
            [self.customerLevelLabel setText:_currentCustomer.memberLevel];
        }else{
            [self.customerLevelLabel setText:@"非会员"];
        }
        
        if ([_currentCustomer.customerID integerValue] == [[IPCPayOrderManager sharedManager].currentCustomerId integerValue])
        {
            [self.customerNameLabel setTextColor:COLOR_RGB_BLUE];
            [self.customerPhoneLabel setTextColor:COLOR_RGB_BLUE];
            [self.customerLevelLabel setTextColor:COLOR_RGB_BLUE];
            [self addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
            [self.line setBackgroundColor:COLOR_RGB_BLUE];
            [self.headButton setSelected:YES];
            [self.phoneButton setSelected:YES];
        }else{
            [self.customerNameLabel setTextColor:[UIColor jk_colorWithHexString:@"#333333"]];
            [self.customerPhoneLabel setTextColor:[UIColor jk_colorWithHexString:@"#999999"]];
            [self.customerLevelLabel setTextColor:[UIColor jk_colorWithHexString:@"#999999"]];
            [self.line setBackgroundColor:[UIColor jk_colorWithHexString:@"#999999"]];
            [self addBorder:0 Width:0 Color:nil];
            [self.headButton setSelected:NO];
            [self.phoneButton setSelected:NO];
        }
    }
}

@end
