//
//  IPCCommonUI.h
//  IcePointCloudShow
//
//  Created by mac on 8/14/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPCCommonUI : NSObject

+ (void)show;

+ (void)showInfo:(NSString *)message;

+ (void)showSuccess:(nonnull NSString *)message;

+ (void)showError:(NSString *)message;

+ (void)hiden;

+ (void)showAlert:(NSString *)alertTitle Message:(NSString *)alertMesg;

+ (void)showAlert:(NSString *)title Message:(NSString *)message Owner:(id)owner Done:(void(^)())done;

+ (void)pushToRootIndex:(NSInteger)index;

+ (void)clearAutoCorrection:(UIView *)view;

+ (UIView *)nearestAncestorForView:(UIView *)aView withClass:(Class)aClass;

+ (UIView *)currentView;

@end
