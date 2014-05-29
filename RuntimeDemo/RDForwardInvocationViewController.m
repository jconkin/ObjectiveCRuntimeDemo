//
//  RDForwardInvocationViewController.m
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/29/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import "RDForwardInvocationViewController.h"

@implementation RDForwardInvocationViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [self performSelector:@selector(setRandomBackgroundColor) withObject:self];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    
    // If the method signature is not found on this class, find it on the
    // random color view
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [self.randomColorView methodSignatureForSelector:selector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // This class does not respond to the selector sent. Try the random color
    // view instead.
    if ([self.randomColorView respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.randomColorView];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end
