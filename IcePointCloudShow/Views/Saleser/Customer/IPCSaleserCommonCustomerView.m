//
//  IPCSaleserCommonCustomerView.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/2/5.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserCommonCustomerView.h"
#import "IPCScanCodeViewController.h"
#import "IPCSaleserCustomInfoView.h"
#import "IPCSaleserUpdateCustomerView.h"
#import "IPCSaleserCustomerCollectionViewCell.h"
#import "IPCCustomerListViewModel.h"
#import "IPCSaleserInsertCustomerView.h"
#import "IPCUpgradeMemberView.h"

static NSString * const customerIdentifier = @"IPCPayOrderCustomerCollectionViewCellIdentifier";

@interface IPCSaleserCommonCustomerView()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *customerListCollectionView;
@property (weak, nonatomic) IBOutlet UIView *customInfoContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insertWidthConstraint;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, strong) IPCSaleserCustomInfoView * infoView;
@property (nonatomic, strong) IPCSaleserUpdateCustomerView * updateView;
@property (nonatomic, strong) IPCSaleserInsertCustomerView * editCustomerView;
@property (nonatomic, strong) IPCUpgradeMemberView *  upgradeMemberView;
@property (nonatomic, strong) IPCPortraitNavigationViewController * cameraNav;

@end

@implementation IPCSaleserCommonCustomerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserCommonCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self loadCollectionView];
    //Init Data
    self.viewModel = [[IPCCustomerListViewModel alloc]init];
    //Load Data
    [self loadData];
    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
        [self queryCustomerDetail];
    }
    //KVO
    [[IPCPayOrderManager sharedManager] ipc_addObserver:self ForKeyPath:@"currentCustomerId"];
    
    if ([IPCAppManager sharedManager].companyCofig.isCheckMember) {
        [self.scanButton setHidden:YES];
        self.insertWidthConstraint.constant = 418;
    }
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.customerListCollectionView.jk_width-5)/2;
    CGFloat itemHeight = (self.jk_height-30 - 65)/7;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    [_customerListCollectionView setCollectionViewLayout:layout];
    _customerListCollectionView.emptyAlertImage = @"exception_search";
    _customerListCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    _customerListCollectionView.mj_header = self.refreshHeader;
    _customerListCollectionView.mj_footer = self.refreshFooter;
    [_customerListCollectionView registerNib:[UINib nibWithNibName:@"IPCSaleserCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    return _refreshFooter;
}

- (IPCSaleserCustomInfoView *)infoView
{
    if (!_infoView) {
        __weak typeof(self) weakSelf = self;
        _infoView = [[IPCSaleserCustomInfoView alloc]initWithFrame:CGRectMake(0, 0, self.customInfoContentView.jk_width, self.customInfoContentView.jk_height-60)];
        [[_infoView rac_signalForSelector:@selector(editCustomerInfoAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showUpdateCustomerView];
        }];
        [[_infoView rac_signalForSelector:@selector(upgradeMemberAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf showUpgradeMemberView];
        }];
    }
    return _infoView;
}

- (IPCSaleserInsertCustomerView *)editCustomerView
{
    if (!_editCustomerView) {
        __weak typeof(self) weakSelf = self;
        _editCustomerView = [[IPCSaleserInsertCustomerView alloc]initWithFrame:[IPCAppManager sharedManager].currentLevelViewController.view.bounds
                                                                   UpdateBlock:^(NSString *customerId)
                             {
                                 [IPCPayOrderManager sharedManager].currentCustomerId = customerId;
                                 [weakSelf loadData];
                             }];
    }
    return _editCustomerView;
}

- (IPCSaleserUpdateCustomerView *)updateView
{
    if (!_updateView) {
        __weak typeof(self) weakSelf = self;
        _updateView = [[IPCSaleserUpdateCustomerView alloc]initWithFrame:[IPCAppManager sharedManager].currentLevelViewController.view.bounds
                                                             UpdateBlock:^(NSString *customerId) {
                                                                 [weakSelf queryCustomerDetail];
                                                             }];
    }
    return _updateView;
}

- (IPCUpgradeMemberView *)upgradeMemberView
{
    if (!_upgradeMemberView) {
        _upgradeMemberView = [[IPCUpgradeMemberView alloc]initWithFrame:[IPCAppManager sharedManager].currentLevelViewController.view.bounds Customer:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer UpdateBlock:^{
            
        }];
    }
    return _upgradeMemberView;
}

- (void)loadCustomerInfoView
{
    self.bottomConstraint.constant = 50;
    [self.infoView updateCustomerInfo];
    [self.customInfoContentView addSubview:self.infoView];
    [self.customInfoContentView bringSubviewToFront:self.infoView];
    [self.customerListCollectionView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseCustomerNotification object:nil];
}

- (void)showEditCustomerView
{
    [[IPCAppManager sharedManager].currentLevelViewController.view addSubview:self.editCustomerView];
    [[IPCAppManager sharedManager].currentLevelViewController.view bringSubviewToFront:self.editCustomerView];
}

- (void)showUpdateCustomerView
{
    [[IPCAppManager sharedManager].currentLevelViewController.view addSubview:self.updateView];
    [[IPCAppManager sharedManager].currentLevelViewController.view bringSubviewToFront:self.updateView];
    [self.updateView updateCustomerInfo];
}

- (void)showUpgradeMemberView
{
    [[IPCAppManager sharedManager].currentLevelViewController.view addSubview:self.upgradeMemberView];
    [[IPCAppManager sharedManager].currentLevelViewController.view bringSubviewToFront:self.upgradeMemberView];
}

#pragma mark //Refresh Methods
- (void)beginRefresh
{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self.viewModel resetData];
    [self loadCustomerList];
}

