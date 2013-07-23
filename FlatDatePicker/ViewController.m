//
//  ViewController.m
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"FlatDatePicker";
    
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Select your birthday";
    self.flatDatePicker.datePickerMode = FlatDatePickerModeTime;
    //self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
}

- (IBAction)actionOpen:(id)sender {
    
    [self.flatDatePicker show];
}

- (IBAction)actionClose:(id)sender {
    
    [self.flatDatePicker dismiss];
}

- (IBAction)actionSetDate:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:@"07-12-1985 15:36:45"];
    
    if (self.flatDatePicker.isOpen) {
         [self.flatDatePicker setDate:date animated:YES];
    } else {
         [self.flatDatePicker setDate:date animated:NO];
    }
}

- (IBAction)actionChangeMode:(id)sender {
    
    if (self.flatDatePicker != nil) {
        
        switch (self.segmentedControlMode.selectedSegmentIndex) {
            case 1:
                [self.flatDatePicker setDatePickerMode:FlatDatePickerModeDate];
                break;
            case 2:
                [self.flatDatePicker setDatePickerMode:FlatDatePickerModeDateAndTime];
                break;
            default:
                [self.flatDatePicker setDatePickerMode:FlatDatePickerModeTime];
                break;
        }
    }
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.labelDateSelected.text = value;
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:@"Did cancelled !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.labelDateSelected.text = value;
    
    NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
  
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)viewDidUnload {
    [self setSegmentedControlMode:nil];
    [super viewDidUnload];
}
@end
