//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/21/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <Foundation/Foundation.h>

// Tell the compiler that there is a BNRItem class and that it doesn't need
// to know this class's details in the current file
// This allows us to use the BNRItem symbol in the declaration of createItem
// without importing BNRItem.h
@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

// Notice that this is a class method and prefixed with a '+' instead of a '-'
+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (NSInteger)countOfAllItemsMoreThan50;
- (NSInteger)countOfAllRestItems;
- (void)sortFromHighToLowValue;
@end

