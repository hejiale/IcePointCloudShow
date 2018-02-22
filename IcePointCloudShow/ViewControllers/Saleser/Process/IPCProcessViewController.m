//
//  IPCProcessViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCProcessViewController.h"
#import "IPCProcessDetailViewController.h"
#import "IPCProcessListCell.h"

static NSString * processListIdentifier = @"IPCProcessListCellIdentifier";

@interface IPCProcessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalProcessLabel;
@property (weak, nonatomic) IBOutlet UITableView *processListTableView;
@property (weak, nonatomic) IBOutlet UITextField *processSearchTextField;

@end

@implementation IPCProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"流程看板"];
    
    [self.processSearchTextField addBorder:0 Width:1 Color:nil];
    [self.processSearchTextField setLeftImageView:@"icon_search"];
    [self.processListTableView setTableHeaderView:[[UIView alloc]init]];
    [self.processListTableView setTableFooterView:[[UIView alloc]init]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCProcessListCell * cell = [tableView dequeueReusableCellWithIdentifier:processListIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCProcessListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCProcessDetailViewController * detailVC = [[IPCProcessDetailViewController alloc]initWithNibName:@"IPCProcessDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
