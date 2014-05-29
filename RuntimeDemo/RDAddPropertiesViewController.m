//
//  RDAddPropertiesViewController.m
//  RuntimeDemo
//
//  Created by Jeremy Conkin on 5/28/14.
//  Copyright (c) 2014 Jeremy Conkin. All rights reserved.
//

#import "RDAddPropertiesViewController.h"

#import <objc/runtime.h>

typedef enum {
 
    DataTypeList_Boolean,
    DataTypeList_Integer,
    DataTypeList_Array,
    DataTypeList_Max
}DataTypeList;

@interface RDAddPropertiesViewController () <UITextFieldDelegate>

/**
 *  Data type to use when adding a new property
 */
@property (assign) DataTypeList currentDataTypeToAdd;

@end

@implementation RDAddPropertiesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.currentDataTypeToAdd = DataTypeList_Boolean;
    
    // Setup data type button
    self.dataTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 100);
    [self updateAddDataTypeButtonText];
    
    // Setup property name text field
    self.propertyNameTextField.delegate = self;
    
    [self setPropertyListInTextView];
}

/**
 *  List the properties of NSObject in the message text view
 */
- (void)setPropertyListInTextView {
    
    NSString *propertyListString = @"NSObject properties\n";
    NSDictionary *temp_jconkin = [RDAddPropertiesViewController propertyTypeDictionaryOfClass:[NSObject class]];
    for (NSObject *propertyKey in temp_jconkin.allKeys) {
        propertyListString = [NSString stringWithFormat:@"%@\n%@ %@", propertyListString, [temp_jconkin objectForKey:propertyKey], propertyKey];
    }
    self.messageTextView.text = propertyListString;
}

#pragma mark - Class methods

/**
 *  Find the pretty print name of a data type
 *
 *  @param dataType Identifier for the data type
 *
 *  @return String name of the type
 */
+ (NSString *)getNameForDataTypeIndex:(DataTypeList)dataType {
    
    NSString *returnValue;
    switch (dataType) {
        case DataTypeList_Boolean:
            returnValue = @"BOOL";
            break;
            
        case DataTypeList_Integer:
            returnValue = @"NSInteger";
            break;
            
        case DataTypeList_Array:
        default:
            returnValue = @"NSArray";
            break;
    }
    
    return returnValue;
}

/*
 * Get a property type
 * @returns A string describing the type of the property
 */
+ (NSString *)propertyTypeStringOfProperty:(objc_property_t) property {
    const char *attr = property_getAttributes(property);
    NSString *const attributes = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];
    
    NSRange const typeRangeStart = [attributes rangeOfString:@"T@\""];  // start of type string
    if (typeRangeStart.location != NSNotFound) {
        NSString *const typeStringWithQuote = [attributes substringFromIndex:typeRangeStart.location + typeRangeStart.length];
        NSRange const typeRangeEnd = [typeStringWithQuote rangeOfString:@"\""]; // end of type string
        if (typeRangeEnd.location != NSNotFound) {
            NSString *const typeString = [typeStringWithQuote substringToIndex:typeRangeEnd.location];
            return typeString;
        }
    }
    return nil;
}

/**
 * Get a dictionary of properties->types for a class's properties
 * @returns (NSString) Dictionary of property name --> type
 */

+ (NSDictionary *)propertyTypeDictionaryOfClass:(Class)klass {
    NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSString *propertyType = [self propertyTypeStringOfProperty:property];
            [propertyMap setValue:propertyType forKey:propertyName];
        }
    }
    free(properties);
    return propertyMap;
}

/**
 *  Set the add data type button text to match the name of the current data type
 */
- (void)updateAddDataTypeButtonText {
    
    [self.dataTypeButton setTitle:[RDAddPropertiesViewController getNameForDataTypeIndex:self.currentDataTypeToAdd]
                         forState:UIControlStateNormal];
}

- (IBAction)selectDataType:(id)sender {
    
    self.dataTypePickerView.hidden = NO;
    [self.propertyNameTextField resignFirstResponder];
}

- (IBAction)addProperty:(id)sender {
    
    NSString *dataTypeString = [NSString stringWithFormat:@"@\"%@\"", [RDAddPropertiesViewController getNameForDataTypeIndex:self.currentDataTypeToAdd]];
    objc_property_attribute_t type = { "T", [dataTypeString UTF8String]};
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t attributes[] = { type, ownership };
    class_addProperty([NSObject class],
                      [self.propertyNameTextField.text UTF8String],
                      attributes,
                      2);
    [self setPropertyListInTextView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    self.dataTypePickerView.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.dataTypePickerView.hidden = YES;
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    
    return DataTypeList_Max;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
    
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [RDAddPropertiesViewController getNameForDataTypeIndex:(DataTypeList)row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    self.dataTypePickerView.hidden = YES;
    self.currentDataTypeToAdd = (DataTypeList)row;
    [self updateAddDataTypeButtonText];
}

@end
