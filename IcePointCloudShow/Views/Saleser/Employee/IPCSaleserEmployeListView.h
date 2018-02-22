//
//  IPCEmployeeListView.h
//  IcePointCloudShow
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSaleserEmployeListView : UIView

- (instancetype)initWithFrame:(CGRect)frame DismissBlock:(void(^)(IPCEmployee *))dismiss;

@end
