//
//  IPCUpgradeMemberView.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCUpgradeMemberView : UIView

- (instancetype)initWithFrame:(CGRect)frame Customer:(IPCDetailCustomer *)customer UpdateBlock:(void (^)())update;

@end
