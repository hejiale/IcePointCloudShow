//
//  IPCSaleserExtractOrderViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserExtractOrderViewController.h"
#import "IPCSaleserExtractOrderListCell.h"
#import "IPCSaleserExtractOrderDetailCell.h"

static NSString * const ExtractOrderListCellIdentifier = @"IPCSaleserExtractOrderListCellIdentifier";
static NSString * const ExtractOrderDetailCellIdentifier = @"IPCSaleserExtractOrderDetailCellIdentifier";

@interface IPCSaleserExtractOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger        currentPage;
    NSIndexPath * selectIndexPath;
    NSString       * keyword;
}
@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (weak, nonatomic) IBOutlet UITableView *productListTableView;
@property (nonatomic, strong) IPCRefreshAnimationHeader  *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter   *refreshFooter;
@property (nonatomic, strong) NSMutableArray<IPCCustomerOrderMode *> * orderList;
@property (nonatomic, strong) IPCCustomerOrderDetail * orderDetail;

@end

@implementation IPCSaleserExtractOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.orderListTableView setTableHeaderView:[[UIView alloc]init]];
    [self.orderListTableView setTableFooterView:[[UIView alloc]init]];
    [self.productListTableView setTableHeaderView:[[UIView alloc]init]];
    [self.productListTableView setTableFooterView:[[UIView alloc]init]];
    
    self.orderListTableView.mj_header = self.refreshHeader;
    self.orderListTableView.mj_footer = self.refreshFooter;
}

- (NSMutableArray<IPCCustomerOrderMode *> *)orderList
{
    if (!_orderList) {
        _orderList = [[NSMutableArray alloc]init];
    }
    return _orderList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.refreshHeader beginRefreshing];
}

#pragma mark //Request Data
- (void)queryOrderList
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager queryListPrototypeOrderWithPage:currentPage
                                                       Keyword:keyword
                                                  SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
        IPCCustomerOrderList * order = [[IPCCustomerOrderList alloc]initWithResponseValue:responseValue];
        if (order.list.count > 0) {
            [strongSelf.orderList addObjectsFromArray:order.list];
        }else{
            [strongSelf.refreshFooter noticeNoDataStatus];
        }
        [weakSelf reloadUI];
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)queryOrderDetailWithOrderNum:(NSString *)orderNum
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryOrderDetailWithOrderID:orderNum SuccessBlock:^(id responseValue) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.orderDetail = [[IPCCustomerOrderDetail alloc]init];
        [strongSelf.orderDetail parseResponseValue:responseValue];
        [strongSelf.productListTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)reloadUI
{
    [self.orderListTableView reloadData];
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
}

#pragma mark //Set UI
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

#pragma mark //Refresh Method
- (void)beginRefresh
{
    [self.refreshFooter resetDataStatus];
    currentPage = 1;
    [self.orderList removeAllObjects];
    [self queryOrderList];
}

- (void)loadMore
{
    currentPage++;
    [self queryOrderList];
}

#pragma mark //Clicked Events
- (IBAction)removeOrderAction:(id)sender {
    
}


- (IBAction)getOrderAction:(id)sender {
    [[IPCPayOrderManager sharedManager] getProtyOrder:self.orderDetail];
    [[NSNotificationCenter defaultCenter] postNotificationName:IPCGetProtyOrderNotification object:nil];
}


#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.orderListTableView]) {
        return self.orderList.count;
    }
    return self.orderDetail.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.orderListTableView]) {
        IPCSaleserExtractOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:ExtractOrderListCellIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCSaleserExtractOrderListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCCustomerOrderMode * order = self.orderList[indexPath.row];
        cell.orderMode = order;
        [cell updateBorderStatus:selectIndexPath.row == indexPath.row ? YES : NO];
        
        return cell;
    }else{
        IPCSaleserExtractOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:ExtractOrderDetailCellIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCSaleserExtractOrderDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCSaleserProduct * glasses = self.orderDetail.products[indexPath.row];
        cell.glasses = glasses;
        
        return   cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.orderListTableView]) {
        selectIndexPath = indexPath;
        [tableView reloadData];
        
        IPCCustomerOrderMode * order = self.orderList[indexPath.row];
        [self queryOrderDetailWithOrderNum:order.orderCode];
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
    keyword= [textField.text jk_trimmingWhitespace];
    [self.refreshHeader beginRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
