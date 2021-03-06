//
//  CompareItemView.h
//  IcePointCloudShow
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCTryGlassView.h"

@protocol CompareItemViewDelegate;

@interface IPCCompareItemView : IPCTryGlassView

@property (nonatomic, strong, readwrite) IPCMatchItem *matchItem;
@property (nonatomic, weak) id<CompareItemViewDelegate> delegate;

@end

@protocol CompareItemViewDelegate<NSObject>

@optional
- (void)didAnimateToSingleMode:(IPCCompareItemView *)itemView;
- (void)deleteCompareGlasses:(IPCCompareItemView *)itemView;
- (void)selectCompareIndex:(IPCCompareItemView *)itemView;

@end


