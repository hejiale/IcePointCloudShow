//
//  IPCMenuCustomerTableViewCell.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCMenuCustomerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *customerInfoView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (copy, nonatomic)  IPCDetailCustomer * customer;


@end
