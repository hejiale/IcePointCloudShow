//
//  IPCProductViewController.h
//  IcePointCloudShow
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootNavigationViewController.h"
#import "IPCProductViewMode.h"

@interface IPCProductViewController : IPCRootNavigationViewController

@property (nonatomic, strong) IPCRefreshAnimationHeader  *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter   *refreshFooter;
@property (strong, nonatomic) IPCProductViewMode    *glassListViewMode;
@property (assign, nonatomic) BOOL    isCancelRequest;

- (void)reload;
- (void)removeCover;
- (void)onFilterProducts;
- (void)onSearchProducts;
- (void)stopRefresh;
- (void)loadNormalProducts:(void(^)())complete;
- (void)loadGlassesListData:(void(^)())complete;

@end
