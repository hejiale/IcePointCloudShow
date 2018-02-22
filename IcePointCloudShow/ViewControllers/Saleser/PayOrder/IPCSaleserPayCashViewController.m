//
//  IPCPayCashViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserPayCashViewController.h"
#import "IPCMenuPayTableViewCell.h"
#import "IPCMenuProcessTableViewCell.h"
#import "IPCMenuCustomerTableViewCell.h"
#import "IPCMenuOptometryTableViewCell.h"
#import "IPCMenuExtractOrderTableViewCell.h"
#import "IPCSaleserProcessViewController.h"
#import "IPCSaleserCustomerViewController.h"
#import "IPCSaleserOptometryViewController.h"
#import "IPCSaleserPayOrderViewController.h"
#import "IPCSaleserExtractOrderViewController.h"
#import "IPCSaleserEmployeListView.h"

static NSString * const processIdentifier    = @"IPCMenuProcessTableViewCellIdentifier";
static NSString * const customerIdentifier  = @"IPCMenuCustomerTableViewCellIdentifier";
static NSString * const optometryIdentifier = @"IPCMenuOptometryTableViewCellIdentifier";
static NSString * const payIdentifier      = @"IPCMenuPayTableViewCellIdentifer";
static NSString * const extractIdentifier = @"IPCMenuExtractOrderTableViewCellIdentifier";

@interface IPCSaleserPayCashViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSIndexPath * preIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *rightItemView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthConstraint;
@property (strong, nonatomic) IPCSaleserEmployeListView * employeeListView;

@property (strong, nonatomic) NSMutableArray<UIViewController *> * viewControllers;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation IPCSaleserPayCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"收银"];
    
    [self.menuTableView setTableHeaderView:[[UIView alloc]init]];
    [self.menuTableView setTableFooterView:[[UIView alloc]init]];
    self.menuTableView.estimatedRowHeight = 75;
    
    [self setRightView:self.rightItemView];
    [self reloadEmployee];
    
    [self insertSubViewController];
    preIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self setCurrentPage:3];
    
    [IPCAppManager sharedManager].currentLevelViewController = self;
    
    [[IPCPayOrderManager sharedManager] queryPayType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:IPCChooseCustomerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:IPCChooseOptometryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectProtyOrder) name:IPCGetProtyOrderNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IPCPayOrderManager sharedManager] resetData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCChooseCustomerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCChooseOptometryNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCGetProtyOrderNotification object:nil];
}

- (NSMutableArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc]init];
    }
    return _viewControllers;
}

#pragma mark //Set UI
- (IPCSaleserEmployeListView *)employeeListView
{
    if (!_employeeListView) {
        __weak typeof(self) weakSelf = self;
        _employeeListView = [[IPCSaleserEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^(IPCEmployee *employee) {
            [IPCPayOrderManager sharedManager].employee = employee;
            [weakSelf reloadEmployee];
        }];
    }
    return _employeeListView;
}

- (void)insertSubViewController
{
    IPCSaleserProcessViewController * processVC = [[IPCSaleserProcessViewController alloc]initWithNibName:@"IPCSaleserProcessViewController" bundle:nil];
    IPCSaleserCustomerViewController * customerVC = [[IPCSaleserCustomerViewController alloc]initWithNibName:@"IPCSaleserCustomerViewController" bundle:nil];
    IPCSaleserOptometryViewController * optometryVC = [[IPCSaleserOptometryViewController alloc]initWithNibName:@"IPCSaleserOptometryViewController" bundle:nil];
    IPCSaleserPayOrderViewController * glassesVC = [[IPCSaleserPayOrderViewController alloc]initWithNibName:@"IPCSaleserPayOrderViewController" bundle:nil];
    IPCSaleserExtractOrderViewController * extractOrderVC = [[IPCSaleserExtractOrderViewController alloc]initWithNibName:@"IPCSaleserExtractOrderViewController" bundle:nil];
    [self.viewControllers addObjectsFromArray:@[processVC, customerVC, optometryVC, glassesVC, extractOrderVC]];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage != _currentPage && currentPage != NSNotFound)
    {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIViewController * currentViewController = self.viewControllers[currentPage];
        [self addChildViewController:currentViewController];
        [currentViewController.view setFrame:self.contentView.bounds];
        [self.contentView addSubview:currentViewController.view];
        [currentViewController didMoveToParentViewController:self];
        
        if (currentPage != _currentPage && _currentPage != NSNotFound) {
            UIViewController * preViewController = self.viewControllers[_currentPage];
            [preViewController.view removeFromSuperview];
            [preViewController removeFromParentViewController];
        }
        _currentPage = currentPage;
        [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark //Clicked Events
- (IBAction)selectEmployeeAction:(id)sender {
    [self.view addSubview:self.employeeListView];
    [self.view bringSubviewToFront:self.employeeListView];
}

- (void)reload
{
    [self.menuTableView reloadData];
    [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)reloadEmployee{
    NSInteger width = [[IPCAppManager sharedManager].storeResult.employee.name jk_sizeWithFont:self.employeeNameLabel.font constrainedToHeight:self.employeeNameLabel.jk_height].width;
    self.nameWidthConstraint.constant = width;
    [self.employeeNameLabel setText:[IPCPayOrderManager sharedManager].employee.name];
}

- (void)selectProtyOrder
{
    [self setCurrentPage:1];
}

#pragma mark //UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        IPCMenuProcessTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:processIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCMenuProcessTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else if (indexPath.row == 1){
        IPCMenuCustomerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:customerIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCMenuCustomerTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        if ([IPCPayOrderManager sharedManager].currentCustomerId) {
            cell.customer = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer;
        }else{
            [cell.customerInfoView setHidden:YES];
        }
        return cell;
    }else if (indexPath.row == 2){
        IPCMenuOptometryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:optometryIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCMenuOptometryTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        if ([IPCPayOrderManager sharedManager].currentOptometryId) {
            cell.optometry = [IPCPayOrderCurrentCustomer sharedManager].currentOpometry;
        }else{
            [cell.infoView setHidden:YES];
        }
        return cell;
    }else if (indexPath.row == 3){
        IPCMenuPayTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:payIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCMenuPayTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else{
        IPCMenuExtractOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:extractIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCMenuExtractOrderTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && [IPCPayOrderManager sharedManager].currentCustomerId) {
        return 200;
    }else if (indexPath.row == 2 && [IPCPayOrderManager sharedManager].currentOptometryId){
        return 150;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 && ![IPCPayOrderManager sharedManager].currentCustomerId) {
        [IPCCommonUI showError:@"请先选择客户!"];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [tableView selectRowAtIndexPath:preIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        preIndexPath = indexPath;
        [self setCurrentPage:indexPath.row];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
