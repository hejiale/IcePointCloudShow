//
//  IPCSaleserOptometryViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserOptometryViewController.h"
#import "IPCSaleserOptometryListView.h"
#import "IPCSaleserOptometryInfoView.h"
#import "IPCInsertNewOptometryView.h"

@interface IPCSaleserOptometryViewController ()

@property (weak, nonatomic) IBOutlet UIView *optometryHeadView;
@property (weak, nonatomic) IBOutlet UIView *optometryListContentView;
@property (weak, nonatomic) IBOutlet UIView *optometryInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;

@property (strong, nonatomic) IPCInsertNewOptometryView * insertOptometryView;
@property (strong, nonatomic) IPCSaleserOptometryInfoView * optometryView;
@property (strong, nonatomic) IPCSaleserOptometryListView * optometryListView;

@end

@implementation IPCSaleserOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.optometryListContentView addSubview:self.optometryListView];
    [self.optometryInfoView addSubview:self.optometryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadOptometryInfo) name:IPCChooseOptometryNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    if ([IPCPayOrderManager sharedManager].currentOptometryId) {
        [self.optometryHeadView setHidden:NO];
        [self.optometryInfoView setHidden:NO];
        [self.alertImageView setHidden:YES];
        [self.optometryListView reloadUI];
        [self.optometryView updateOptometryInfo];
    }else{
        [self.alertImageView setHidden:NO];
        [self.optometryHeadView setHidden:YES];
        [self.optometryInfoView setHidden:YES];
    }
}

#pragma mark //Request Data
- (void)setDefaultOptometry
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager setDefaultOptometryWithCustomID:[IPCPayOrderManager sharedManager].currentCustomerId
                                            DefaultOptometryID:[IPCPayOrderManager sharedManager].currentOptometryId
                                                  SuccessBlock:^(id responseValue) {
                                                      [IPCCommonUI showSuccess:@"设置默认验光单成功!"];
                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                      [strongSelf.optometryListView reloadUI];
    } FailureBlock:^(NSError *error) {
        
    }];
}


#pragma mark //Set UI
- (IPCSaleserOptometryInfoView *)optometryView
{
    if (!_optometryView) {
        _optometryView = [[IPCSaleserOptometryInfoView alloc]initWithFrame:self.optometryInfoView.bounds ChooseBlock:^{
            
        }];
    }
    return _optometryView;
}

- (IPCSaleserOptometryListView *)optometryListView
{
    if (!_optometryListView) {
        _optometryListView = [[IPCSaleserOptometryListView alloc]initWithFrame:self.optometryListContentView.bounds];
    }
    return _optometryListView;
}

- (IPCInsertNewOptometryView *)insertOptometryView
{
    if (!_insertOptometryView) {
        __weak typeof(self) weakSelf = self;
        _insertOptometryView = [[IPCInsertNewOptometryView alloc]initWithFrame:[IPCAppManager sharedManager].currentLevelViewController.view.bounds
                                                                    CustomerId:[IPCPayOrderManager sharedManager].currentCustomerId
                                                                 CompleteBlock:^(IPCOptometryMode *optometry)
        {
            [IPCPayOrderManager sharedManager].currentOptometryId = optometry.optometryID;
            [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = optometry;
            
            [weakSelf updateUI];
            [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseOptometryNotification object:nil];
        }];
    }
    return _insertOptometryView;
}

#pragma mark //Reload OptometryInfo
- (void)reloadOptometryInfo
{
    [self.optometryView updateOptometryInfo];
}


- (IBAction)setDefaultAction:(id)sender {
    [self setDefaultOptometry];
}

- (IBAction)insertAction:(id)sender {
    [self.insertOptometryView removeFromSuperview];
    self.insertOptometryView = nil;
    
    [[IPCAppManager sharedManager].currentLevelViewController.view addSubview:self.insertOptometryView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