- (void)loadMore
{
    self.viewModel.currentPage++;
    [self loadCustomerList];
}

#pragma mark //Load Data
- (void)loadData
{
    [self.viewModel resetData];
    self.customerListCollectionView.isBeginLoad = YES;
    [self loadCustomerList];
    [self.customerListCollectionView reloadData];
}

#pragma mark //Request Data
- (void)loadCustomerList
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerList:^(NSError *error){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.viewModel.status == IPCFooterRefresh_HasNoMoreData) {
            [strongSelf.refreshFooter noticeNoDataStatus];
        }else if (strongSelf.viewModel.status == IPCRefreshError){
            if ([error code] != NSURLErrorCancelled) {
                [IPCCommonUI showError:@"查询客户失败,请稍后重试!"];
            }
        }
        [strongSelf reload];
    }];
}

- (void)queryCustomerDetail
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerDetail:^{
        [weakSelf loadCustomerInfoView];
    }];
}

- (void)validationMemberRequest:(NSString *)code
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel validationMemberRequest:code Complete:^{
        [weakSelf reloadCustomerInfo];
    }];
}


#pragma mark //Reload CollectionView
- (void)reload
{
    self.customerListCollectionView.isBeginLoad = NO;
    [self.customerListCollectionView reloadData];
    
    if (self.viewModel.status == IPCFooterRefresh_HasMoreData) {
        [self stopRefresh];
    }
}

- (void)reloadCustomerInfo
{
    [[IPCPayOrderManager sharedManager] clearPayRecord];
    [[IPCPayOrderManager sharedManager] resetCustomerDiscount];
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
    
    [self loadCustomerInfoView];
}

- (void)stopRefresh{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender
{
    [self showEditCustomerView];
}

- (IBAction)scanAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    IPCScanCodeViewController *scanVc = [[IPCScanCodeViewController alloc] initWithFinish:^(NSString *result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.cameraNav dismissViewControllerAnimated:YES completion:nil];
        [weakSelf validationMemberRequest:result];
    }];
    self.cameraNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:scanVc];
    [[IPCAppManager sharedManager].currentLevelViewController presentViewController:self.cameraNav  animated:YES completion:nil];
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.customerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCSaleserCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    if (self.viewModel && self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        cell.currentCustomer = customer;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Prereload Data
    if (self.viewModel.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.viewModel.customerArray.count -10) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        if (customer) {
            [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
        }
    }
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.viewModel.searchWord = [textField.text jk_trimmingWhitespace];
    [self loadData];
}


#pragma mark //KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentCustomerId"]) {
        if (![IPCPayOrderManager sharedManager].currentCustomerId) {
            [self.infoView removeFromSuperview];
            [self.customerListCollectionView reloadData];
            self.bottomConstraint.constant = 5;
            [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseCustomerNotification object:nil];
        }else{
            [self queryCustomerDetail];
        }
    }
}


@end
