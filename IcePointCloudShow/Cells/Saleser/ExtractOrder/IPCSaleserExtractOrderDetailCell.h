//
//  IPCSaleserExtractOrderDetailCell.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSaleserExtractOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *prePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countNumLabel;
@property (copy, nonatomic) IPCSaleserProduct * glasses;

@end
