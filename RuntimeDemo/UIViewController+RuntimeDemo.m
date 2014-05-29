//
//  UIViewController+RuntimeDemo.m
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/29/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import "UIViewController+RuntimeDemo.h"

#import <objc/runtime.h>

@implementation UIViewController (RuntimeDemo)

/**
 *  Setter for viewWillAppearCount
 *
 *  @param viewWillAppearCount Number to use as the associated object
 */
+ (void)setViewWillAppearCount:(NSNumber *)viewWillAppearCount {
    objc_setAssociatedObject(self, @selector(viewWillAppearCount), viewWillAppearCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSNumber *)viewWillAppearCount {
    return objc_getAssociatedObject(self, @selector(viewWillAppearCount));
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        // Get the selectors for the methods to swizzle
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swizzle_viewWillAppear:);
        
        // Get the implementations for the methods to swizzle
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // Have selectors for each method point to the other method's
        // implementations
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

#pragma mark - Method Swizzling

/**
 *  viewWillAppear: with extra code injected. This method implementation is run
 *  when the "viewWillAppear:" message is sent, and the "viewWillAppear:"
 *  implementation is run when this message is sent.
 *
 *  @param animated Animate the view in or don't
 */
- (void)swizzle_viewWillAppear:(BOOL)animated {
    
    // Because this selector calls the implementation for viewWillAppear:, use
    // self to call viewWillAppear:
    [self swizzle_viewWillAppear:animated];
    [[self class] setViewWillAppearCount:[NSNumber numberWithInt:[[[self class] viewWillAppearCount] intValue] + 1]];
    
    NSLog(@"temp_jconkin viewWillAppear: %@ %d", self, [[[self class] viewWillAppearCount] intValue]);
}

@end
