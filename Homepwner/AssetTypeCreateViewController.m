//
//  AssetTypeCreateViewController.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/26/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "AssetTypeCreateViewController.h"
#import "BNRItemStore.h"

@interface AssetTypeCreateViewController ()

@end

@implementation AssetTypeCreateViewController

@synthesize dismissBlock;

- (id)init
{
    self = [super initWithNibName:@"AssetTypeCreateViewController"
                           bundle:nil];
    
    if (self) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                       target:self
                                       action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelItem];
        
        [[self navigationItem] setTitle:@"New Asset Type"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    // Fix status bar problem with DetailView xib file
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)save:(id)sender
{
    NSLog([newAssetTypeTextField text]);
    if ([[newAssetTypeTextField text] length] > 0) {
        [[BNRItemStore sharedStore]
         addNewAssetType:[newAssetTypeTextField text]];
    }
    
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];

}

- (void)cancel:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

- (IBAction)touchBackground:(id)sender {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self view] endEditing:YES];
    return YES;
}
@end
