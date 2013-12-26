//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/21/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

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
        // Read in Homepwner.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // WHere does the SQLite file go?
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
         [NSException raise:@"Open failed"
                     format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        // The managed object context can manage undo, but we don't need it
        [context setUndoManager:nil];
        
        [self loadAllItems];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return allItems;
}


// Here too, created object has connection to Database
// It reflexes changes when 'saveChanges:' runs
- (BNRItem *)createItem
{
    double order;
    if ([allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[allItems lastObject] orderingValue] + 1.0 ;
    }
    NSLog(@"Adding after %d items, order = %.2f",
          [allItems count], order);
    BNRItem *p = [NSEntityDescription
                  insertNewObjectForEntityForName:@"BNRItem"
                  inManagedObjectContext:context];
    [p setOrderingValue:order];
    
    [allItems addObject:p];
    
    return p;
}

- (void)removeItem:(BNRItem *)p
{
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    // Delete in Database
    [context deleteObject:p];
    [allItems removeObjectIdenticalTo:p];
}

- (void)removeAssetType:(NSString *)assetTypeName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRAssetType"];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"label = %@",
                                      assetTypeName];
    [request setEntity:e];
    [request setPredicate:predicateTemplate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason %@",
         [error localizedDescription]];
    }
    NSManagedObject *typeObject = [result objectAtIndex:0];
    
    // Remove it
    [context deleteObject:typeObject];
    NSLog(@"Num of types-bf: %d", [allAssetTypes count]);
    [allAssetTypes removeObjectIdenticalTo:typeObject];
    NSLog(@"Num of types-at: %d", [allAssetTypes count]);
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved so we can re-insert it
    BNRItem *p = [allItems objectAtIndex:from];
    
    // Remove p from array
    [allItems removeObjectAtIndex:from];
    
    // Insert p in array at new location
    [allItems insertObject:p atIndex:to];
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (to > 0) {
        lowerBound = [[allItems objectAtIndex:to -1] orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (to < [allItems count] - 1) {
        upperBound = [[allItems objectAtIndex:to+1] orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:to - 1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    [p setOrderingValue:newOrderValue];
    
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
 
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}




- (void)loadAllItems
{
    if (!allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName]
                                  objectForKey:@"BNRItem"];
        [request setEntity:e];
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@",
             [error localizedDescription]];
        }
        
        // Here is the connection between each BNRItem object
        // in allItems and in Database (individually)
        // All objects are taken from result so each of them
        // has ability to reflex changes from itself to
        // Database when 'saveChanges:' run
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes
{
    if (!allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRAssetType"];
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@",
             [error localizedDescription]];
        }
        allAssetTypes = [result mutableCopy];
    }
    
    // Is this the first time the program is being run?
    if ([allAssetTypes count] == 0) {
        [self addNewAssetType:@"Furniture"];
        [self addNewAssetType:@"Jewelry"];
        [self addNewAssetType:@"Electronics"];
        
    }
    
    return allAssetTypes;
}

- (void)addNewAssetType:(NSString *)newAssetType
{
    NSManagedObject *type;
    
    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                         inManagedObjectContext:context];
    [type setValue:newAssetType forKey:@"label"];
    [allAssetTypes addObject:type];
}

@end
