//
//  EditBatchParameterView.m
//  IcePointCloudShow
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditBatchParameterView.h"
#import "IPCEditParameterCell.h"

static NSString * const parameterIdentifier = @"EditParameterCellIdentifier";

@interface IPCEditBatchParameterView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *editParameterView;
@property (weak, nonatomic) IBOutlet UITableView *parameterTableView;
@property (weak, nonatomic) IBOutlet UIImageView *glassImageView;
@property (weak, nonatomic) IBOutlet UILabel *glassNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPriceLabel;
@property (copy, nonatomic) void(^DismissBlock)();
@property (strong, nonatomic) IPCSaleserProduct * currentGlass;

@end

@implementation IPCEditBatchParameterView

- (instancetype)initWithFrame:(CGRect)frame Glasses:(IPCSaleserProduct *)glasses  Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.DismissBlock = dismiss;
        self.currentGlass = glasses;
     
        UIView * parameterBgView = [UIView jk_loadInstanceFromNibWithName:@"IPCEditBatchParameterView" owner:self];
        [parameterBgView setFrame:frame];
        [self addSubview:parameterBgView];
        
        [self.glassNameLabel setText:glasses.prodName];
        [self.glassPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.suggestPrice]];
    
        if (glasses){
            CGAffineTransform transform = CGAffineTransformScale(self.editParameterView.transform, 0.2, 0.2);
            [self.editParameterView setTransform:transform];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.editParameterView addBorder:8 Width:0 Color:nil];
    [self.glassImageView addBorder:5 Width:0.5 Color:nil];
    [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
}

#pragma mark //Clicked Events
- (void)show{
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGAffineTransform newTransform =  CGAffineTransformConcat(self.editParameterView.transform,  CGAffineTransformInvert(self.editParameterView.transform));
        [strongSelf.editParameterView setTransform:newTransform];
        strongSelf.editParameterView.alpha = 1.0;
    } completion:nil];
}


- (IBAction)closeAction:(id)sender {
    [self removeCover];
}

- (void)removeCover{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGAffineTransform transform = CGAffineTransformScale(self.editParameterView.transform, 0.3, 0.3);
        [strongSelf.editParameterView setTransform:transform];
        strongSelf.editParameterView.alpha = 0;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (finished) {
            [strongSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakSelf removeFromSuperview];
            if (strongSelf.DismissBlock)
                strongSelf.DismissBlock();
        }
    }];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCEditParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:parameterIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCEditParameterCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    __weak typeof (self) weakSelf = self;
    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass][indexPath.row];
    [cell setCartItem:cartItem Reload:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.parameterTableView reloadData];
    }];
    return cell;
}

#pragma mark //UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end
