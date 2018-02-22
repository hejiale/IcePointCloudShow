//
//  IPCSaleserUpdateCustomerView.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSaleserUpdateCustomerView : UIView

- (instancetype)initWithFrame:(CGRect)frame UpdateBlock:(void (^)(NSString *customerId))update;

- (void)updateCustomerInfo;

@end
