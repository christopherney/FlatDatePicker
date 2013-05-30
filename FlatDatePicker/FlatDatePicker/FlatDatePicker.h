//
//  FlatDatePicker.h
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlatDatePicker;

@protocol FlatDatePickerDelegate<NSObject>

@optional

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date;

@end

@interface FlatDatePicker : UIControl <UIScrollViewDelegate> {
    
    // Parent View :
    UIView *_parentView;
    
    // Header :
    UILabel *_labelTitle;
    UIButton *_buttonClose;
    UIButton *_buttonValid;
    
    // ScrollView :
    UIScrollView *_scollViewDays;
    UIScrollView *_scollViewMonths;
    UIScrollView *_scollViewYears;
    
    // Lines :
    UIView *_lineDaysTop;
    UIView *_lineDaysBottom;
    UIView *_lineMonthsTop;
    UIView *_lineMonthsBottom;
    UIView *_lineYearsTop;
    UIView *_lineYearsBottom;
    
    // Title :
    NSString *_title;
    
    // Days, Months, Years :
    NSMutableArray *_days;
    NSMutableArray *_months;
    NSMutableArray *_years;
    
    // Labels :
    NSMutableArray *_labelsDays;
    NSMutableArray *_labelsMonths;
    NSMutableArray *_labelsYears;
    
    // Date selected :
    int _selectedDay;
    int _selectedMonth;
    int _selectedYear;
}

@property (nonatomic, strong) NSObject<FlatDatePickerDelegate> *delegate;

- (id)initWithParentView:(UIView*)parentView;

- (void)show;
- (void)dismiss;

- (void)setTitle:(NSString *)title;
- (NSString*)title;

- (void)setDate:(NSDate*)date;
- (NSDate*)getDate;

@end

