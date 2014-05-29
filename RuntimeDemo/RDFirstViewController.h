//
//  RDFirstViewController.h
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/28/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDFirstViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  Button tapped to select the data type of a new property
 */
@property (nonatomic, weak) IBOutlet UIButton *dataTypeButton;

/**
 * Property name of the property to add is entered here
 */
@property (nonatomic, weak) IBOutlet UITextField *propertyNameTextField;

/**
 *  Picker view used to select new propery's data type
 */
@property (nonatomic, weak) IBOutlet UIPickerView *dataTypePickerView;

/**
 *  Text view that gives status and error messages
 */
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;

/**
 *  Request made to show the data type picker
 *
 *  @param sender Button that made the request
 */
- (IBAction)selectDataType:(id)sender;

/**
 *  Add a property to the default object class
 *
 *  @param sender Button that called this selector
 */
- (IBAction)addProperty:(id)sender;

@end
