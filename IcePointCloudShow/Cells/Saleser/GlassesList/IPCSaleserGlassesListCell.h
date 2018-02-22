//
//  IPCGlassesListCell.h
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCGlassesListCellDelegate;

@interface IPCSaleserGlassesListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceCartButton;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (copy, nonatomic) IPCSaleserProduct * glasses;
@property (assign, nonatomic) id<IPCGlassesListCellDelegate>delegate;

@end

@protocol IPCGlassesListCellDelegate <NSObject>

- (void)chooseParameter:(IPCSaleserGlassesListCell *)cell;
- (void)editBatchParameter:(IPCSaleserGlassesListCell *)cell;
- (void)reload:(IPCSaleserGlassesListCell *)cell;

@end
