//
//  IPCNetworkingAPI.h
//  IcePointCloudShow
//
//  Created by gerry on 2017/10/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#ifndef IPCNetworkingAPI_h
#define IPCNetworkingAPI_h

#import   "IPCUserRequestManager.h"
#import   "IPCGoodsRequestManager.h"

#define GoodsRequest_FilterCategory                    @"bizadmin.getCategoryType"
#define GoodsRequest_GoodsList                          @"bizadmin.filterTryGlasses"
#define GoodsRequest_RecommdList                     @"productAdmin.searchTryGlasses"
#define GoodsRequest_PriceStrategy                     @"productAdmin.listPriceStrategyForListProduct"

#define UserRequest_Login                                    @"bizadmin.login"
#define UserRequest_LoginOut                              @"bizadmin.logout"
#define UserRequest_UpdatePassword                   @"bizadmin.updateUserPassword"
#define UserRequest_WareHouseList                      @"bizadmin.listStoreOrRepositoryByCompanyId"
#define UserRequest_EmployeeAccount                  @"employeeadmin.getEmployeeObjectFromAccount"


#endif /* IPCNetworkingAPI_h */
