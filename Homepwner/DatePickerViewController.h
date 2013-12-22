//
//  DatePickerViewController.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/23/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DatePickerViewController : UIViewController
{
    __weak IBOutlet UIDatePicker *createdDatePicker;
    __weak IBOutlet UILabel *warningLabel;
}

@property (strong, nonatomic) BNRItem *item;

@end
