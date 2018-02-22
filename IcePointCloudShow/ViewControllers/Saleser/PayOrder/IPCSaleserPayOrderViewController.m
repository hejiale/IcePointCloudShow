//
//  IPCPayGlassesViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserPayOrderViewController.h"
#import "IPCSaleserGlassesListView.h"
#import "IPCSaleserCartListView.h"
#import "IPCSaleserPayCashView.h"
#import "IPCPayOrderOfferOrderInfoView.h"
#import "IPCPayOrderShoppingCartView.h"

@interface IPCSaleserPayOrderViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *payCashButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (strong, nonatomic) UIView * leftContentView;
@property (strong, nonatomic) UIView * rightContentView;

@property (strong, nonatomic) IPCSaleserGlassesListView * glassesListView;
@property (strong, nonatomic) IPCSaleserCartListView * cartListView;
@property (strong, nonatomic) IPCSaleserPayCashView * payCashView;
@property (strong, nonatomic) IPCPayOrderOfferOrderInfoView * offerOrderView;
@property (strong, nonatomic) IPCPayOrderShoppingCartView * offerCartView;
@property (nonatomic, strong) IPCCustomKeyboard * keyboard;

@end

@implementation IPCSaleserPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.contentScrollView addSubview:self.leftContentView];
    [self.contentScrollView addSubview:self.rightContentView];
    [self.contentScrollView setContentSize:CGSizeMake(self.contentView.jk_width*2, 0)];
    
    [self.leftContentView addSubview:self.glassesListView];
    [self.leftContentView addSubview:self.cartListView];
    
    [self.rightContentView addSubview:self.offerCartView];
    [self.rightContentView addSubview:self.offerOrderView];
    [self.rightContentView addSubview:self.keyboard];
    
    [self.bottomView addTopLine];
    
    [self queryIntegralRule];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.glassesListView reload];
    [self updateUI];
    [self reload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IPCTextFiledControl instance] clearPreTextField];
}

#pragma mark //Set UI
- (UIView *)leftContentView
{
    if (!_leftContentView) {
        _leftContentView = [[UIView alloc]initWithFrame:self.contentView.bounds];
        [_leftContentView setBackgroundColor:[UIColor clearColor]];
    }
    return _leftContentView;
}

- (UIView *)rightContentView
{
    if (!_rightContentView) {
        _rightContentView = [[UIView alloc]initWithFrame:CGRectMake(self.leftContentView.jk_right, 0, self.contentView.jk_width, self.contentView.jk_height)];
        [_rightContentView setBackgroundColor:[UIColor clearColor]];
    }
    return _rightContentView;
}

- (IPCSaleserGlassesListView *)glassesListView
{
    if (!_glassesListView) {
        _glassesListView = [[IPCSaleserGlassesListView alloc]initWithFrame:CGRectMake(0, 0, 580, self.contentView.jk_height)];
    }
    return _glassesListView;
}

- (IPCSaleserCartListView *)cartListView
{
    if (!_cartListView) {
        _cartListView = [[IPCSaleserCartListView alloc]initWithFrame:CGRectMake(self.glassesListView.jk_right+5, 0, self.contentView.jk_width - self.glassesListView.jk_right - 10, self.contentView.jk_height)];
    }
    return _cartListView;
}

- (IPCSaleserPayCashView *)payCashView
{
    if (!_payCashView) {
        __weak typeof(self) weakSelf = self;
        _payCashView = [[IPCSaleserPayCashView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Complete:^{
            [self.nextStepButton setSelected:NO];
            [weakSelf reload];
        }];
    }
    return _payCashView;
}

- (IPCPayOrderShoppingCartView *)offerCartView
{
    if (!_offerCartView) {
        __weak typeof(self) weakSelf = self;
        _offerCartView = [[IPCPayOrderShoppingCartView alloc]initWithFrame:CGRectMake(0, 0, 450, self.rightContentView.jk_height) Complete:^{
            [weakSelf updateUI];
        }];
        _offerCartView.keyboard = self.keyboard;
    }
    return _offerCartView;
}

- (IPCPayOrderOfferOrderInfoView *)offerOrderView
{
    if (!_offerOrderView) {
        __weak typeof(self) weakSelf = self;
        _offerOrderView = [[IPCPayOrderOfferOrderInfoView alloc]initWithFrame:CGRectMake(self.offerCartView.jk_right+5, 5 , 389, 290) EndEditing:^{
            [weakSelf.offerCartView reload];
        }];
    }
    return _offerOrderView;
}

- (IPCCustomKeyboard *)keyboard{
    if (!_keyboard)
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectMake(self.offerCartView.jk_right+5, self.offerOrderView.jk_bottom+5, 389, 350)];
    return _keyboard;
}

#pragma mark //Request Data
- (void)queryIntegralRule
{
    [IPCPayOrderRequestManager queryIntegralRuleWithSuccessBlock:^(id responseValue){
        [IPCPayOrderManager sharedManager].integralTrade = [IPCPayCashIntegralTrade mj_objectWithKeyValues:responseValue];
    } FailureBlock:^(NSError *error) {
    }];
}

#pragma mark //Request Data
- (void)areCancelOrderWithComplete:(void(^)())complete
{
    [IPCPayOrderRequestManager payOrderWithCurrentStatus:@"NULL"
                                               EndStatus:@"PROTOTYPE"
                                            SuccessBlock:^(id responseValue)
     {
         [[IPCPayOrderManager sharedManager] resetData];
         
         if (complete) {
             complete(nil);
         }
     } FailureBlock:^(NSError *error) {
         if (complete) {
             complete(error);
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)payCashAction:(id)sender
{
    if ([[IPCShoppingCart sharedCart] allGlassesCount] == 0) {
        [IPCCommonUI showError:@"购物列表为空!"];
        return;
    }
    if (self.payCashView) {
        self.payCashView = nil;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.payCashView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.payCashView];
}


- (IBAction)areCancelAction:(id)sender
{
    if ([[IPCPayOrderManager sharedManager] isCanPayOrder:NO]) {
        __weak typeof(self) weakSelf = self;
        
        [self areCancelOrderWithComplete:^{
            [self.nextStepButton setSelected:NO];
            [weakSelf reload];
        }];
    }
}

- (IBAction)nextStepAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [self reload];
}
    

- (IBAction)cancelOrderAction:(id)sender {
    [[IPCPayOrderManager sharedManager] resetData];
    [self.nextStepButton setSelected:NO];
    [self reload];
}


- (void)reload{
    if (self.nextStepButton.selected) {
        [self updateUI];
        [self.contentScrollView setContentOffset:CGPointMake(self.contentView.jk_width, 0) animated:YES];
        self.rightConstraint.constant = 0;
    }else{
        [self.cartListView updateInfo];
        [self.contentScrollView setContentOffset:CGPointZero animated:YES];
        self.rightConstraint.constant = -154;
    }
    [self.glassesListView reload];
}


- (void)updateUI
{
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
    [self.offerOrderView updateOrderInfo];
    [self.offerCartView reload];
}

#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < scrollView.jk_width) {
        [self.nextStepButton setSelected:NO];
    }else{
        [self.nextStepButton setSelected:YES];
    }
    [self reload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
