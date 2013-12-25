//
//  DetailViewController.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/22/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UIPopoverControllerDelegate, UIScrollViewDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *changeDateBtn;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
    UIPopoverController *imagePickerPopover;
}
- (id)initForNewItem:(BOOL)isNew;

@property (strong, nonatomic) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)changeDate:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)removeImage:(id)sender;
- (IBAction)takeImageFromLibrary:(id)sender;
- (IBAction)showImage:(id)sender;

@end
