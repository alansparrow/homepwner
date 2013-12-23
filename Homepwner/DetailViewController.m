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
#import "BNRItemStore.h"
#import "CrosshairView.h"
#import "CustomPopoverBackgroundView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize dismissBlock;
@synthesize item;

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) {
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
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    
    [[self view] setBackgroundColor:clr];
    
    // Fix status bar problem with DetailView xib file
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
    // Prevent crash from clicking Camera while popover is till visible on iPad
    if ([imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        [self popoverControllerDidDismissPopover:imagePickerPopover];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    /* use for Video
    NSArray *availableTypes = [UIImagePickerController
                               availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setMediaTypes:availableTypes];
     */
    
    // If our device has a camera, we want to take a picture, otherwise we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // Add crosshair sign
        CGRect bounds = [[imagePicker view] bounds];
        
        CrosshairView *crosshairView = [[CrosshairView alloc]
                                        initWithFrame:CGRectMake((bounds.size.width / 2)- 20,
                                                                 (bounds.size.height / 2) - 20,
                                                                 40,
                                                                 40)];
        [imagePicker setCameraOverlayView:crosshairView];
        
        //[imagePicker setCameraOverlayView:;]
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc]
                              initWithContentViewController:imagePicker];
        
        // Enable this if you want customized Popover
        //imagePickerPopover.popoverBackgroundViewClass = [CustomPopoverBackgroundView class];
        
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller;
        // sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        [self presentViewController:imagePicker
                           animated:YES   
                         completion:nil];
    }
}

- (IBAction)removeImage:(id)sender {
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [imageView setImage:nil];
}

- (IBAction)takeImageFromLibrary:(id)sender {
    // Prevent crash from clicking Library while popover is till visible on iPad
    if ([imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        [self popoverControllerDidDismissPopover:imagePickerPopover];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    } 
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc]
                              initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller;
        // sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        [self presentViewController:imagePicker
                           animated:YES
                         completion:nil];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Go into this");
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
    
    // In case lacking of memory, this won't display for iPhone (instead iPhone uses viewWillAppear)
    [imageView setImage:image];
    
    // For iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad) {
        [imagePickerPopover dismissPopoverAnimated:YES];
        [self popoverControllerDidDismissPopover:imagePickerPopover];
    } else {
        // Take image picker off the screen you must call this dismiss method
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:item];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

@end
