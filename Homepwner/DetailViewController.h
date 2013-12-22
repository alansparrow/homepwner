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
UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *changeDateBtn;
    __weak IBOutlet UIImageView *imageView;
}

@property (strong, nonatomic) BNRItem *item;

- (IBAction)touchBackground:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)takePicture:(id)sender;

@end
