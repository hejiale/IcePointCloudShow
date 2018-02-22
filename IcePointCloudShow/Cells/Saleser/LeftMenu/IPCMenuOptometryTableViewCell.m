//
//  IPCMenuOptometryTableViewCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCMenuOptometryTableViewCell.h"

@implementation IPCMenuOptometryTableViewCell

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

- (void)setOptometry:(IPCOptometryMode *)optometry
{
    _optometry = optometry;
    
    if (_optometry) {
        [self.infoView setHidden:NO];
        [self.employeeNameLabel setText:[NSString stringWithFormat:@"验光师: %@", _optometry.employeeName]];
        [self.dateLabel setText:[NSString stringWithFormat:@"日期: %@",[IPCCommon formatDate:[IPCCommon dateFromString:optometry.insertDate] IsTime:NO]]];
    }
}

@end
