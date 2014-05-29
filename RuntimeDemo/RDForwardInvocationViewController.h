//
//  RDForwardInvocationViewController.h
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/29/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import "RDRandomColorView.h"

/**
 *  This class demonstrates forward invocation - responding to a selector this
 *  class does not implement by invoking the method call on another object.
 */
@interface RDForwardInvocationViewController : UIViewController

/**
 *  A view that changes color whenever this screen appears
 */
@property (nonatomic, weak) IBOutlet RDRandomColorView *randomColorView;

@end
