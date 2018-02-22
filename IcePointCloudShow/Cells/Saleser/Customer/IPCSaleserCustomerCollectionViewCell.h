//
//  IPCPayOrderCustomerCollectionViewCell.h
//  IcePointCloudShow
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSaleserCustomerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet UIImageView *line;


@property (copy, nonatomic) IPCCustomerMode * currentCustomer;

@end
