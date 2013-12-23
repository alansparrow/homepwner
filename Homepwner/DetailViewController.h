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
UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *changeDateBtn;
    __weak IBOutlet UIImageView *imageView;
    UIPopoverController *imagePickerPopover;
}
- (id)initForNewItem:(BOOL)isNew;

@property (strong, nonatomic) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)touchBackground:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)removeImage:(id)sender;
- (IBAction)takeImageFromLibrary:(id)sender;

@end
