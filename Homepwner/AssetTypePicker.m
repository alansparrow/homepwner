//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/26/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"
#import "AssetTypeCreateViewController.h"

@implementation AssetTypePicker

@synthesize item;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:@"Type"];
        
        // If it is NavigationController, it will ask for this
        // If it is not (Popover), it will not ask for this
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewAssetType:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    
    return self;
}

- (void)addNewAssetType:(id)sender
{
    AssetTypeCreateViewController *avc = [[AssetTypeCreateViewController alloc] init];
    
    // When AssetTypeCreateViewController dismisses, reload table
    [avc setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:avc];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    // Set modal view
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
    
    // Use key-value coding to get the asset type's label
    // Because it is a NSManagedObject, we can use this
    NSString *assetLabel = [assetType valueForKey:@"label"];
    [[cell textLabel] setText:assetLabel];
    
    // Checkmark the one that is currently selected
    if (assetType == [item assetType]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
    [item setAssetType:assetType];
    
    [[self navigationController] popViewControllerAnimated:YES];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didChooseRowInPopover"
                                                            object:self];
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] != [[[BNRItemStore sharedStore] allItems] count]) {
  
        // If the table view is asking to commit a delete command...
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
            NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
            NSString *typeName = [assetType valueForKey:@"label"];
            
            [[BNRItemStore sharedStore] removeAssetType:typeName];
            
            // We also remove that row from the table view with an animation
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

@end
