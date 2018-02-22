//
//  GlassDetailsViewController.m
//  IcePointCloudShow
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlassDetailsViewController.h"
#import "IPCProductDetailTableViewCell.h"

static NSString * const infoDetailIdentifier = @"ProductInfoDetailTableViewCellIdentifier";
static NSString * const webViewIdentifier = @"UIWebViewCellIdentifier";

@interface IPCGlassDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView * detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *goTopButton;
@property (strong, nonatomic) UIWebView * productDetailWebView;

@end

@implementation IPCGlassDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"商品详情"];
    
    [self.detailTableView setTableHeaderView:[[UIView alloc]init]];
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
    self.detailTableView.estimatedSectionFooterHeight = 0;
    self.detailTableView.estimatedSectionHeaderHeight = 0;
    
    if (self.glasses) {
        if (self.glasses.detailLinkURl.length) {
            [self.productDetailWebView loadHTMLString:self.glasses.detailLinkURl baseURL:nil];
            self.detailTableView.isBeginLoad = YES;
        }else{
            self.detailTableView.isBeginLoad = NO;
        }
    }
    [self.detailTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarStatus:NO];
    [[IPCHttpRequest sharedClient] cancelAllRequest];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //清除网页内容
    self.productDetailWebView.delegate = nil;
    [self.productDetailWebView loadHTMLString:@"" baseURL:nil];
    [self.productDetailWebView stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
}

#pragma mark //Set UI
-(UIWebView *)productDetailWebView{
    if (!_productDetailWebView) {
        _productDetailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        [_productDetailWebView setBackgroundColor:[UIColor clearColor]];
        _productDetailWebView.delegate = self;
        _productDetailWebView.scrollView.scrollEnabled = NO;
        _productDetailWebView.scrollView.showsVerticalScrollIndicator = NO;
        _productDetailWebView.scrollView.showsHorizontalScrollIndicator = NO;
        [_productDetailWebView scalesPageToFit];
        _productDetailWebView.userInteractionEnabled = NO;
        [_productDetailWebView jk_makeTransparentAndRemoveShadow];
    }
    return _productDetailWebView;
}

#pragma mark //Clicked Events
- (void)tryGlassesMethod{
    if ([IPCTryMatch instance].matchItems.count == 0) {
        [[IPCTryMatch instance] initMatchItems];
    }
    [[IPCTryMatch instance] currentMatchItem].glass = self.glasses;
    [IPCCommonUI pushToRootIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)goTopAction:(id)sender {
    [self.goTopButton setHidden:YES];
    [self.detailTableView scrollToTopAnimated:YES];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!tableView.isBeginLoad) {
        if (self.glasses.detailLinkURl.length) {
            return 2;
        }
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCProductDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoDetailIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCProductDetailTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.glasses = self.glasses;
        
        __weak typeof(self) weakSelf = self;
        [[cell rac_signalForSelector:@selector(tryGlassesAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [weakSelf tryGlassesMethod];
        }];
        [[cell rac_signalForSelector:@selector(showMoreAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:webViewIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webViewIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.productDetailWebView];
        }
        
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.view.jk_height;
    }
    return self.productDetailWebView.jk_height;
}

#pragma mark //UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    if(img.width > 1024){ img.style.width = '100%%'; } \
    } \
    }";
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, [UIScreen jk_width]]];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"]floatValue];
    CGRect frame = webView.frame;
    frame.size.height = height;
    webView.frame = frame;
    
    self.detailTableView.isBeginLoad = NO;
    [self.detailTableView reloadData];
    [IPCCommonUI hiden];
}

#pragma mark //UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > (self.view.jk_height * 2)) {
        [self.goTopButton setHidden:NO];
    }else{
        [self.goTopButton setHidden:YES];
    }
}

@end