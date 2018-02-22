//
//  IPCOptometryKeyboardView.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/22.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCOptometryKeyboardViewDelegate;

@interface IPCOptometryKeyboardView : UIView

@property (nonatomic, assign) BOOL    isEdit;
@property (nonatomic, assign) NSInteger  index;//当前选项
@property (nonatomic, weak) id<IPCOptometryKeyboardViewDelegate> delegate;

- (void)inputValue:(NSString *)text;

- (void)clearString;

@end

@protocol IPCOptometryKeyboardViewDelegate <NSObject>

- (void)keyboardChangeEditing:(NSString *)text Keyboard:(IPCOptometryKeyboardView *)keyboard;

- (void)keyboardEndEditing:(NSString *)text Keyboard:(IPCOptometryKeyboardView *)keyboard;

@end
