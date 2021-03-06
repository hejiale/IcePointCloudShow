//
//  IPCLoginViewModel.m
//  IcePointCloudShow
//
//  Created by gerry on 2017/11/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCLoginViewModel.h"
#import "IPCRootViewController.h"

static NSString * const AccountErrorMessage = @"登录帐号不能为空!";
static NSString * const PasswordErrorMessage = @"登录密码不能为空!";

@implementation IPCLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.loginHistory addObjectsFromArray:[IPCAppManager sharedManager].loginAccountHistory];
    }
    return self;
}

- (NSMutableArray<NSString *> *)loginHistory{
    if (!_loginHistory) {
        _loginHistory = [[NSMutableArray alloc]init];
    }
    return _loginHistory;
}

- (NSString *)userName
{
    if ([NSUserDefaults jk_stringForKey:IPCUserNameKey].length) {
        return [NSUserDefaults jk_stringForKey:IPCUserNameKey];
    }
    return nil;
}

#pragma mark //Request Methods
- (void)signinRequestWithUserName:(NSString *)userName Password:(NSString *)password Failed:(void(^)())failed
{
    NSString * Tusername = [userName jk_trimmingWhitespace];
    NSString * Tpassword = [password jk_trimmingWhitespace];
    
    if (!Tusername.length){
        [IPCCommonUI showError:AccountErrorMessage];
        if (failed) {
            failed();
        }
        return;
    }
    if (!Tpassword.length) {
        [IPCCommonUI showError:PasswordErrorMessage];
        if (failed) {
            failed();
        }
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    [IPCUserRequestManager userLoginWithUserName:Tusername Password:Tpassword SuccessBlock:^(id responseValue){
        //query login info
        [IPCAppManager sharedManager].deviceToken = responseValue[@"mobileToken"];
        //storeage account info
        [weakSelf syncUserAccountHistory:userName];
        //query responsity wareHouse
        [weakSelf loadConfigData];
    } FailureBlock:^(NSError *error) {
        if (failed) {
            failed();
        }
        [IPCCommonUI showError: error.domain];
    }];
}

- (void)loadConfigData
{
    __weak typeof (self) weakSelf = self;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf queryEmployeeAccount:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadWareHouse:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadPriceStrategy:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf showMainRootViewController];
    });
}

- (void)queryEmployeeAccount:(void(^)())complete
{
    [[IPCAppManager sharedManager] queryEmployeeAccount:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError: error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)loadWareHouse:(void(^)())complete
{
    [[IPCAppManager sharedManager] loadWareHouse:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError: error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)loadPriceStrategy:(void(^)())complete
{
    [[IPCAppManager sharedManager] queryPriceStrategy:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError: error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}


#pragma mark //Clicked Methods
- (void)syncUserAccountHistory:(NSString *)userName
{
    if ([IPCAppManager sharedManager].deviceToken.length && userName.length)
    {
        [NSUserDefaults jk_setObject:userName forKey:IPCUserNameKey];
        
        if (![self.loginHistory containsObject:userName])
            [self.loginHistory insertObject:userName atIndex:0];
        
        NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.loginHistory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCListLoginHistoryKey];
        [NSUserDefaults jk_setObject:historyData forKey:IPCListLoginHistoryKey];
    }
}

- (void)showMainRootViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            BOOL oldState = [UIView areAnimationsEnabled];
                            [UIView setAnimationsEnabled:NO];
                            IPCRootViewController * menuVC = [[IPCRootViewController alloc]initWithNibName:@"IPCRootViewController" bundle:nil];
                            UINavigationController * menuNav = [[UINavigationController alloc]initWithRootViewController:menuVC];
                            [[UIApplication sharedApplication].keyWindow setRootViewController:menuNav];
                            [UIView setAnimationsEnabled:oldState];
                        } completion:nil];
    });
}


@end
