//
//  IPCSaleserExtractOrderListCell.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSaleserExtractOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerInfoLabel;
@property (copy, nonatomic) IPCCustomerOrderMode * orderMode;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (void)updateBorderStatus:(BOOL)isSelect;

@end
