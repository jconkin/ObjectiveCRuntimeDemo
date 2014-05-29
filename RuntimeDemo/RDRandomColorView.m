//
//  RDRandomColorView.m
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/29/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import "RDRandomColorView.h"

@implementation RDRandomColorView

- (void)setRandomBackgroundColor {
    
    self.backgroundColor = [RDRandomColorView createRandomColor];
}

+ (UIColor *)createRandomColor {
    
    CGFloat red = [RDRandomColorView getRandomRGBFloat];
    CGFloat green = [RDRandomColorView getRandomRGBFloat];
    CGFloat blue = [RDRandomColorView getRandomRGBFloat];
    
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:1.0];
}

/**
 *  Generate a random number to be used in RGB calculation
 *
 *  @return Generated number
 */
+ (CGFloat)getRandomRGBFloat {
    
    static const CGFloat maxNumber = 255.f;
    return (CGFloat)(arc4random_uniform(maxNumber)) / maxNumber;
}

@end
