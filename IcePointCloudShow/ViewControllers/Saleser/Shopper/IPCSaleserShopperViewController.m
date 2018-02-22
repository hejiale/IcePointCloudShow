//
//  IPCShopperViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserShopperViewController.h"
#import "IPCShopperCustomerViewController.h"
#import "IPCShopperCartListViewController.h"
#import "IPCMenuCustomerTableViewCell.h"
#import "IPCMenuPayTableViewCell.h"

static NSString * const payIdentifier           = @"IPCMenuPayTableViewCellIdentifer";
static NSString * const customerIdentifier  = @"IPCMenuCustomerTableViewCellIdentifier";

@interface IPCSaleserShopperViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSMutableArray<UIViewController *> * viewControllers;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation IPCSaleserShopperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"导购"];
    
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
    IPCShopperCustomerViewController * customerVC = [[IPCShopperCustomerViewController alloc]initWithNibName:@"IPCShopperCustomerViewController" bundle:nil];
    IPCShopperCartListViewController * glassesVC = [[IPCShopperCartListViewController alloc]initWithNibName:@"IPCShopperCartListViewController" bundle:nil];
    [self.viewControllers addObjectsFromArray:@[customerVC, glassesVC]];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
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
    }else{
        IPCMenuPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCMenuPayTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && [IPCPayOrderManager sharedManager].currentCustomerId) {
        return 200;
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
