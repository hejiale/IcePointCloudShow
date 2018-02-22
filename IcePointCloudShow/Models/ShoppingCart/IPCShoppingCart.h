//
//  IPCShoppingCart.h
//  IcePointCloudShow
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCShoppingCartItem.h"

@interface IPCShoppingCart : NSObject

+ (IPCShoppingCart *)sharedCart;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCShoppingCartItem *> *itemList;

/**
 *    To obtain the corresponding number of shopping cart
 */
- (NSInteger)itemsCount;
- (NSInteger)selectItemsCount;
- (NSInteger)allGlassesCount;
- (NSInteger)itemsCount:(IPCShoppingCartItem *)cartItem;
- (NSInteger)singleGlassesCount:(IPCSaleserProduct *)glasses;
/**
 *    Calculate the total price shopping cart selected goods
 */
- (double)allGlassesTotalPrePrice;
- (double)allGlassesTotalPrice;
/**
 *    Remove the shopping cart
 */
- (void)removeItem:(IPCShoppingCartItem *)item;
- (void)removeSelectCartItem;
- (void)removeGlasses:(IPCSaleserProduct *)glasse;
- (void)clear;
/**
 *     Add a shopping cart
 */
- (void)addLensWithGlasses:(IPCSaleserProduct *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count;
- (void)addReadingLensWithGlasses:(IPCSaleserProduct *)glasses ReadingDegree:(NSString *)readingDegree  Count:(NSInteger)count;
- (void)addContactLensWithGlasses:(IPCSaleserProduct *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl Count:(NSInteger)count;
/**
 *   Plus Cart Item
 */
- (void)plusItem:(IPCShoppingCartItem *)cartItem;
- (void)plusGlass:(IPCSaleserProduct *)glass;
/**
 *   Reduce Cart Item
 */
- (void)reduceItem:(IPCShoppingCartItem *)cartItem;
/**
 *   To obtain the corresponding glasses category shopping cart items
 */
- (IPCShoppingCartItem *)normalItemForGlasses:(IPCSaleserProduct *)glasses;
- (IPCShoppingCartItem *)batchLensForGlasses:(IPCSaleserProduct *)glasses Sph:(NSString *)sph Cyl:(NSString *)cyl;
- (IPCShoppingCartItem *)readingLensForGlasses:(IPCSaleserProduct *)glasses ReadingDegree:(NSString *)readingDegree;
- (IPCShoppingCartItem *)contactLensForGlasses:(IPCSaleserProduct *)glasses  ContactDegree:(NSString *)contactDegree;
- (IPCShoppingCartItem *)itemAtIndex:(NSInteger)index;

- (NSArray<IPCShoppingCartItem *> *)batchParameterList:(IPCSaleserProduct *)glasses;
/**
 *   Send the shopping cart number change notification
 */
- (void)postChangedNotification;
/**
    修改商品单价
 */
- (void)updateAllCartUnitPrice;

@end
