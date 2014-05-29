//
//  UIViewController+RuntimeDemo.h
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/29/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Category used for demonstrating method swizzling and associated objects
 */
@interface UIViewController (RuntimeDemo)

/**
 *  Getter for viewWillAppearCount
 *
 *  @return Number used as an associated object
 */
+ (NSNumber *)viewWillAppearCount;

@end
