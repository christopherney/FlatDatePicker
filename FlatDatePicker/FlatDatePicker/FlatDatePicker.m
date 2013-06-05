//
//  FlatDatePicker.m
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import "FlatDatePicker.h"

// Constants times :
#define kFlatDatePickerAnimationDuration 0.4

// Constants colors :
#define kFlatDatePickerBackgroundColor [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorTitle [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorButtonValid [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorButtonCancel [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorScrolView [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorLines [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0]

// Constants fonts colors :
#define kFlatDatePickerFontColorTitle [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kFlatDatePickerFontColorLabel [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kFlatDatePickerFontColorLabelSelected [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0]

// Constants sizes :
#define kFlatDatePickerHeight 260
#define kFlatDatePickerHeaderHeight 44
#define kFlatDatePickerButtonHeaderWidth 44
#define kFlatDatePickerHeaderBottomMargin 1
#define kFlatDatePickerScrollViewDaysWidth 90
#define kFlatDatePickerScrollViewMonthWidth 140
#define kFlatDatePickerScrollViewLeftMargin 1
#define kFlatDatePickerScrollViewItemHeight 45
#define kFlatDatePickerLineWidth 2
#define kFlatDatePickerLineMargin 15

// Constants fonts
#define kFlatDatePickerFontTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]
#define kFlatDatePickerFontLabel [UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0]
#define kFlatDatePickerFontLabelSelected [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]

// Constants icons
#define kFlatDatePickerIconCancel @"FlatDatePicker-Icon-Close.png"
#define kFlatDatePickerIconValid @"FlatDatePicker-Icon-Check.png"

// Constants :
#define kStartYear 1900
#define TAG_DAYS 1
#define TAG_MONTHS 2
#define TAG_YEARS 3

@interface FlatDatePicker ()

- (void)setupControl;

- (void)buildHeader;
- (void)buildSelectorDays;
- (void)buildSelectorLabelsDays;
- (void)buildSelectorMonths;
- (void)buildSelectorLabelsMonths;
- (void)buildSelectorYears;
- (void)buildSelectorLabelsYears;

- (void)actionButtonCancel;
- (void)actionButtonValid;

- (NSMutableArray*)getYears;
- (NSMutableArray*)getMonths;
- (NSMutableArray*)getDaysInMonth:(NSDate*)date;

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated;
- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index;
- (void)updateSelectedDateAtIndex:(int)index forScrollView:(UIScrollView*)scrollView;

- (NSDate*)convertToDateDay:(int)day month:(int)month year:(int)year;
- (void)updateNumberOfDays;

- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture;
- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture;
- (void)singleTapGestureYearssCaptured:(UITapGestureRecognizer *)gesture;
@end

@implementation FlatDatePicker

-(id)initWithParentView:(UIView*)parentView {
    
    _parentView = parentView;
    
    if ([self initWithFrame:CGRectMake(0.0, _parentView.frame.size.height, _parentView.frame.size.width, kFlatDatePickerHeight)]) {
        [self setupControl];
    }
    return self;
}

-(void)setupControl {
    
    // Set parent View :
    self.hidden = YES;
    [_parentView addSubview:self];
    
    // Default parameters :
    self.calendar = [NSCalendar currentCalendar];
    self.locale = [NSLocale currentLocale];
    self.timeZone = nil;
    
    // Generate collections days, months and years :
    _years = [self getYears];
    _months = [self getMonths];
    _days = [self getDaysInMonth:[NSDate date]];

    // Background :
    self.backgroundColor = kFlatDatePickerBackgroundColor;
    
    // Header DatePicker :
    [self buildHeader];

    // Date Selecotrs :
    [self buildSelectorDays];
    [self buildSelectorMonths];
    [self buildSelectorYears];

    // Defaut Date selected :
    [self setDate:[NSDate date] animated:NO];
}

#pragma mark - Build View

