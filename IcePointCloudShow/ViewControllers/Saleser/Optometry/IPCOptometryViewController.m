//
//  IPCOptometryViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCOptometryViewController.h"
#import "IPCSaleserProcessViewController.h"
#import "IPCSaleserCustomerViewController.h"
#import "IPCSaleserOptometryViewController.h"
#import "IPCMenuCustomerTableViewCell.h"
#import "IPCMenuProcessTableViewCell.h"
#import "IPCMenuOptometryTableViewCell.h"

static NSString * const processIdentifier    = @"IPCMenuProcessTableViewCellIdentifier";
static NSString * const customerIdentifier  = @"IPCMenuCustomerTableViewCellIdentifier";
static NSString * const optometryIdentifier = @"IPCMenuOptometryTableViewCellIdentifier";

@interface IPCOptometryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSMutableArray<UIViewController *> * viewControllers;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation IPCOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"验光"];
    
    [IPCAppManager sharedManager].currentLevelViewController = self;
    
    [self.menuTableView setTableHeaderView:[[UIView alloc]init]];
    [self.menuTableView setTableFooterView:[[UIView alloc]init]];
    self.menuTableView.estimatedRowHeight = 75;
    
    [self setCurrentPage:NSNotFound];
    [self insertSubViewController];
    [self setCurrentPage:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:IPCChooseCustomerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:IPCChooseOptometryNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[IPCPayOrderManager sharedManager] resetData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCChooseCustomerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCChooseOptometryNotification object:nil];
}

- (NSMutableArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc]init];
    }
    return _viewControllers;
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
        
        [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    _currentPage = currentPage;
}

#pragma mark //Clicked Events
- (void)insertSubViewController
{
    IPCSaleserProcessViewController * processVC = [[IPCSaleserProcessViewController alloc]initWithNibName:@"IPCSaleserProcessViewController" bundle:nil];
    IPCSaleserCustomerViewController * customerVC = [[IPCSaleserCustomerViewController alloc]initWithNibName:@"IPCSaleserCustomerViewController" bundle:nil];
    IPCSaleserOptometryViewController * optometryVC = [[IPCSaleserOptometryViewController alloc]initWithNibName:@"IPCSaleserOptometryViewController" bundle:nil];
    [self.viewControllers addObjectsFromArray:@[processVC, customerVC, optometryVC]];
}

- (void)reload
{
    [self.menuTableView reloadData];
    [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark //UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
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
    } else{
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
    [self setCurrentPage:indexPath.row];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
