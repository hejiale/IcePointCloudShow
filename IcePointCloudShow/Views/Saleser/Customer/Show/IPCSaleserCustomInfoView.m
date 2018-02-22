//
//  IPCPayOrderCustomInfoView.m
//  IcePointCloudShow
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSaleserCustomInfoView.h"

@interface IPCSaleserCustomInfoView()

@property (strong, nonatomic) IBOutlet UIView *customerInfoView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *encryptedPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *growthValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *upgradeMemberButton;

@end

@implementation IPCSaleserCustomInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserCustomInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.upgradeMemberButton addBorder:3 Width:1 Color:COLOR_RGB_BLUE];
    }
    return self;
}



#pragma mark //Clicked Events
- (IBAction)editCustomerInfoAction:(id)sender
{
    
}

- (IBAction)upgradeMemberAction:(id)sender {
}


- (void)updateCustomerInfo
{
    [self hideMemberInfoView];
    
    IPCDetailCustomer * customer = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer;
    
    [self.customerNameLabel setText:customer.customerName];
    
    NSMutableArray * infoStrArray =  [[NSMutableArray alloc]init];
    [infoStrArray addObject: [IPCCommon formatGender:customer.gender]];

    if (customer.age)
        [infoStrArray addObject:[NSString stringWithFormat:@"%@岁",customer.age]];
    
    if (customer.customerPhone) {
        [infoStrArray addObject:customer.customerPhone];
    }

    if (infoStrArray.count) {
        [self.infoLabel setText: [infoStrArray componentsJoinedByString:@"   "]];
    }
    
    [self.birthdayLabel setText:customer.birthday];
    [self.customerTypeLabel setText:customer.customerType];
    [self.payAmountLabel setText:[NSString stringWithFormat:@"￥%.2f", customer.consumptionAmount]];
    [self.pointLabel setText:[NSString stringWithFormat:@"%d",customer.integral]];
    
    [self.growthValueLabel setText:customer.membergrowth ? : @"0"];
    [self.encryptedPhoneLabel setText:customer.memberPhone];
    [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%",customer.discount*10 ? : 100]];
    [self.balanceLabel setText:[NSString stringWithFormat:@"￥%.f",customer.balance]];
    
    if (customer.memberLevel) {
        [self.upgradeMemberButton setHidden:YES];
        [self.memberLevelLabel setHidden:NO];
        [self.memberLevelLabel setText:customer.memberLevel];
    }else{
        [self.upgradeMemberButton setHidden:NO];
        [self.memberLevelLabel setHidden:YES];
    }
}


- (void)hideMemberInfoView
{
    [self.memberLevelLabel setText:@""];
    
    [self.infoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)obj;
            if (label.tag > 0) {
                [label setText:@""];
            }
        }
    }];
    
    [self.customerInfoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)obj;
            if (label.tag > 0) {
                [label setText:@""];
            }
        }
    }];
}


@end
