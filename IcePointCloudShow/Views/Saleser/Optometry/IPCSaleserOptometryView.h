//
//  IPCSaleserOptometryView.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/11.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSaleserOptometryView : UIView

@property (copy, nonatomic) IPCOptometryMode * optometry;

- (instancetype)initWithFrame:(CGRect)frame Change:(void(^)())change;

- (void)updateStatus;

@end
