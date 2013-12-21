//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/21/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

+ (BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return allItems;
}

- (BNRItem *)createItem
{
    BNRItem *p = [BNRItem randomItem];
    
    [allItems addObject:p];

    return p;
}

- (NSInteger)countOfAllItemsMoreThan50
{
    BNRItem *p = nil;
    int count = 0;
    
    for (int i = 0; i < [allItems count]; i++) {
        p = [allItems objectAtIndex:i];
        if (p.valueInDollars > 50)
            count++;
    }
    
    return count;
}

- (NSInteger)countOfAllRestItems
{
    BNRItem *p = nil;
    int count = 0;
    
    for (int i = 0; i < [allItems count]; i++) {
        p = [allItems objectAtIndex:i];
        if (p.valueInDollars <= 50)
            count++;
    }
    
    return count;
}

- (void)sortFromHighToLowValue
{
    [allItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        BNRItem *first = obj1;
        BNRItem *second = obj2;
        
        if (first.valueInDollars < second.valueInDollars)
            return (NSComparisonResult)NSOrderedDescending;
        if (first.valueInDollars > second.valueInDollars)
            return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
}

@end
