//
//  GlassListViewController.m
//  IcePointCloudShow
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlassListViewController.h"
#import "IPCGlassDetailsViewController.h"
#import "IPCGlasslistCollectionViewCell.h"
#import "IPCSearchGlassesViewController.h"

static NSString * const glassListCellIdentifier = @"IPCGlasslistCollectionViewCellIdentifier";

@interface IPCGlassListViewController ()<GlasslistCollectionViewCellDelegate,IPCSearchViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic)   IBOutlet UICollectionView   *glassListCollectionView;
@property (weak, nonatomic)   IBOutlet UIButton                *goTopButton;

@end

@implementation IPCGlassListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load CollectionView
    [self loadCollectionView];
    // Init ViewModel
    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = NO;
    // Load Data
    [self beginFilterClass];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //According To NetWorkStatus To Reload Products
    if (self.isCancelRequest && self.glassListViewMode.currentPage == 0) {
        [self beginFilterClass];
    }else{
        [self.glassListCollectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Clear All Cover View
    [self removeCover];
    // Clear Refresh Animation
    [self stopRefresh];
}

#pragma mark //Set UI
- (void)loadCollectionView
{
    __block CGFloat width = (self.view.jk_width-2)/3;
    __block CGFloat height = (self.view.jk_height-2)/2;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:1];
    [layout setMinimumInteritemSpacing:1];
    
    [self.glassListCollectionView setCollectionViewLayout:layout];
    [self.glassListCollectionView registerNib:[UINib nibWithNibName:@"IPCGlasslistCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:glassListCellIdentifier];
    self.glassListCollectionView.mj_header = self.refreshHeader;
    self.glassListCollectionView.mj_footer = self.refreshFooter;
    self.glassListCollectionView.emptyAlertTitle = @"未搜索到任何商品";
    self.glassListCollectionView.emptyAlertImage = @"exception_search";
}

#pragma mark //UICollectionView Refresh Method
- (void)beginRefresh{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
    __weak typeof(self) weakSelf = self;
    [self.refreshFooter resetDataStatus];
    [self loadNormalProducts:^{
        [weakSelf reload];
    }];
}

- (void)loadMore
{
    self.glassListViewMode.currentPage += 1;
    
    __weak typeof(self) weakSelf = self;
    [self loadGlassesListData:^{
        [weakSelf reload];
    }];
}

#pragma mark //Normal Load Method
- (void)beginFilterClass
{
    __weak typeof(self) weakSelf = self;
    self.glassListCollectionView.isBeginLoad = YES;
    [self loadNormalProducts:^{
        [weakSelf reload];
    }];
    [self.glassListCollectionView reloadData];
}

#pragma mark //Clicked Events
- (void)onFilterProducts{
    [super onFilterProducts];
    
    if ([self.glassListViewMode.filterView superview]) {
        [self removeCover];
    }else{
        __weak typeof (self) weakSelf = self;
        [self addCoverWithAlpha:0.2 Complete:^{
            [weakSelf removeCover];
        }];
        
        [self.glassListViewMode showFilterCategory:self InView:self.coverView ReloadClose:^{
            [weakSelf removeCover];
            [weakSelf beginFilterClass];
        } ReloadUnClose:^{
            [weakSelf beginFilterClass];
        }];
    }
}

- (void)onSearchProducts{
    [super onSearchProducts];
    
    [self removeCover];
    //Present To Search ViewController
    IPCSearchGlassesViewController * searchViewMode = [[IPCSearchGlassesViewController alloc]initWithNibName:@"IPCSearchGlassesViewController" bundle:nil];
    searchViewMode.searchDelegate = self;
    searchViewMode.filterType = self.glassListViewMode.currentType;
    [searchViewMode showSearchProductViewWithSearchWord:self.glassListViewMode.searchWord];
    [self presentViewController:searchViewMode animated:YES completion:nil];
}


- (IBAction)onGoTopAction:(id)sender {
    [self.goTopButton setHidden:YES];
    [self.glassListCollectionView scrollToTopAnimated:YES];
}

//Reload Glasses CollectionView
- (void)reload{
    [super reload];
    
    self.glassListCollectionView.isBeginLoad = NO;
    [self.glassListCollectionView reloadData];
    [self.glassListViewMode.filterView setCoverStatus:YES];
    
    [self stopRefresh];
}

//Remover All Cover
- (void)removeCover
{
    [super removeCover];
    
    [self.glassListViewMode.filterView removeFromSuperview];
    [self.coverView removeFromSuperview];
}

#pragma mark //UICollectionViewDataSoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.glassListViewMode.glassesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCGlasslistCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:glassListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
        IPCGlasses * glasses = self.glassListViewMode.glassesList[indexPath.row];
        [cell setGlasses:glasses];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Preload Glasses Data
    if (self.glassListViewMode.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.glassListViewMode.glassesList.count - (self.glassListViewMode.limit - 10)) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //GlassListViewCellDelegate
- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        //Push To Detail ViewController
        IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc]initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
        detailVC.glasses  = self.glassListViewMode.glassesList[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)reloadProductList:(IPCGlasslistCollectionViewCell *)cell{
    [self reload];
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword
{
    self.glassListViewMode.searchWord = keyword;
    [self beginFilterClass];
}

#pragma mark //UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > self.view.jk_height * 2) {
        [self.goTopButton setHidden:NO];
    }else{
        [self.goTopButton setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
