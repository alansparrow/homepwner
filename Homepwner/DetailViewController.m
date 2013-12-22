//
//  DetailViewController.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/22/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "DatePickerViewController.h"
#import "BNRImageStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay =
        [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)touchBackground:(id)sender
{
    /*
    [nameField resignFirstResponder];
    [serialNumberField resignFirstResponder];
    [valueField resignFirstResponder];
     */
    [[self view] endEditing:YES];
}

- (IBAction)changeDate:(id)sender {
    DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] init];
    
    [datePickerViewController setItem:[self item]];
    
    [[self navigationController] pushViewController:datePickerViewController
                                           animated:YES];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];

    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)removeImage:(id)sender {
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [imageView setImage:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Use that unique string to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    // Store image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    CFRelease(newUniqueID);
    CFRelease(newUniqueIDString);
    
    // Take image picker off the screen you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