- (void)buildHeader {
    
    // Button Cancel
    _buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kFlatDatePickerButtonHeaderWidth, kFlatDatePickerHeaderHeight)];
    _buttonClose.backgroundColor = kFlatDatePickerBackgroundColorButtonCancel;
    [_buttonClose setImage:[UIImage imageNamed:kFlatDatePickerIconCancel] forState:UIControlStateNormal];
    [_buttonClose addTarget:self action:@selector(actionButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonClose];

    // Button Valid
    _buttonValid = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - kFlatDatePickerButtonHeaderWidth, 0.0, kFlatDatePickerButtonHeaderWidth, kFlatDatePickerHeaderHeight)];
    _buttonValid.backgroundColor = kFlatDatePickerBackgroundColorButtonValid;
    [_buttonValid setImage:[UIImage imageNamed:kFlatDatePickerIconValid] forState:UIControlStateNormal];
    [_buttonValid addTarget:self action:@selector(actionButtonValid) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonValid];

    // Label Title
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(kFlatDatePickerButtonHeaderWidth, 0.0, self.frame.size.width - (kFlatDatePickerHeaderHeight * 2), kFlatDatePickerHeaderHeight)];
    _labelTitle.backgroundColor = kFlatDatePickerBackgroundColorTitle;
    _labelTitle.text = self.title;
    _labelTitle.font = kFlatDatePickerFontTitle;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = kFlatDatePickerFontColorTitle;
    [self addSubview:_labelTitle];
}

- (void)buildSelectorDays {
    
    // ScrollView Days :
    _scollViewDays = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, kFlatDatePickerScrollViewDaysWidth, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewDays.tag = TAG_DAYS;
    _scollViewDays.delegate = self;
    _scollViewDays.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewDays.showsHorizontalScrollIndicator = NO;
    _scollViewDays.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewDays];
    
    _lineDaysTop = [[UIView alloc] initWithFrame:CGRectMake(kFlatDatePickerLineMargin, _scollViewDays.frame.origin.y + (_scollViewDays.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), kFlatDatePickerScrollViewDaysWidth - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(kFlatDatePickerLineMargin, _scollViewDays.frame.origin.y + (_scollViewDays.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), kFlatDatePickerScrollViewDaysWidth - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysBottom];

    // Update ScrollView Data
    [self buildSelectorLabelsDays];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDaysCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewDays addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsDays {
    
    CGFloat offsetContentScrollView = (_scollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsDays != nil && _labelsDays.count > 0) {
        for (UILabel *label in _labelsDays) {
            [label removeFromSuperview];
        }
    }
    
    _labelsDays = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _days.count; i++) {
        
        NSString *day = (NSString*)[_days objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, kFlatDatePickerScrollViewDaysWidth, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsDays addObject:labelDay];
        [_scollViewDays addSubview:labelDay];
    }
    
    _scollViewDays.contentSize = CGSizeMake(kFlatDatePickerScrollViewDaysWidth, (kFlatDatePickerScrollViewItemHeight * _days.count) + (offsetContentScrollView * 2));
}

- (void)buildSelectorMonths {
    
    // ScrollView Months
    
    _scollViewMonths = [[UIScrollView alloc] initWithFrame:CGRectMake(_scollViewDays.frame.size.width + kFlatDatePickerScrollViewLeftMargin, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, kFlatDatePickerScrollViewMonthWidth, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewMonths.tag = TAG_MONTHS;
    _scollViewMonths.delegate = self;
    _scollViewMonths.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewMonths.showsHorizontalScrollIndicator = NO;
    _scollViewMonths.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewMonths];
    
    _lineMonthsTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMonths.frame.origin.y + (_scollViewMonths.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), kFlatDatePickerScrollViewMonthWidth - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineMonthsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineMonthsTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMonths.frame.origin.y + (_scollViewMonths.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), kFlatDatePickerScrollViewMonthWidth - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysBottom];
 
    
    // Update ScrollView Data
    [self buildSelectorLabelsMonths];
}

- (void)buildSelectorLabelsMonths {
    
    CGFloat offsetContentScrollView = (_scollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsMonths != nil && _labelsMonths.count > 0) {
        for (UILabel *label in _labelsMonths) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMonths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _months.count; i++) {
        
        NSString *day = (NSString*)[_months objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, kFlatDatePickerScrollViewMonthWidth, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsMonths addObject:labelDay];
        [_scollViewMonths addSubview:labelDay];
    }
    
    _scollViewMonths.contentSize = CGSizeMake(kFlatDatePickerScrollViewMonthWidth, (kFlatDatePickerScrollViewItemHeight * _months.count) + (offsetContentScrollView * 2));
}

- (void)buildSelectorYears {
    
    // ScrollView Years
    
    _scollViewYears = [[UIScrollView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, self.frame.size.width - (_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin), self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewYears.tag = TAG_YEARS;
    _scollViewYears.delegate = self;
    _scollViewYears.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewYears.showsHorizontalScrollIndicator = NO;
    _scollViewYears.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewYears];
    
    _lineYearsTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewYears.frame.origin.x + kFlatDatePickerLineMargin, _scollViewYears.frame.origin.y + (_scollViewYears.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), kFlatDatePickerScrollViewDaysWidth - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineYearsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineYearsTop];
    
    _lineYearsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewYears.frame.origin.x + kFlatDatePickerLineMargin, _scollViewYears.frame.origin.y + (_scollViewYears.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), kFlatDatePickerScrollViewDaysWidth - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineYearsBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineYearsBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsYears];
}

