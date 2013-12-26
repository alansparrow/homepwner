//
//  AssetTypeCreateViewController.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/26/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTypeCreateViewController : UIViewController <UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *newAssetTypeTextField;
}

- (IBAction)touchBackground:(id)sender;
@property (nonatomic, copy) void (^dismissBlock)(void);
@end
