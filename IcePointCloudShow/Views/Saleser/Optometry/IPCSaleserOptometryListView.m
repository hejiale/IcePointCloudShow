//
//  IPCSaleserOptometryListView.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/11.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserOptometryListView.h"
#import "IPCSaleserOptometryView.h"

@interface IPCSaleserOptometryListView()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IPCOptometryList * optometryList;
@property (strong, nonatomic) NSMutableArray<IPCSaleserOptometryView *> * optometryViews;

@end

@implementation IPCSaleserOptometryListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserOptometryListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)reloadUI
{
    [self queryOptometryListRequest];
}

#pragma mark //Request Data
- (void)queryOptometryListRequest
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryUserOptometryListWithCustomID:[IPCPayOrderManager sharedManager].currentCustomerId
                                                     SuccessBlock:^(id responseValue)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.optometryList = [[IPCOptometryList alloc]initWithResponseValue:responseValue];
        [weakSelf loadOptometryScrollView];
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (NSMutableArray<IPCSaleserOptometryView *> *)optometryViews
{
    if (!_optometryViews) {
        _optometryViews = [[NSMutableArray alloc]init];
    }
    return _optometryViews;
}

#pragma mark //SetUI
- (void)loadOptometryScrollView
{
    [self.contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.optometryViews removeAllObjects];
    
    __block CGFloat width = (self.contentScrollView.jk_width - 20)/3;
    __block CGFloat orignX = 0;
    
    __weak typeof(self) weakSelf = self;
    [self.optometryList.listArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        IPCSaleserOptometryView * optometryView = [[IPCSaleserOptometryView alloc]initWithFrame:CGRectMake(orignX, 0, width, strongSelf.contentScrollView.jk_height) Change:^{
            [weakSelf updateSelectOptometryStatus];
        }];
        optometryView.optometry = obj;
        [strongSelf.contentScrollView addSubview:optometryView];
        [strongSelf.optometryViews addObject:optometryView];
        
        orignX += width+10;
    }];
    
    [self.contentScrollView setContentSize:CGSizeMake(orignX, 0)];
}

- (void)updateSelectOptometryStatus
{
    [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseOptometryNotification object:nil];
    
    [self.optometryViews enumerateObjectsUsingBlock:^(IPCSaleserOptometryView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateStatus];
    }];
}

@end
