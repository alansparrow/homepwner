//
//  CustomPopoverBackgroundView.h
//  Homepwner
//
//  Created by Alan Sparrow on 12/24/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPopoverBackgroundView : UIPopoverBackgroundView
{
    UIImageView * _borderImageView;
    UIImageView * _arrowView;
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}

@end
