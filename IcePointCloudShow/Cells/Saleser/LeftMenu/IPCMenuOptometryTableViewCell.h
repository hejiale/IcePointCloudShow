//
//  IPCMenuOptometryTableViewCell.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCMenuOptometryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (copy, nonatomic) IPCOptometryMode * optometry;

@end
