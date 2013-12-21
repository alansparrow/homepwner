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

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 30; i++) {
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

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
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
    
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    if ([indexPath row] < [[[BNRItemStore sharedStore] allItems] count]) {
        BNRItem *p = [[[BNRItemStore sharedStore] allItems]
                      objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[p description]];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:20]];
    } else {
        [[cell textLabel] setText:@"No more items!"];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:15]];
    }
    NSLog(@"Scrolling: %d/%d", [indexPath row], [[[BNRItemStore sharedStore] allItems] count]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] < [[[BNRItemStore sharedStore] allItems] count])
        return 60;
    else
        return 44;
    
}



@end
