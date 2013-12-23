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
#import "DetailViewController.h"


@implementation ItemsViewController

- (void)viewDidLoad
{
    // Fix status bar problem with DetailView xib file
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:@"Homepwner"];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
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
    } else {
        [[cell textLabel] setText:@"No more items!"];
    }
    
    NSLog(@"Scrolling: %d", [indexPath row]);
    
    return cell;
}

- (IBAction)addNewItem:(id)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    //[navController setModalPresentationStyle:UIModalPresentationCurrentContext];
    //[self setDefinesPresentationContext:YES];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    else
        [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    // Set modal view
    [self presentViewController:navController
                       animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] != [[[BNRItemStore sharedStore] allItems] count]) {
        
        NSLog(@"%d/%d", [indexPath row], [[[BNRItemStore sharedStore] allItems] count]-1);
        
        // If the table view is asking to commit a delete command...
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            BNRItemStore *ps = [BNRItemStore sharedStore];
            NSArray *items = [ps allItems];
            BNRItem *p = [items objectAtIndex:[indexPath row]];
            [ps removeItem:p];
        
            // We also remove that row from the table view with an animation
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                        toIndex:[destinationIndexPath row]];
    NSLog(@"%d -> %d", [sourceIndexPath row], [destinationIndexPath row]);
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([sourceIndexPath row] == [[[BNRItemStore sharedStore] allItems] count]) {
        return sourceIndexPath;
    } else if ([proposedDestinationIndexPath row] == [[[BNRItemStore sharedStore] allItems] count]) {
        return sourceIndexPath;
    } else
        return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] != [[[BNRItemStore sharedStore] allItems] count]) {
        DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
        
        BNRItem *selectedItem = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
        // Give detail view controller a pointer to the item object in row
        [detailViewController setItem:selectedItem];
        
        // Push it onto the top of the navigation controller's stack
        [[self navigationController] pushViewController:detailViewController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io = UIInterfaceOrientationPortrait);
    }
}
 */
@end
