//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/21/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"


@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 20; i++) {
            // Class method
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    [[BNRItemStore sharedStore] sortFromHighToLowValue];
    numOfRowInSection0 = [[BNRItemStore sharedStore] countOfAllItemsMoreThan50];
    if (section == 0)
        return numOfRowInSection0;
    else
        return [[[BNRItemStore sharedStore] allItems] count] - numOfRowInSection0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"UITableViewCell"];
    }
    
    if ([indexPath section] == 0) {
        BNRItem *p = [[[BNRItemStore sharedStore] allItems]
                      objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[p description]];
    } else {
        BNRItem *p = [[[BNRItemStore sharedStore] allItems]
                      objectAtIndex:([indexPath row]+numOfRowInSection0)];
        [[cell textLabel] setText:[p description]];
    }
    
   
    
    NSLog(@"Row: %d | Section: %d", [indexPath row], [indexPath section]);

    
    return cell;
}




@end
