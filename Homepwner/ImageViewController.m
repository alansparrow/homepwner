//
//  ImageViewController.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/25/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize image;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scrollView setDelegate:self];
    
    CGSize sz = [[self image] size];
    [scrollView setContentSize:CGSizeMake(sz.width, sz.height)];
    //[scrollView setContentSize:sz];
    [imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    
    [imageView setImage:[self image]];
    
    // Setup for zooming
    [scrollView setMinimumZoomScale:0.5];
    [scrollView setMaximumZoomScale:5.0];
    [scrollView setZoomScale:0.5 animated:YES];
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


@end
