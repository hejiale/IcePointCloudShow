//
//  IPCSaleserProcessViewController.m
//  IcePointCloudShow
//
//  Created by gerry on 2018/1/4.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCSaleserProcessViewController.h"
#import "IPCProcessListCollectionViewCell.h"

static NSString * processListIdentifier = @"IPCProcessListCollectionViewCellIdentifier";

@interface IPCSaleserProcessViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *waitProcessedButton;
@property (weak, nonatomic) IBOutlet UIButton *haveDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *haveCancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;
@property (weak, nonatomic) IBOutlet UITextField *processSearchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *processCollectionView;

@end

@implementation IPCSaleserProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.processSearchTextField addBorder:0 Width:1 Color:nil];
    [self.processSearchTextField setLeftImageView:@"icon_search"];
    
    [self loadCollectionView];
}

#pragma mark //Set UI
- (void)loadCollectionView
{
    __block CGFloat width = (self.processCollectionView.jk_width-15)/4;
    __block CGFloat height = (self.processCollectionView.jk_height-15)/4;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:5];
    [layout setMinimumInteritemSpacing:5];
    
    [self.processCollectionView setCollectionViewLayout:layout];
    [self.processCollectionView registerNib:[UINib nibWithNibName:@"IPCProcessListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:processListIdentifier];
}


#pragma mark //Clicked Events

- (IBAction)waitProcrssAction:(id)sender {
    self.lineLeftConstraint.constant = 0;
}


- (IBAction)haveDoneAction:(id)sender {
    self.lineLeftConstraint.constant = 100;
}

- (IBAction)haveCancelAction:(id)sender {
    self.lineLeftConstraint.constant = 200;
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCProcessListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:processListIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark //UICollectionViewDelegate

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
