//
//  DatePickerViewController.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/23/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "DatePickerViewController.h"
#import "BNRItem.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [createdDatePicker setDate:[item dateCreated]];
    
    [warningLabel setText:@"This can be considered an insurance fraud!"];
    [warningLabel setTextColor:[UIColor redColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changed date to item
    [item setDateCreated:[createdDatePicker date]];
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:@"Change Date"];
}

@end
