//
//  IPCSaleserPayCashView.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserPayCashView.h"
#import "IPCPayOrderEditPayCashRecordCell.h"
#import "IPCPayOrderPayCashRecordCell.h"
#import "IPCPayCashPayTypeViewCell.h"

static  NSString * const recordCell = @"IPCPayOrderPayCashRecordCellIdentifier";
static  NSString * const editRecordCell = @"IPCPayOrderEditPayCashRecordCellIdentifier";
static  NSString * const payTypeIdentifier = @"IPCPayCashPayTypeViewCellIdentifier";

@interface IPCSaleserPayCashView()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderEditPayCashRecordCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *cashListContentView;
@property (weak, nonatomic) IBOutlet UITableView *cashListTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *payTypeCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *remainAmountLabel;
@property (nonatomic, strong) IPCCustomKeyboard * keyboard;
@property (nonatomic, strong) IPCPayRecord * insertRecord;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) void(^CompleteBlock)();

@end

@implementation IPCSaleserPayCashView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserPayCashView" owner:self];
        [self addSubview:view];
        
        [self reloadPayStatus];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cancelButton addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
    [self.cashListTableView setTableHeaderView:[[UIView alloc]init]];
    [self.cashListTableView setTableFooterView:[[UIView alloc]init]];
    
    __block CGFloat width = (self.payTypeCollectionView.jk_width - 15)/4;
    __block CGFloat height = 60;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:5];
    [layout setMinimumInteritemSpacing:5];
    
    [self.payTypeCollectionView setCollectionViewLayout:layout];
    [self.payTypeCollectionView registerNib:[UINib nibWithNibName:@"IPCPayCashPayTypeViewCell" bundle:nil] forCellWithReuseIdentifier:payTypeIdentifier];
    
    [self addSubview:self.keyboard];
    [self.keyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cashListContentView.mas_right).with.offset(10);
        make.top.equalTo(self.payTypeCollectionView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(419);
        make.height.mas_equalTo(368);
    }];
}

#pragma mark //Set UI
- (IPCCustomKeyboard *)keyboard
{
    if (!_keyboard)
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectZero];
    return _keyboard;
}

#pragma mark //Request Data
- (void)payOrderWithComplete:(void (^)(NSError * error))complete
{
    [IPCPayOrderRequestManager payOrderWithCurrentStatus:@"NULL"
                                               EndStatus:@"AUDITED"
                                            SuccessBlock:^(id responseValue)
     {
         [[IPCPayOrderManager sharedManager] resetData];
         
         if (complete) {
             complete(nil);
         }
     } FailureBlock:^(NSError *error) {
         if (complete) {
             complete(error);
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)closeAction:(id)sender
{
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [self removeFromSuperview];
    [[IPCTextFiledControl instance] clearPreTextField];
}

- (IBAction)saveOrderAction:(id)sender
{
    if ([[IPCPayOrderManager sharedManager] isCanPayOrder:YES]) {
        __weak typeof(self) weakSelf = self;
        [self payOrderWithComplete:^(NSError *error) {
            if (!error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [weakSelf removeFromSuperview];
                [[IPCTextFiledControl instance] clearPreTextField];
                
                if (strongSelf.CompleteBlock) {
                    strongSelf.CompleteBlock();
                }
            }else{
                [IPCCommonUI showError:error.domain];
            }
        }];
    }
}

- (void)reloadRemainAmount
{
    [self.remainAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderManager sharedManager] remainPayPrice]]];
}


- (void)reloadPayStatus
{
    ///无购物商品 收款记录
    if ([IPCShoppingCart sharedCart].allGlassesCount > 0 && [[IPCPayOrderManager sharedManager] remainPayPrice] > 0) {
        [self setCurrentIndex:0];
    }else if ([IPCShoppingCart sharedCart].allGlassesCount == 0 || [[IPCPayOrderManager sharedManager] remainPayPrice] <= 0){
        [self setCurrentIndex:-1];
    }
    [self reloadRemainAmount];
}

- (void)resetPayTypeStatus
{
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= 0) {
        [self setCurrentIndex:-1];
    }else{
        [self setCurrentIndex:0];
    }
    [self reloadRemainAmount];
}

#pragma mark //UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.insertRecord) {
        return [IPCPayOrderManager sharedManager].payTypeRecordArray.count + 1;
    }
    return [IPCPayOrderManager sharedManager].payTypeRecordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.insertRecord && indexPath.row == [IPCPayOrderManager sharedManager].payTypeRecordArray.count)
    {
        IPCPayOrderEditPayCashRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:editRecordCell];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderEditPayCashRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        cell.payRecord = self.insertRecord;
        
        __weak typeof(self) weakSelf = self;
        [[cell rac_signalForSelector:@selector(cancelAddRecordAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf setCurrentIndex:-1];
            [tableView reloadData];
        }];
        return cell;
    }else{
        IPCPayOrderPayCashRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:recordCell];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderPayCashRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCPayRecord * record = [IPCPayOrderManager sharedManager].payTypeRecordArray[indexPath.row];
        cell.payRecord = record;
        
        [[cell rac_signalForSelector:@selector(removePayRecordAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [[IPCPayOrderManager sharedManager].payTypeRecordArray removeObject:record];
        }];
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [IPCPayOrderManager sharedManager].payTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayCashPayTypeViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:payTypeIdentifier forIndexPath:indexPath];
    IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[indexPath.row];
    cell.payType = payType;
    
    if (self.currentIndex == indexPath.row) {
        [cell updateBorder:YES];
    }else{
        [cell updateBorder:NO];
    }
    
    return cell;
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[indexPath.row];
    
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= 0)return;
    
    if (![IPCPayOrderManager sharedManager].integralTrade && [payType.payType isEqualToString:@"积分"]) {
        [IPCCommonUI showError:@"积分规则未配置"];
        return;
    }
    
    if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.integral == 0 && [payType.payType isEqualToString:@"积分"]) {
        [IPCCommonUI showError:@"客户无可用积分"];
        return;
    }
    
    if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.balance == 0 && [payType.payType isEqualToString:@"储值卡"]) {
        [IPCCommonUI showError:@"客户无可用储值余额"];
        return;
    }
    
    if (self.currentIndex != indexPath.row) {
        [self setCurrentIndex:indexPath.row];
    }
}

#pragma mark //IPCPayOrderEditPayCashRecordCellDelegate
- (void)reloadRecord:(IPCPayOrderEditPayCashRecordCell *)cell
{
    [self resetPayTypeStatus];
}

#pragma mark //KVO
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    [self.payTypeCollectionView reloadData];
    
    if (self.currentIndex > -1) {
        IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[self.currentIndex];
        
        self.insertRecord = [[IPCPayRecord alloc]init];
        self.insertRecord.payDate = [NSDate date];
        self.insertRecord.payOrderType = payType;
        
        [IPCPayOrderManager sharedManager].isInsertRecord = YES;
    }else{
        self.insertRecord = nil;
        [IPCPayOrderManager sharedManager].isInsertRecord = NO;
    }
    [self.cashListTableView reloadData];
}


@end
