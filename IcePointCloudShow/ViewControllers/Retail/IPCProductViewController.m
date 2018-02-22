//
//  IPCProductViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCProductViewController.h"

@interface IPCProductViewController ()

@end

@implementation IPCProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
}

#pragma mark //Request Data
- (void)loadNormalProducts:(void(^)())complete
{
    //Reset Glasses Data
    [self.glassListViewMode resetData];
    
    __weak typeof (self) weakSelf = self;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadGlassesListData:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf filterGlassesCategory:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (complete) {
            complete();
        }
    });
}


- (void)loadGlassesListData:(void(^)())complete
{
    __weak typeof(self) weakSelf = self;
    [self.glassListViewMode reloadGlassListDataWithComplete:^(NSError * error){
        _isCancelRequest = NO;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.glassListViewMode.status == IPCFooterRefresh_HasNoMoreData){
            [strongSelf.refreshFooter noticeNoDataStatus];
        }else if (strongSelf.glassListViewMode.status == IPCRefreshError){
            if ([error code] == NSURLErrorCancelled) {
                _isCancelRequest = YES;
            }else{
                [IPCCommonUI showError:@"搜索商品失败,请稍后重试!"];
            }
        }
        if (complete) {
            complete();
        }
    }];
}

- (void)filterGlassesCategory:(void(^)())complete
{
    [self.glassListViewMode filterGlassCategoryWithFilterSuccess:^(NSError *error) {
        _isCancelRequest = NO;
        if (error) {
            if ([error code] == NSURLErrorCancelled) {
                _isCancelRequest = YES;
            }else{
                [IPCCommonUI showError:@"获取商品分类数据失败,请稍后重试!"];
            }
        }
        if (complete) {
            complete();
        }
    }];
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

#pragma mark //Clicked Events
- (void)reload
{
    
}

- (void)removeCover
{
    
}

- (void)onFilterProducts
{
    

}

- (void)onSearchProducts
{
    
}

- (void)stopRefresh{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
