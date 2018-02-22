//
//  IPCMenuProcessTableViewCell.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCMenuProcessTableViewCell.h"

@implementation IPCMenuProcessTableViewCell

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

@end