- (void)buildSelectorLabelsYears {
    
    CGFloat offsetContentScrollView = (_scollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;

    if (_labelsYears != nil && _labelsYears.count > 0) {
        for (UILabel *label in _labelsYears) {
            [label removeFromSuperview];
        }
    }
    
    _labelsYears = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _years.count; i++) {
        
        NSString *day = (NSString*)[_years objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, self.frame.size.width - (_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin), kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsYears addObject:labelDay];
        [_scollViewYears addSubview:labelDay];
    }
    
    _scollViewYears.contentSize = CGSizeMake(self.frame.size.width - (_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin), (kFlatDatePickerScrollViewItemHeight * _years.count) + (offsetContentScrollView * 2));
}

#pragma mark - Actions 

- (void)actionButtonCancel {
    
    [self dismiss];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:didCancel:)]) {
        [self.delegate flatDatePicker:self didCancel:_buttonClose];
    }
}

- (void)actionButtonValid {
    
    [self dismiss];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:didValid:date:)]) {
        [self.delegate flatDatePicker:self didValid:_buttonValid date:[self getDate]];
    }
}

#pragma mark - Show and Dismiss

-(void)show {
    
    if (self.hidden == YES) {
        self.hidden = NO;
    }
    
    if (_isInitialized == NO) {
        self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);
        _isInitialized = YES;
    }

    int indexDays = [self getIndexForScrollViewPosition:_scollViewDays];
    [self highlightLabelInArray:_labelsDays atIndex:indexDays];
    
    int indexMonths = [self getIndexForScrollViewPosition:_scollViewMonths];
    [self highlightLabelInArray:_labelsMonths atIndex:indexMonths];
    
    int indexYears = [self getIndexForScrollViewPosition:_scollViewYears];
    [self highlightLabelInArray:_labelsYears atIndex:indexYears];
    
    [UIView beginAnimations:@"FlatDatePickerShow" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height - kFlatDatePickerHeight, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)dismiss {
    
    [UIView beginAnimations:@"FlatDatePickerShow" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark - Title DatePicker

-(void)setTitle:(NSString *)title {
    _title = title;
    _labelTitle.text = _title;
}

-(NSString*)title {
    return _title;
}

#pragma mark - Collections

- (NSMutableArray*)getYears {
    
    NSMutableArray *years = [[NSMutableArray alloc] init];

    NSDate *currentDate = [NSDate date];
    
    NSDateComponents* components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    int year = [components year];
    
    for (int i = kStartYear; i <= year; i++) {
        
        [years addObject:[NSString stringWithFormat:@"%d", i]];
    }
         
    return years;
}

- (NSMutableArray*)getMonths {
    
    NSMutableArray *months = [[NSMutableArray alloc] init];
    
    for (int monthNumber = 1; monthNumber <= 12; monthNumber++) {
        
        NSString *dateString = [NSString stringWithFormat: @"%d", monthNumber];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        if (self.timeZone != nil) [dateFormatter setTimeZone:self.timeZone];
        [dateFormatter setLocale:self.locale];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (self.timeZone != nil) [dateFormatter setTimeZone:self.timeZone];
        [dateFormatter setLocale:self.locale];
        [formatter setDateFormat:@"MMMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        [months addObject:stringFromDate];
    }
  
    return months;
}

- (NSMutableArray*)getDaysInMonth:(NSDate*)date {

    if (date == nil)  date = [NSDate date];
    
    NSRange daysRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= daysRange.length; i++) {
        
        [days addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    return days;
}

#pragma mark - UIScrollView Delegate

- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture
{
    /*
    CGPoint touchPoint = [gesture locationInView:_scollViewDays];

    NSLog(@"%f", touchPoint.y);
    
    if (touchPoint.y < (_lineDaysTop.frame.origin.y - _scollViewDays.frame.origin.y)) {
        
        _selectedDay -= 1;
        [self updateNumberOfDays];
        
    } else if (touchPoint.y > (_lineDaysBottom.frame.origin.y - _scollViewDays.frame.origin.y)) {
        
        _selectedDay += 1;
        [self updateNumberOfDays];
    }
     */
}

- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture {
    
}

- (void)singleTapGestureYearssCaptured:(UITapGestureRecognizer *)gesture {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self updateSelectedDateAtIndex:index forScrollView:scrollView];

    if (scrollView.tag == TAG_DAYS) {
        [self highlightLabelInArray:_labelsDays atIndex:index];
    } else if (scrollView.tag == TAG_MONTHS) {
        [self highlightLabelInArray:_labelsMonths atIndex:index];
    } else if (scrollView.tag == TAG_YEARS) {
        [self highlightLabelInArray:_labelsYears atIndex:index];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    int index = [self getIndexForScrollViewPosition:scrollView];

    [self updateSelectedDateAtIndex:index forScrollView:scrollView];

    [self setScrollView:scrollView atIndex:index animated:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
        [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int index = [self getIndexForScrollViewPosition:scrollView];

    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    
    [self setScrollView:scrollView atIndex:index animated:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
        [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
    }
}

- (void)updateSelectedDateAtIndex:(int)index forScrollView:(UIScrollView*)scrollView {
    
    if (scrollView.tag == TAG_DAYS) {
        _selectedDay = index + 1;
    } else if (scrollView.tag == TAG_MONTHS) {
        
        _selectedMonth = index + 1;
        
        // Updates days :
        [self updateNumberOfDays];

    } else if (scrollView.tag == TAG_YEARS) {
        
        _selectedYear = kStartYear + index;
        
        // Updates days :
        [self updateNumberOfDays];
    }
}

- (void)updateNumberOfDays {
    
    // Updates days :
    NSDate *date = [self convertToDateDay:1 month:_selectedMonth year:_selectedYear];
    
    if (date != nil) {
        
        NSMutableArray *newDays = [self getDaysInMonth:date];
        
        if (newDays.count != _days.count) {
            
            _days = newDays;
            
            [self buildSelectorLabelsDays];
            
            if (_selectedDay > _days.count) {
                _selectedDay = _days.count;
            }
            
            [self highlightLabelInArray:_labelsDays atIndex:_selectedDay - 1];
        }
    }
}

- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {

    CGFloat offsetContentScrollView = (scrollView.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat index = floorf((offetY + offsetContentScrollView) / kFlatDatePickerScrollViewItemHeight);
    index = (index - 1);
    return index;
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated {
    
    if (animated) {
        [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }

    scrollView.contentOffset = CGPointMake(0.0, (index * kFlatDatePickerScrollViewItemHeight));
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index {
    
    if (labels != nil) {
        
        for (int i = 0; i < labels.count; i++) {
            
            UILabel *label = (UILabel*)[labels objectAtIndex:i];
            
            if (i == index) {
                label.textColor = kFlatDatePickerFontColorLabelSelected;
                label.font = kFlatDatePickerFontLabelSelected;
            } else {
                label.textColor = kFlatDatePickerFontColorLabel;
                label.font = kFlatDatePickerFontLabel;
            }
        }
    }
}

#pragma mark - Date

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    
    if (date != nil) {
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
       
        _selectedDay = [components day];
        [self setScrollView:_scollViewDays atIndex:(_selectedDay - 1) animated:animated];

        _selectedMonth = [components month];
        [self setScrollView:_scollViewMonths atIndex:(_selectedMonth - 1) animated:animated];
        
        _selectedYear = [components year];
        [self setScrollView:_scollViewYears atIndex:(_selectedYear - kStartYear) animated:animated];
        
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
            [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
        }
    }
}

- (NSDate*)convertToDateDay:(int)day month:(int)month year:(int)year; {
    
    NSMutableString *dateString = [[NSMutableString alloc] init];
    
    if (day < 10) {
        [dateString appendFormat:@"0%d-", day];
    } else {
        [dateString appendFormat:@"%d-", day];
    }
    
    if (month < 10) {
        [dateString appendFormat:@"0%d-", month];
    } else {
        [dateString appendFormat:@"%d-", month];
    }
    
    [dateString appendFormat:@"%d", year];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (self.timeZone != nil) [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setLocale:self.locale];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
	
    return [dateFormatter dateFromString:dateString];
}

- (NSDate*)getDate {
    
    return [self convertToDateDay:_selectedDay month:_selectedMonth year:_selectedYear];
}

@end
