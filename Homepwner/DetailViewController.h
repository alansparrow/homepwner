//
//  DetailViewController.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/22/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
}

@property (strong, nonatomic) BNRItem *item;

- (IBAction)touchBackground:(id)sender;

@end
