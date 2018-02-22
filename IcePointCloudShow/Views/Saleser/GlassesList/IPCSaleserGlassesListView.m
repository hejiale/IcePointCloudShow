//
//  IPCGlassesListView.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/3.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserGlassesListView.h"
#import "IPCSaleserGlassesListCell.h"
#import "IPCPayOrderGlassesList.h"
#import "IPCGlassParameterView.h"
#import "IPCEditBatchParameterView.h"

static NSString * const glassesListIdentifier = @"IPCGlassesListCellIdentifier";

@interface IPCSaleserGlassesListView()<UITableViewDelegate,UITableViewDataSource,IPCGlassesListCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchTextView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *glassesListTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryTypeScrollView;
@property (nonatomic, strong) IPCRefreshAnimationHeader  *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter   *refreshFooter;
@property (strong, nonatomic) IPCFilterDataSourceResult * filterDataSource;
@property (strong, nonatomic) IPCGlassParameterView * glassParameterView;
@property (strong, nonatomic) IPCEditBatchParameterView * editParameterView;
@property (assign, nonatomic) NSInteger currentClassIndex;
@property (assign, nonatomic) NSInteger  currentPage;
@property (copy, nonatomic) NSString * searchWord;
@property (strong, nonatomic) NSMutableArray<IPCSaleserProduct *> * glassesList;

@end


@implementation IPCSaleserGlassesListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSaleserGlassesListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        self.filterDataSource = [[IPCFilterDataSourceResult alloc]init];
        [self.searchTextView addBorder:3 Width:1 Color:nil];
        [self createCategoryTypeView];
        self.currentClassIndex = -1;
    
        self.glassesListTableView.mj_header = self.refreshHeader;
        self.glassesListTableView.mj_footer = self.refreshFooter;
        self.glassesListTableView.emptyAlertTitle = @"未搜索到任何商品";
        self.glassesListTableView.emptyAlertImage = @"exception_search";

        [self beginFilterClass];
    }
    return self;
}

- (void)reload
{
    [self.refreshHeader beginRefreshing];
}

- (NSMutableArray<IPCSaleserProduct *> *)glassesList
{
    if (!_glassesList) {
        _glassesList = [[NSMutableArray alloc]init];
    }
    return _glassesList;
}

- (void)setCurrentClassIndex:(NSInteger)currentClassIndex
{
    _currentClassIndex = currentClassIndex;
    
    [self.categoryTypeScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)obj;
            if (button.tag == currentClassIndex) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
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

- (void)createCategoryTypeView
{
    __block CGFloat total = 0;
    
    [[self.filterDataSource allCategoryName] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat  width = [obj jk_sizeWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:self.categoryTypeScrollView.jk_height].width;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(total + 10, 0, width, self.categoryTypeScrollView.jk_height)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTag:idx-1];
        [button addTarget:self action:@selector(selectClassTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryTypeScrollView addSubview: button];
        
        total += width + 30;
    }];
    [self.categoryTypeScrollView setContentSize:CGSizeMake(total, 0)];
}


#pragma mark //Request Data
- (void)queryGlassesList
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager getProductsListWithPage:self.currentPage
                                               StoreId:[IPCAppManager sharedManager].currentWareHouse.wareHouseId
                                               Keyword:self.searchWord ? : @""
                                                  Type:[self.filterDataSource payStatusCategoryName:self.currentClassIndex]
                                          SuccessBlock:^(id responseValue)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        IPCPayOrderGlassesList * result = [[IPCPayOrderGlassesList alloc]initWithResponseValue:responseValue];
        if (result) {
            [strongSelf.glassesList addObjectsFromArray:result.glassesList];
        }
        strongSelf.glassesListTableView.isBeginLoad = NO;
        [strongSelf.glassesListTableView reloadData];
        [strongSelf.refreshHeader endRefreshing];
        [strongSelf.refreshFooter endRefreshing];
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark //Refresh Method
- (void)beginRefresh{
    self.currentPage = 1;
    [self.glassesList removeAllObjects];
    [self queryGlassesList];
}

- (void)loadMore{
    self.currentPage += 1;
    [self queryGlassesList];
}

#pragma mark //Clicked Events
- (void)beginFilterClass
{
    self.glassesListTableView.isBeginLoad = YES;
    [self queryGlassesList];
    [self.glassesListTableView reloadData];
}

- (void)selectClassTypeAction:(UIButton *)sender
{
    if (sender.selected)return;

    [self setCurrentClassIndex:sender.tag];
    [self.refreshHeader beginRefreshing];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.glassesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCSaleserGlassesListCell * cell = [tableView dequeueReusableCellWithIdentifier:glassesListIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCSaleserGlassesListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        cell.delegate = self;
    }
    IPCSaleserProduct * glasses = self.glassesList[indexPath.row];
    cell.glasses = glasses;
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark //IPCGlassesListCellDelegate
- (void)chooseParameter:(IPCSaleserGlassesListCell *)cell
{
    NSIndexPath * indexPath = [self.glassesListTableView indexPathForCell:cell];
    IPCSaleserProduct * glasses = self.glassesList[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    _glassParameterView = [[IPCGlassParameterView alloc]initWithFrame:[IPCAppManager sharedManager].currentLevelViewController.view.bounds Complete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.glassesListTableView reloadData];
    }];
    self.glassParameterView.glasses = glasses;
    [[IPCAppManager sharedManager].currentLevelViewController.view addSubview:self.glassParameterView];
    [self.glassParameterView show];
}

- (void)editBatchParameter:(IPCSaleserGlassesListCell *)cell
{
    NSIndexPath * indexPath = [self.glassesListTableView indexPathForCell:cell];
    IPCSaleserProduct * glasses = self.glassesList[indexPath.row];
    
    _editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[IPCAppManager sharedManager].currentLevelViewController.view.bounds Glasses:glasses Dismiss:^{
        
    }];
    [[IPCAppManager sharedManager].currentLevelViewController.view addSubview:self.editParameterView];
    [self.editParameterView show];
}

- (void)reload:(IPCSaleserGlassesListCell *)cell
{
    [self.glassesListTableView reloadData];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.searchWord = [textField.text jk_trimmingWhitespace];
    [self.refreshHeader beginRefreshing];
    
    [textField endEditing:YES];
    return YES;
}

@end
