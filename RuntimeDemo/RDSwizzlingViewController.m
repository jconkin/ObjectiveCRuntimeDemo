//
//  RDSwizzlingViewController.m
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/28/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import "RDSwizzlingViewController.h"

#import "RDAddPropertiesViewController.h"
#import "RDForwardInvocationViewController.h"
#import "UIViewController+RuntimeDemo.h"

@interface RDSwizzlingViewController ()

/**
 *  View controller classes to monitor appearance counts
 */
@property (nonatomic, strong) NSArray *viewControllerClasses;

/**
 *  Labels that hold the count of how many times a view controller appeared
 */
@property (nonatomic, strong) NSMutableArray *classAppearedLabels;

@end

@implementation RDSwizzlingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addViewControllerLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateViewControllerCountLabels];
}

/**
 *  Create a name and number label for every view controller for which we are
 *  tracking the number of appearances.
 */
- (void)addViewControllerLabels {
    
    self.viewControllerClasses = @[[RDAddPropertiesViewController class],
                                   [RDForwardInvocationViewController class],
                                   [RDSwizzlingViewController class]];
    
    self.classAppearedLabels = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < self.viewControllerClasses.count; ++i) {
        NSString *className = NSStringFromClass([self.viewControllerClasses objectAtIndex:i]);
        [self addClassLabelsForClassNamed:className
                                  atIndex:i];
    }
    
}

/**
 *  Create labels for a class name and its appear count. Then add the labels as
 *  subviews.
 *
 *  @param className Name of the view controller class to track
 *  @param index     Index into our count of view controllers to track
 */
- (void)addClassLabelsForClassNamed:(NSString *)className
                            atIndex:(NSUInteger)index {
    
    UILabel *nameLabel = [UILabel new];
    [self.view addSubview:nameLabel];
    nameLabel.text = className;
    
    UILabel *appearCountLabel = [UILabel new];
    [self.view addSubview:appearCountLabel];
    
    // Add constraints
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    appearCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    appearCountLabel.textAlignment = NSTextAlignmentRight;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(nameLabel, appearCountLabel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[nameLabel(==285)]"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[appearCountLabel(==20)]-10-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    NSString *heightConstraintString = [NSString stringWithFormat:@"V:|-%d-[nameLabel(==30)]", 180 + (35 * index)];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightConstraintString
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:appearCountLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nameLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:appearCountLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nameLabel
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // Keep the number label for updating
    [self.classAppearedLabels addObject:appearCountLabel];
}

/**
 *  Display the viewWillAppear counts for all tracked view controller classes
 */
- (void)updateViewControllerCountLabels {
    
    for (NSUInteger i = 0; i < self.viewControllerClasses.count; ++i) {
        Class viewControllerClass = [self.viewControllerClasses objectAtIndex:i];
        NSNumber *appearCount = [viewControllerClass viewWillAppearCount];
        UILabel *countLabel = [self.classAppearedLabels objectAtIndex:i];
        countLabel.text = [NSString stringWithFormat:@"%d", [appearCount intValue]];
    }
}

@end
