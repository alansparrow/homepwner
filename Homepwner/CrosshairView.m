//
//  CrosshairView.m
//  Homepwner
//
//  Created by Alan Sparrow on 12/23/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "CrosshairView.h"

@implementation CrosshairView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    CGPoint center;
    center.x = bounds.size.width / 2;
    center.y = bounds.size.height / 2;
    
    // The thickness of the line
    CGContextSetLineWidth(ctx, 3);
    CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1.0);
    
    // Draw vertical line
    CGContextMoveToPoint(ctx, center.x, 0);
    CGContextAddLineToPoint(ctx, center.x, bounds.size.height);
    
    // Draw horizontal line
    CGContextMoveToPoint(ctx, 0, center.y);
    CGContextAddLineToPoint(ctx, bounds.size.width, center.y);
    
    // Draw the path
    CGContextStrokePath(ctx);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
