//
//  IPCProcessHaveDoneDetailViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/2/6.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCProcessDetailViewController.h"

@interface IPCProcessDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *haveDoneInfoView;
@property (strong, nonatomic) IBOutlet UIView *noneDoneInfoView;


@end

@implementation IPCProcessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"流程详情"];
    
    [self.detailContentView addSubview:self.haveDoneInfoView];
    self.contentHeightConstraint.constant = self.haveDoneInfoView.jk_height;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
