//
//  MainRootViewController.m
//  IcePointCloudShow
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRootViewController.h"
#import "IPCTryGlassesViewController.h"
#import "IPCGlassListViewController.h"
#import "IPCSideBarMenuView.h"

@interface IPCRootViewController ()<IPCRootMenuViewControllerDelegate>

@property (nonatomic, strong) IPCGlassListViewController * productVC;
@property (nonatomic, strong) IPCTryGlassesViewController *tryVC;

@end

@implementation IPCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.productVC         =  [[IPCGlassListViewController alloc]initWithNibName:@"IPCGlassListViewController" bundle:nil];
    self.tryVC                 =  [[IPCTryGlassesViewController alloc] initWithNibName:@"IPCTryGlassesViewController" bundle:nil];
    
    [self setViewControllers:@[self.productVC,self.tryVC]];
    
    __weak typeof(self) weakSelf = self;
    [[self rac_signalForSelector:@selector(filterProductAction)] subscribeNext:^(RACTuple * _Nullable x)
     {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.selectedIndex == 1) {
            [strongSelf.productVC onFilterProducts];
        }else if (strongSelf.selectedIndex == 2){
            [strongSelf.tryVC onFilterProducts];
        }
    }];
}

#pragma mark //Clicked Events
//Show Methods
- (void)showSideBarView
{
    [self.productVC removeCover];
    [self.tryVC removeCover];
   
    IPCSideBarMenuView * sideBarView = [[IPCSideBarMenuView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:sideBarView];
}

#pragma mark //RootMenuViewControllerDelegate
- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}

- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectIndex:(NSInteger)index
{
    if (index == 0) {
        if (self.selectedIndex == 1) {
            [self.productVC onSearchProducts];
        }else if (self.selectedIndex == 2){
            [self.tryVC onSearchProducts];
        }
    }else if (index == 3){
        [self showSideBarView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
