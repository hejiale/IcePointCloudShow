//
//  IPCRequestConstant.h
//  IcePointCloudShow
//
//  Created by mac on 2016/11/10.
//  Copyright © 2016年 Doray. All rights reserved.
//

#ifndef IPCRequestConstant_h
#define IPCRequestConstant_h

#ifdef DEBUG
//#define   IPC_ProductAPI_URL       @"http://192.168.1.146:8080/pos"
#define   IPC_ProductAPI_URL       @"https://dev.IcePointCloudShow.com"
//#define   IPC_ProductAPI_URL       @"https://IcePointCloudShow.com"
#elif   BETA
#define   IPC_ProductAPI_URL       @"https://IcePointCloudShow.com"
#else
#define   IPC_ProductAPI_URL       @"https://IcePointCloudShow.com"
#endif
#define   IPC_ProductAPI_Port       @"/gateway/api/jsonrpc.jsp"

/**
 *  Network Request Methods
 */
typedef NS_ENUM(NSUInteger, IPCRequestMethod) {
    IPCRequestTypeGET = 0,
    IPCRequestTypePOST,
};

/**
 *  Request Content CacheAble
 */
typedef NS_ENUM(NSUInteger, IPCRequestCache){
    IPCRequestCacheDisEnable = 0,
    IPCRequestCacheEnable
};

#endif /* IPCRequestConstant_h */