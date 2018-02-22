//
//  IPCSaleserOptometryView.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/11.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserOptometryView.h"

@interface IPCSaleserOptometryView()

@property (weak, nonatomic) IBOutlet UIView *purposeView;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabl;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (copy, nonatomic) void(^ChangeBlock)();

@end

#define DefaultColor   [UIColor colorWithHexString:@"CFCFCF"]

@implementation IPCSaleserOptometryView

- (instancetype)initWithFrame:(CGRect)frame Change:(void(^)())change
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ChangeBlock = change;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserOptometryView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.purposeView addBorder:self.purposeView.jk_height/2 Width:0 Color:nil];
        
        __weak typeof(self) weakSelf = self;
        [self jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [IPCPayOrderManager sharedManager].currentOptometryId = _optometry.optometryID;
            [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = _optometry;
            
            if (strongSelf.ChangeBlock) {
                strongSelf.ChangeBlock();
            }
        }];
    }
    return self;
}

- (void)setOptometry:(IPCOptometryMode *)optometry
{
    _optometry = optometry;
    
    if (_optometry) {
        [self updateStatus];
        [self.memoLabel setText:_optometry.remark];
        [self.createDateLabl setText:[IPCCommon formatDate:[IPCCommon dateFromString:optometry.insertDate] IsTime:NO]];
        [self.employeeLabel setText:_optometry.employeeName];
    }
}

- (void)updateStatus
{
    if (![_optometry.optometryID isEqualToString:[IPCPayOrderManager sharedManager].currentOptometryId]) {
        [self addBorder:5 Width:1 Color: DefaultColor];
        [self.memoLabel setTextColor:DefaultColor];
        [self.createDateLabl setTextColor:DefaultColor];
        [self.employeeLabel setTextColor:DefaultColor];
        [self.purposeView setBackgroundColor:DefaultColor];
    }else{
        [self addBorder:5 Width:1 Color:COLOR_RGB_BLUE];
        [self.memoLabel setTextColor:COLOR_RGB_BLUE];
        [self.createDateLabl setTextColor:COLOR_RGB_BLUE];
        [self.employeeLabel setTextColor:COLOR_RGB_BLUE];
        [self.purposeView setBackgroundColor:COLOR_RGB_BLUE];
    }
}

@end
