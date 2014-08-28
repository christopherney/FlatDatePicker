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
#define kFlatDatePickerBackgroundColor self.backgroundColor
#define kFlatDatePickerBackgroundColorTitle self.backgroundColorTitle
#define kFlatDatePickerBackgroundColorButtonValid self.backgroundColorButtonValid
#define kFlatDatePickerBackgroundColorButtonCancel self.backgroundColorButtonCancel
#define kFlatDatePickerBackgroundColorScrolView self.backgroundColorScrollView
#define kFlatDatePickerBackgroundColorLines self.backgroundColorLines
#define kFlatDatePickerBackgroundColorSelected self.backgroundColorSelected;

// Constants fonts colors :
#define kFlatDatePickerFontColorTitle self.fontColorTitle
#define kFlatDatePickerFontColorLabel self.fontColorLabel
#define kFlatDatePickerFontColorLabelSelected self.fontColorLabelSelected

// Constants sizes :
#define kFlatDatePickerHeight 260
#define kFlatDatePickerHeaderHeight ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 44 : (self.title == nil || self.title.length == 0) ? 0 : 44)
#define kFlatDatePickerButtonHeaderWidth 44
#define kFlatDatePickerHeaderBottomMargin 1
#define kFlatDatePickerScrollViewDaysWidth 90
#define kFlatDatePickerScrollViewMonthWidth 140
#define kFlatDatePickerScrollViewDateWidth 165
#define kFlatDatePickerScrollViewLeftMargin 1
#define kFlatDatePickerScrollViewItemHeight 45
#define kFlatDatePickerLineWidth 1
#define kFlatDatePickerLineMargin 15

// Constants fonts
#define kFlatDatePickerFontTitle self.fontTitle;
#define kFlatDatePickerFontLabel self.fontLabel;
#define kFlatDatePickerFontLabelSelected self.fontLabelSelected;

// Constants icons
#define kFlatDatePickerIconCancel @"FlatDatePicker-Icon-Close.png"
#define kFlatDatePickerIconValid @"FlatDatePicker-Icon-Check.png"

// Constants :
#define kStartYear ( self.minimumDate == nil ? 1900 : [self yearOfDate:self.minimumDate] )
#define TAG_DAYS 1
#define TAG_MONTHS 2
#define TAG_YEARS 3
#define TAG_HOURS 4
#define TAG_MINUTES 5
#define TAG_SECONDS 6
#define TAG_DATES 7

// Macros
#define IS_PHONE  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@interface FlatDatePicker ()

- (void)buildHeader;

- (void)buildSelectorDaysOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsDays;
- (void)removeSelectorDays;

- (void)buildSelectorMonthsOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsMonths;
- (void)removeSelectorMonths;

- (void)buildSelectorYearsOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsYears;
- (void)removeSelectorYears;

- (void)buildSelectorDatesOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsDates;
- (void)removeSelectorDates;

- (void)buildSelectorHoursOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsHours;
- (void)removeSelectorHours;

- (void)buildSelectorMinutesOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsMinutes;
- (void)removeSelectorMinutes;

- (void)buildSelectorSecondsOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsSeconds;
- (void)removeSelectorSeconds;

- (void)actionButtonCancel;
- (void)actionButtonValid;

- (NSMutableArray*)getYears;
- (NSMutableArray*)getMonths;
- (NSMutableArray*)getDaysInMonth:(NSDate*)date;
- (NSMutableArray*)getDates;

- (NSMutableArray*)getHours;
- (NSMutableArray*)getMinutes;
- (NSMutableArray*)getSeconds;

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated;
- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index;
- (void)updateSelectedDateAtIndex:(int)index forScrollView:(UIScrollView*)scrollView;

- (NSDate*)convertToDateDay:(int)day month:(int)month year:(int)year hours:(int)hours minutes:(int)minutes seconds:(int)seconds date:(NSDate*)date;
- (void)updateNumberOfDays;

- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture;
- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture;
- (void)singleTapGestureYearsCaptured:(UITapGestureRecognizer *)gesture;

- (void)singleTapGestureDatesCaptured:(UITapGestureRecognizer *)gesture;

- (void)singleTapGestureHoursCaptured:(UITapGestureRecognizer *)gesture;
- (void)singleTapGestureMinutesCaptured:(UITapGestureRecognizer *)gesture;
- (void)singleTapGestureSecondsCaptured:(UITapGestureRecognizer *)gesture;

- (void)animationShowDidFinish;
- (void)animationDismissDidFinish;

@end

@implementation FlatDatePicker

#pragma mark -
#pragma mark Helpers

- (NSInteger) yearOfDate:(NSDate*)date {
	NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:date];
	return components.year;
}

#pragma mark - Initializers

-(id)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        _datePickerMode = FlatDatePickerModeDate;
        
        // Default Colors.
        self.backgroundColor = [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
        self.backgroundColorTitle = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        self.backgroundColorButtonValid = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];
        self.backgroundColorButtonCancel = [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
        self.backgroundColorScrollView = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        self.backgroundColorLines = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];
        self.backgroundColorSelected = [UIColor clearColor];
        
        self.fontColorTitle          = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        self.fontColorLabel          = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        self.fontColorLabelSelected  = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];

        // Default fonts.
        self.fontTitle = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        self.fontLabel = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0];
        self.fontLabelSelected = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
        
        [self setupControl];
    }
    return self;
}

-(id)initWithParentView:(UIView*)parentView {
    
    _parentView = parentView;
    
    if ([self initWithFrame:CGRectMake(0.0, _parentView.frame.size.height, _parentView.frame.size.width, kFlatDatePickerHeight)]) {
        _datePickerMode = FlatDatePickerModeDate;
        [_parentView addSubview:self];
        [self setupControl];
    }
    return self;
}

-(void)setupControl {
    
    // Set parent View :
    self.hidden = YES;
    
    // Clear old selectors
    [self removeSelectorYears];
    [self removeSelectorMonths];
    [self removeSelectorDays];
    [self removeSelectorHours];
    [self removeSelectorMinutes];
    [self removeSelectorSeconds];

    // Default parameters :
    self.calendar = [NSCalendar currentCalendar];
    self.locale = [NSLocale currentLocale];
    self.timeZone = nil;

    // Background :
    self.backgroundColor = kFlatDatePickerBackgroundColor;
    
    // Header DatePicker :
    [self buildHeader];

    // Only Month and Year Date Selectors :
    if ( self.datePickerMode == FlatDatePickerModeMonthAndYear ) {
        _years = [self getYears];
        _months = [self getMonths];
        
        [self buildSelectorMonthsOffsetX:0.0 andWidth:kFlatDatePickerScrollViewMonthWidth];
        [self buildSelectorYearsOffsetX:(_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin) andWidth:(self.frame.size.width - (_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin))];
    }
    
    // Date Selectors :
    if (self.datePickerMode == FlatDatePickerModeDate ) {
        
        _years = [self getYears];
        _months = [self getMonths];
        _days = [self getDaysInMonth:[NSDate date]];
        
        [self buildSelectorDaysOffsetX:0.0 andWidth:kFlatDatePickerScrollViewDaysWidth];
        [self buildSelectorMonthsOffsetX:(_scollViewDays.frame.size.width + kFlatDatePickerScrollViewLeftMargin) andWidth:kFlatDatePickerScrollViewMonthWidth];
        [self buildSelectorYearsOffsetX:(_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin) andWidth:(self.frame.size.width - (_scollViewMonths.frame.origin.x + _scollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin))];
    }
    
    // Time Selectors :
    if (self.datePickerMode == FlatDatePickerModeTime) {
        
        _hours = [self getHours];
        _minutes = [self getMinutes];
        _seconds = [self getSeconds];

        [self buildSelectorHoursOffsetX:0.0 andWidth:((self.frame.size.width / 3.0) - kFlatDatePickerScrollViewLeftMargin)];
        [self buildSelectorMinutesOffsetX:(self.frame.size.width / 3.0) andWidth:((self.frame.size.width / 3.0) - kFlatDatePickerScrollViewLeftMargin)];
        [self buildSelectorSecondsOffsetX:((self.frame.size.width / 3.0) * 2.0) andWidth:(self.frame.size.width / 3.0)];
    }
    
    // Date & Time Selectors :
    if (self.datePickerMode == FlatDatePickerModeDateAndTime) {
        
        _dates = [self getDates];
        _hours = [self getHours];
        _minutes = [self getMinutes];

        [self buildSelectorDatesOffsetX:0.0 andWidth:kFlatDatePickerScrollViewDateWidth];
        [self buildSelectorHoursOffsetX:(kFlatDatePickerScrollViewDateWidth + kFlatDatePickerScrollViewLeftMargin) andWidth:(((self.frame.size.width - kFlatDatePickerScrollViewDateWidth) / 2.0) - kFlatDatePickerScrollViewLeftMargin)];
        [self buildSelectorMinutesOffsetX:(kFlatDatePickerScrollViewDateWidth + kFlatDatePickerScrollViewLeftMargin + ((self.frame.size.width - kFlatDatePickerScrollViewDateWidth) / 2.0)) andWidth:(((self.frame.size.width - kFlatDatePickerScrollViewDateWidth) / 2.0) - kFlatDatePickerScrollViewLeftMargin)];
    }

    // Defaut Date selected :
    [self setDate:[NSDate date] animated:NO];
}

#pragma mark - Build Header View

- (void)buildHeader {
    
    // Button Cancel
    NSLog(@"kFlatDatePickerHeaderHeight: %d", kFlatDatePickerHeaderHeight);
    _buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kFlatDatePickerButtonHeaderWidth, kFlatDatePickerHeaderHeight)];
    _buttonClose.hidden = !IS_PHONE;
    _buttonClose.backgroundColor = kFlatDatePickerBackgroundColorButtonCancel;
    [_buttonClose setImage:[UIImage imageNamed:kFlatDatePickerIconCancel] forState:UIControlStateNormal];
    [_buttonClose addTarget:self action:@selector(actionButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonClose];

    // Button Valid
    _buttonValid = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - kFlatDatePickerButtonHeaderWidth, 0.0, kFlatDatePickerButtonHeaderWidth, kFlatDatePickerHeaderHeight)];
    _buttonValid.hidden = !IS_PHONE;
    _buttonValid.backgroundColor = kFlatDatePickerBackgroundColorButtonValid;
    [_buttonValid setImage:[UIImage imageNamed:kFlatDatePickerIconValid] forState:UIControlStateNormal];
    [_buttonValid addTarget:self action:@selector(actionButtonValid) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonValid];

    // Label Title
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(kFlatDatePickerButtonHeaderWidth, 0.0, self.frame.size.width - (kFlatDatePickerHeaderHeight * 2), kFlatDatePickerHeaderHeight)];
    _labelTitle.backgroundColor = kFlatDatePickerBackgroundColorTitle;
    _labelTitle.text = self.title;
    _labelTitle.hidden = (self.title == nil || self.title.length == 0);
    _labelTitle.font = kFlatDatePickerFontTitle;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = kFlatDatePickerFontColorTitle;
    [self addSubview:_labelTitle];
}

#pragma mark - Build Selector Days

- (void)buildSelectorDaysOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Days :
    _scollViewDays = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewDays.tag = TAG_DAYS;
    _scollViewDays.delegate = self;
    _scollViewDays.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewDays.showsHorizontalScrollIndicator = NO;
    _scollViewDays.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewDays];
    
    _lineDaysTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewDays.frame.origin.x + kFlatDatePickerLineMargin, _scollViewDays.frame.origin.y + (_scollViewDays.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewDays.frame.origin.x + kFlatDatePickerLineMargin, _scollViewDays.frame.origin.y + (_scollViewDays.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
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
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewDays.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsDays addObject:labelDay];
        [_scollViewDays addSubview:labelDay];
    }
    
    _scollViewDays.contentSize = CGSizeMake(_scollViewDays.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _days.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorDays {
    
    if (_scollViewDays != nil) {
        [_scollViewDays removeFromSuperview];
        _scollViewDays = nil;
    }
    if (_lineDaysTop != nil) {
        [_lineDaysTop removeFromSuperview];
        _lineDaysTop = nil;
    }
    if (_lineDaysBottom != nil) {
        [_lineDaysBottom removeFromSuperview];
        _lineDaysBottom = nil;
    }
}

#pragma mark - Build Selector Months

- (void)buildSelectorMonthsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Months
    
    _scollViewMonths = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewMonths.tag = TAG_MONTHS;
    _scollViewMonths.delegate = self;
    _scollViewMonths.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewMonths.showsHorizontalScrollIndicator = NO;
    _scollViewMonths.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewMonths];
    
    _lineMonthsTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMonths.frame.origin.y + (_scollViewMonths.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineMonthsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineMonthsTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMonths.frame.origin.y + (_scollViewMonths.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysBottom];
 
    
    // Update ScrollView Data
    [self buildSelectorLabelsMonths];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureMonthsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewMonths addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsMonths {
    
    CGFloat offsetContentScrollView = self.datePickerMode == FlatDatePickerModeMonthAndYear ?
                                            (_scollViewMonths.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 :
                                            (_scollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 ;
    
    if (_labelsMonths != nil && _labelsMonths.count > 0) {
        for (UILabel *label in _labelsMonths) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMonths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _months.count; i++) {
        
        NSString *day = (NSString*)[_months objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewMonths.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsMonths addObject:labelDay];
        [_scollViewMonths addSubview:labelDay];
    }
    
    _scollViewMonths.contentSize = CGSizeMake(_scollViewMonths.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _months.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorMonths {
    
    if (_scollViewMonths != nil) {
        [_scollViewMonths removeFromSuperview];
        _scollViewMonths = nil;
    }
    if (_lineMonthsTop != nil) {
        [_lineMonthsTop removeFromSuperview];
        _lineMonthsTop = nil;
    }
    if (_lineMonthsBottom != nil) {
        [_lineMonthsBottom removeFromSuperview];
        _lineMonthsBottom = nil;
    }
}

#pragma mark - Build Selector Years

- (void)buildSelectorYearsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Years
    
    _scollViewYears = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewYears.tag = TAG_YEARS;
    _scollViewYears.delegate = self;
    _scollViewYears.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewYears.showsHorizontalScrollIndicator = NO;
    _scollViewYears.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewYears];
    
    _lineYearsTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewYears.frame.origin.x + kFlatDatePickerLineMargin, _scollViewYears.frame.origin.y + (_scollViewYears.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineYearsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineYearsTop];
    
    _lineYearsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewYears.frame.origin.x + kFlatDatePickerLineMargin, _scollViewYears.frame.origin.y + (_scollViewYears.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineYearsBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineYearsBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsYears];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureYearsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewYears addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsYears {
    
    CGFloat offsetContentScrollView = self.datePickerMode == FlatDatePickerModeMonthAndYear ?
                                            (_scollViewMonths.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 :
                                            (_scollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 ;

    if (_labelsYears != nil && _labelsYears.count > 0) {
        for (UILabel *label in _labelsYears) {
            [label removeFromSuperview];
        }
    }
    
    _labelsYears = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _years.count; i++) {
        
        NSString *day = (NSString*)[_years objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewYears.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsYears addObject:labelDay];
        [_scollViewYears addSubview:labelDay];
    }
    
    _scollViewYears.contentSize = CGSizeMake(_scollViewYears.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _years.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorYears {
    
    if (_scollViewYears != nil) {
        [_scollViewYears removeFromSuperview];
        _scollViewYears = nil;
    }
    if (_lineYearsTop != nil) {
        [_lineYearsTop removeFromSuperview];
        _lineYearsTop = nil;
    }
    if (_lineYearsBottom != nil) {
        [_lineYearsBottom removeFromSuperview];
        _lineYearsBottom = nil;
    }
}

#pragma mark - Build Selector Dates

- (void)buildSelectorDatesOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Dates
    
    _scollViewDates = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewDates.tag = TAG_DATES;
    _scollViewDates.delegate = self;
    _scollViewDates.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewDates.showsHorizontalScrollIndicator = NO;
    _scollViewDates.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewDates];
    
    _lineDatesTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewDates.frame.origin.x + kFlatDatePickerLineMargin, _scollViewDates.frame.origin.y + (_scollViewDates.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDatesTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDatesTop];
    
    _lineDatesBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewDates.frame.origin.x + kFlatDatePickerLineMargin, _scollViewDates.frame.origin.y + (_scollViewDates.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDatesBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDatesBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsDates];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDatesCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewDates addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsDates {
    
    CGFloat offsetContentScrollView = (_scollViewDates.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsDates != nil && _labelsDates.count > 0) {
        for (UILabel *label in _labelsDates) {
            [label removeFromSuperview];
        }
    }
    
    _labelsDates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    
    for (int i = 0; i < _dates.count; i++) {
        
        NSDate *date = [_dates objectAtIndex:i];
        
        NSString *hour = [dateFormatter stringFromDate:date];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewDates.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDate.text = hour;
        labelDate.font = kFlatDatePickerFontLabel;
        labelDate.textAlignment = NSTextAlignmentCenter;
        labelDate.textColor = kFlatDatePickerFontColorLabel;
        labelDate.backgroundColor = [UIColor clearColor];
        
        [_labelsDates addObject:labelDate];
        [_scollViewDates addSubview:labelDate];
    }
    
    _scollViewDates.contentSize = CGSizeMake(_scollViewDates.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _dates.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorDates {
    
    if (_scollViewDates != nil) {
        [_scollViewDates removeFromSuperview];
        _scollViewDates = nil;
    }
    if (_lineDatesTop != nil) {
        [_lineDatesTop removeFromSuperview];
        _lineDatesTop = nil;
    }
    if (_lineDatesBottom != nil) {
        [_lineDatesBottom removeFromSuperview];
        _lineDatesBottom = nil;
    }
}

#pragma mark - Build Selector Hours

- (void)buildSelectorHoursOffsetX:(CGFloat)x andWidth:(CGFloat)width {

    // ScrollView Hours :
    _scollViewHours = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewHours.tag = TAG_HOURS;
    _scollViewHours.delegate = self;
    _scollViewHours.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewHours.showsHorizontalScrollIndicator = NO;
    _scollViewHours.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewHours];
    
    _lineHoursTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewHours.frame.origin.x + kFlatDatePickerLineMargin, _scollViewHours.frame.origin.y + (_scollViewHours.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineHoursTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineHoursTop];
    
    _lineHoursBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewHours.frame.origin.x + kFlatDatePickerLineMargin, _scollViewHours.frame.origin.y + (_scollViewHours.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineHoursBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineHoursBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsHours];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHoursCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewHours addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsHours {
    
    CGFloat offsetContentScrollView = (_scollViewHours.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsHours != nil && _labelsHours.count > 0) {
        for (UILabel *label in _labelsHours) {
            [label removeFromSuperview];
        }
    }
    
    _labelsHours = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _hours.count; i++) {
        
        NSString *hour = (NSString*)[_hours objectAtIndex:i];
        
        UILabel *labelHour = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewHours.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelHour.text = hour;
        labelHour.font = kFlatDatePickerFontLabel;
        labelHour.textAlignment = NSTextAlignmentCenter;
        labelHour.textColor = kFlatDatePickerFontColorLabel;
        labelHour.backgroundColor = [UIColor clearColor];
        
        [_labelsHours addObject:labelHour];
        [_scollViewHours addSubview:labelHour];
    }
    
    _scollViewHours.contentSize = CGSizeMake(_scollViewHours.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _hours.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorHours {
    
    if (_scollViewHours != nil) {
        [_scollViewHours removeFromSuperview];
        _scollViewHours = nil;
    }
    if (_lineHoursTop != nil) {
        [_lineHoursTop removeFromSuperview];
        _lineHoursTop = nil;
    }
    if (_lineHoursBottom != nil) {
        [_lineHoursBottom removeFromSuperview];
        _lineHoursBottom = nil;
    }
}

#pragma mark - Build Selector Minutes

- (void)buildSelectorMinutesOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Minutes :
    _scollViewMinutes = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewMinutes.tag = TAG_MINUTES;
    _scollViewMinutes.delegate = self;
    _scollViewMinutes.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewMinutes.showsHorizontalScrollIndicator = NO;
    _scollViewMinutes.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewMinutes];
    
    _lineMinutesTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMinutes.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMinutes.frame.origin.y + (_scollViewMinutes.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineMinutesTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineMinutesTop];
    
    _lineMinutesBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMinutes.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMinutes.frame.origin.y + (_scollViewMinutes.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineMinutesBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineMinutesBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsMinutes];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureMinutesCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewMinutes addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsMinutes {
    
    CGFloat offsetContentScrollView = (_scollViewMinutes.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsMinutes != nil && _labelsMinutes.count > 0) {
        for (UILabel *label in _labelsMinutes) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMinutes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _minutes.count; i++) {
        
        NSString *minute = (NSString*)[_minutes objectAtIndex:i];
        
        UILabel *labelMinute = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewMinutes.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelMinute.text = minute;
        labelMinute.font = kFlatDatePickerFontLabel;
        labelMinute.textAlignment = NSTextAlignmentCenter;
        labelMinute.textColor = kFlatDatePickerFontColorLabel;
        labelMinute.backgroundColor = [UIColor clearColor];
        
        [_labelsMinutes addObject:labelMinute];
        [_scollViewMinutes addSubview:labelMinute];
    }
    
    _scollViewMinutes.contentSize = CGSizeMake(_scollViewMinutes.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _minutes.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorMinutes {
    
    if (_scollViewMinutes != nil) {
        [_scollViewMinutes removeFromSuperview];
        _scollViewMinutes = nil;
    }
    if (_lineMinutesTop != nil) {
        [_lineMinutesTop removeFromSuperview];
        _lineMinutesTop = nil;
    }
    if (_lineMinutesBottom != nil) {
        [_lineMinutesBottom removeFromSuperview];
        _lineMinutesBottom = nil;
    }
}

#pragma mark - Build Selector Seconds

- (void)buildSelectorSecondsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Seconds :
    _scollViewSeconds = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewSeconds.tag = TAG_SECONDS;
    _scollViewSeconds.delegate = self;
    _scollViewSeconds.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewSeconds.showsHorizontalScrollIndicator = NO;
    _scollViewSeconds.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewSeconds];
    
    _lineSecondsTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewSeconds.frame.origin.x + kFlatDatePickerLineMargin, _scollViewSeconds.frame.origin.y + (_scollViewSeconds.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineSecondsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineSecondsTop];
    
    _lineSecondsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewSeconds.frame.origin.x + kFlatDatePickerLineMargin, _scollViewSeconds.frame.origin.y + (_scollViewSeconds.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineSecondsBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineSecondsBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsSeconds];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureSecondsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewSeconds addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsSeconds {
    
    CGFloat offsetContentScrollView = (_scollViewSeconds.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsSeconds != nil && _labelsSeconds.count > 0) {
        for (UILabel *label in _labelsSeconds) {
            [label removeFromSuperview];
        }
    }
    
    _labelsSeconds = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _seconds.count; i++) {
        
        NSString *second = (NSString*)[_seconds objectAtIndex:i];
        
        UILabel *labelSecond = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewSeconds.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelSecond.text = second;
        labelSecond.font = kFlatDatePickerFontLabel;
        labelSecond.textAlignment = NSTextAlignmentCenter;
        labelSecond.textColor = kFlatDatePickerFontColorLabel;
        labelSecond.backgroundColor = [UIColor clearColor];
        
        [_labelsSeconds addObject:labelSecond];
        [_scollViewSeconds addSubview:labelSecond];
    }
    
    _scollViewSeconds.contentSize = CGSizeMake(_scollViewSeconds.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _seconds.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorSeconds {
    
    if (_scollViewSeconds != nil) {
        [_scollViewSeconds removeFromSuperview];
        _scollViewSeconds = nil;
    }
    if (_lineSecondsTop != nil) {
        [_lineSecondsTop removeFromSuperview];
        _lineSecondsTop = nil;
    }
    if (_lineSecondsBottom != nil) {
        [_lineSecondsBottom removeFromSuperview];
        _lineSecondsBottom = nil;
    }
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

    if (_parentView != nil) {
        
        if (self.hidden == YES) {
            self.hidden = NO;
        }
        
        if (_isInitialized == NO) {
            self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);
            _isInitialized = YES;
        }
        
        if (self.datePickerMode == FlatDatePickerModeDate ||
            self.datePickerMode == FlatDatePickerModeDateAndTime ||
            self.datePickerMode == FlatDatePickerModeMonthAndYear) {
            
            if ( self.datePickerMode != FlatDatePickerModeMonthAndYear ) {
                int indexDays = [self getIndexForScrollViewPosition:_scollViewDays];
                [self highlightLabelInArray:_labelsDays atIndex:indexDays];
            }
            
            int indexMonths = [self getIndexForScrollViewPosition:_scollViewMonths];
            [self highlightLabelInArray:_labelsMonths atIndex:indexMonths];
            
            int indexYears = [self getIndexForScrollViewPosition:_scollViewYears];
            [self highlightLabelInArray:_labelsYears atIndex:indexYears];
        }
        
        if (self.datePickerMode == FlatDatePickerModeTime || self.datePickerMode == FlatDatePickerModeDateAndTime) {
            
            int indexHours = [self getIndexForScrollViewPosition:_scollViewHours];
            [self highlightLabelInArray:_labelsHours atIndex:indexHours];
            
            int indexMinutes = [self getIndexForScrollViewPosition:_scollViewMinutes];
            [self highlightLabelInArray:_labelsMinutes atIndex:indexMinutes];
            
            int indexSeconds = [self getIndexForScrollViewPosition:_scollViewSeconds];
            [self highlightLabelInArray:_labelsSeconds atIndex:indexSeconds];
        }
        
        if (IS_PHONE) {
            [UIView beginAnimations:@"FlatDatePickerShow" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationShowDidFinish)];
        }
        
        self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height - kFlatDatePickerHeight, self.frame.size.width, self.frame.size.height);
        
        if (IS_PHONE) [UIView commitAnimations];
    }
}

- (void)animationShowDidFinish {
    _isOpen = YES;
}

-(void)dismiss {
    
    if (_parentView != nil) {
        
        [UIView beginAnimations:@"FlatDatePickerShow" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDismissDidFinish)];
        
        self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void)animationDismissDidFinish {
    _isOpen = NO;
}

#pragma mark - DatePicker Mode

- (void)setDatePickerMode:(FlatDatePickerMode)mode {
    _datePickerMode = mode;
    [self setupControl];
}

#pragma mark - DatePicker Date Maximum And Minimum

- (void)setMinimumDate:(NSDate*)date {
    _minimumDate = date;
    [self setupControl];
}

- (void)setMaximumDate:(NSDate*)date {
    _maximumDate = date;
    [self setupControl];
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

    int yearMin = kStartYear;
    
    int yearMax = 0;
    NSDateComponents* componentsMax = nil;
    
    if (self.maximumDate != nil) {
        componentsMax = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.maximumDate];
        yearMax = [componentsMax year];
    } else {
        componentsMax = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        yearMax = [componentsMax year];
    }

    for (int i = yearMin; i <= yearMax; i++) {
        
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

- (NSMutableArray*)getDates {
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setCalendar:self.calendar];
    [dateComponents setTimeZone:self.timeZone];
    [dateComponents setDay:1];
    [dateComponents setMonth:1];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    [dateComponents setYear:kStartYear];
    
    NSDate *yearMin = [dateComponents date];
    NSDate *yearMax = [NSDate date];
    
    NSInteger timestampMin = [yearMin timeIntervalSince1970];
    NSInteger timestampMax = [yearMax timeIntervalSince1970];
    
    while (timestampMin < timestampMax) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampMin];
        
        [dates addObject:date];
         
        timestampMin += (24 * 60 * 60); // + 1 day
    }
    
    return dates;
}

- (NSMutableArray*)getDaysInMonth:(NSDate*)date {

    if (date == nil) date = [NSDate date];
    
    NSRange daysRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= daysRange.length; i++) {
        
        [days addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    return days;
}

- (NSMutableArray*)getHours {
    
    NSMutableArray *hours = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 24; i++) {
        if (i < 10) {
            [hours addObject:[NSString stringWithFormat:@"0%d", i]];
        } else {
            [hours addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    return hours;
}

- (NSMutableArray*)getMinutes {
    
    NSMutableArray *minutes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 60; i++) {
        if (i < 10) {
            [minutes addObject:[NSString stringWithFormat:@"0%d", i]];
        } else {
            [minutes addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    return minutes;
}

- (NSMutableArray*)getSeconds {
    
    NSMutableArray *seconds = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 60; i++) {
        if (i < 10) {
            [seconds addObject:[NSString stringWithFormat:@"0%d", i]];
        } else {
            [seconds addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    return seconds;
}

#pragma mark - UIScrollView Delegate

- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineDaysTop.frame.origin.y)) {
        
        if (_selectedDay > 1) {
            _selectedDay -= 1;
            [self setScrollView:_scollViewDays atIndex:(_selectedDay - 1) animated:YES];
        }

    } else if (touchY > (_lineDaysBottom.frame.origin.y)) {
        
        if (_selectedDay < _days.count) {
            _selectedDay += 1;
            [self setScrollView:_scollViewDays atIndex:(_selectedDay - 1) animated:YES];
        }
    }
}

- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;

    if (touchY < (_lineMonthsTop.frame.origin.y)) {
        
        if (_selectedMonth > 1) {
            _selectedMonth -= 1;
            [self setScrollView:_scollViewMonths atIndex:(_selectedMonth - 1) animated:YES];
        }
        
    } else if (touchY > (_lineMonthsBottom.frame.origin.y)) {
        
        if (_selectedMonth < _months.count) {
            _selectedMonth += 1;
            [self setScrollView:_scollViewMonths atIndex:(_selectedMonth - 1) animated:YES];
        }
    }
}

- (void)singleTapGestureYearsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    int minYear = kStartYear;
    
    if (touchY < (_lineYearsTop.frame.origin.y)) {
        
        if (_selectedYear > minYear) {
            _selectedYear -= 1;
            [self setScrollView:_scollViewYears atIndex:(_selectedYear - minYear) animated:YES];
        }
        
    } else if (touchY > (_lineYearsBottom.frame.origin.y)) {
        
        if (_selectedYear < (_years.count + (minYear - 1))) {
            _selectedYear += 1;
            [self setScrollView:_scollViewYears atIndex:(_selectedYear - minYear) animated:YES];
        }
    }
}


- (void)singleTapGestureDatesCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineDatesTop.frame.origin.y)) {
        
        if (_selectedDate > 0) {
            _selectedDate -= 1;
            [self setScrollView:_scollViewDates atIndex:_selectedDate animated:YES];
        }
        
    } else if (touchY > (_lineDatesBottom.frame.origin.y)) {
        
        if (_selectedDate < _dates.count - 1) {
            _selectedDate += 1;
            [self setScrollView:_scollViewDates atIndex:_selectedDate animated:YES];
        }
    }
}

- (void)singleTapGestureHoursCaptured:(UITapGestureRecognizer *)gesture {
 
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineHoursTop.frame.origin.y)) {
        
        if (_selectedHour > 0) {
            _selectedHour -= 1;
            [self setScrollView:_scollViewHours atIndex:_selectedHour animated:YES];
        }
        
    } else if (touchY > (_lineHoursBottom.frame.origin.y)) {
        
        if (_selectedHour < _hours.count - 1) {
            _selectedHour += 1;
            [self setScrollView:_scollViewHours atIndex:_selectedHour animated:YES];
        }
    }
}

- (void)singleTapGestureMinutesCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineMinutesTop.frame.origin.y)) {
        
        if (_selectedMinute > 0) {
            _selectedMinute -= 1;
            [self setScrollView:_scollViewMinutes atIndex:_selectedMinute animated:YES];
        }
        
    } else if (touchY > (_lineMinutesBottom.frame.origin.y)) {
        
        if (_selectedMinute < _minutes.count - 1) {
            _selectedMinute += 1;
            [self setScrollView:_scollViewMinutes atIndex:_selectedMinute animated:YES];
        }
    }
}

- (void)singleTapGestureSecondsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineSecondsTop.frame.origin.y)) {
        
        if (_selectedSecond > 0) {
            _selectedSecond -= 1;
            [self setScrollView:_scollViewSeconds atIndex:_selectedSecond animated:YES];
        }
        
    } else if (touchY > (_lineSecondsBottom.frame.origin.y)) {
        
        if (_selectedSecond < _seconds.count - 1) {
            _selectedSecond += 1;
            [self setScrollView:_scollViewSeconds atIndex:_selectedSecond animated:YES];
        }
    }
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
    } else if (scrollView.tag == TAG_HOURS) {
        [self highlightLabelInArray:_labelsHours atIndex:index];
    } else if (scrollView.tag == TAG_MINUTES) {
        [self highlightLabelInArray:_labelsMinutes atIndex:index];
    } else if (scrollView.tag == TAG_SECONDS) {
        [self highlightLabelInArray:_labelsSeconds atIndex:index];
    } else if (scrollView.tag == TAG_DATES) {
        [self highlightLabelInArray:_labelsDates atIndex:index];
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
        _selectedDay = index + 1; // 1 to 31
    } else if (scrollView.tag == TAG_MONTHS) {
         
        _selectedMonth = index + 1; // 1 to 12
        
        // Updates days :
        [self updateNumberOfDays];

    } else if (scrollView.tag == TAG_YEARS) {
        
        _selectedYear = kStartYear + index; 
        
        // Updates days :
        [self updateNumberOfDays];
        
    } else if (scrollView.tag == TAG_HOURS) {
        _selectedHour = index; // 0 to 23
    } else if (scrollView.tag == TAG_MINUTES) {
        _selectedMinute = index; // 0 to 59
    } else if (scrollView.tag == TAG_SECONDS) {
        _selectedSecond = index; // 0 to 59
    } else if (scrollView.tag == TAG_DATES) {
        _selectedDate = index;
    }
}

- (void)updateNumberOfDays {
    
    // Updates days :
    NSDate *date = [self convertToDateDay:1 month:_selectedMonth year:_selectedYear hours:_selectedHour minutes:_selectedMinute seconds:_selectedSecond date:nil];
    
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
    if (IS_PHONE) {
        index = (index - 1);
    } else {
        index = (index - 2);
    }
    return index;
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated {
    
    if (scrollView != nil) {
        
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
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
            [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
        }
    }
}

- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index {
    
    if (labels != nil) {
        
        if ((index - 1) >= 0 && (index - 1) < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:(index - 1)];
            label.textColor = kFlatDatePickerFontColorLabel;
            label.backgroundColor = [UIColor clearColor];
            label.font = kFlatDatePickerFontLabel;
        }
        
        if (index >= 0 && index < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:index];
            label.textColor = kFlatDatePickerFontColorLabelSelected;
            label.backgroundColor = kFlatDatePickerBackgroundColorSelected;
            label.font = kFlatDatePickerFontLabelSelected;
        }
        
        if ((index + 1) >= 0 && (index + 1) < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:(index + 1)];
            label.textColor = kFlatDatePickerFontColorLabel;
            label.backgroundColor = [UIColor clearColor];
            label.font = kFlatDatePickerFontLabel;
        }
    }
}

#pragma mark - Date

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    
    if (date != nil) {
    
        NSDateComponents* components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date];
       
        _selectedDay = [components day];
        _selectedMonth = [components month];
        _selectedYear = [components year];
        _selectedHour = [components hour];
        _selectedMinute = [components minute];
        _selectedSecond = [components second];
        
        if (self.datePickerMode == FlatDatePickerModeDate || self.datePickerMode == FlatDatePickerModeMonthAndYear ) {
            if ( self.datePickerMode != FlatDatePickerModeMonthAndYear) {
                [self setScrollView:_scollViewDays atIndex:(_selectedDay - 1) animated:animated];
            }
            [self setScrollView:_scollViewMonths atIndex:(_selectedMonth - 1) animated:animated];
            [self setScrollView:_scollViewYears atIndex:(_selectedYear - kStartYear) animated:animated];
        }
        
        if (self.datePickerMode == FlatDatePickerModeTime) {
            [self setScrollView:_scollViewHours atIndex:_selectedHour animated:animated];
            [self setScrollView:_scollViewMinutes atIndex:_selectedMinute animated:animated];
            [self setScrollView:_scollViewSeconds atIndex:_selectedSecond animated:animated];
        }
        
        if (self.datePickerMode == FlatDatePickerModeDateAndTime) {
            
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setCalendar:self.calendar];
            [dateComponents setTimeZone:self.timeZone];
            [dateComponents setDay:1];
            [dateComponents setMonth:1];
            [dateComponents setHour:0];
            [dateComponents setMinute:0];
            [dateComponents setSecond:0];
            [dateComponents setYear:kStartYear];
            
            NSDate *yearMin = [dateComponents date];
            
            _selectedDate = ([date timeIntervalSince1970] - [yearMin timeIntervalSince1970]) / (24 * 60 * 60);
            
            [self setScrollView:_scollViewDates atIndex:_selectedDate animated:animated];
            [self setScrollView:_scollViewHours atIndex:_selectedHour animated:animated];
            [self setScrollView:_scollViewMinutes atIndex:_selectedMinute animated:animated];
        }
        
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
            [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
        }
    }
}

- (NSDate*)convertToDateDay:(int)day month:(int)month year:(int)year hours:(int)hours minutes:(int)minutes seconds:(int)seconds date:(NSDate*)date; {
    
    NSDateComponents *dateComponents = nil;
    
    // Date Mode :
    if (self.datePickerMode == FlatDatePickerModeDate || self.datePickerMode == FlatDatePickerModeMonthAndYear ) {
        
        dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setTimeZone:self.timeZone];
        [dateComponents setCalendar:self.calendar];
        
        [dateComponents setYear:year];
        [dateComponents setMonth:month];
        [dateComponents setDay:day];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
    }
    
    // Time Mode :
    if (self.datePickerMode == FlatDatePickerModeTime) {

        dateComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        [dateComponents setCalendar:self.calendar];
        [dateComponents setTimeZone:self.timeZone];
        [dateComponents setHour:hours];
        [dateComponents setMinute:minutes];
        [dateComponents setSecond:seconds];
    }
    
    // Date and Time Mode :
    if (self.datePickerMode == FlatDatePickerModeDateAndTime) {
    
        dateComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        [dateComponents setTimeZone:self.timeZone];
        [dateComponents setHour:hours];
        [dateComponents setMinute:minutes];
        [dateComponents setSecond:0];
    }
    
    NSLog(@"date: %@ hours: %d, minutes: %d, seconds: %d dateComponents: %@, date: %@, calendar: %@", date, hours, minutes, seconds, dateComponents, dateComponents.date, self.calendar);
    
    return [dateComponents date];
}

- (NSDate*)getDate {
    
    NSDate *selectedDate = nil;
    
    if (_dates.count > 0 && _selectedDate >= 0 && _selectedDate < _dates.count) {
        selectedDate = (NSDate*)[_dates objectAtIndex:_selectedDate];
    }
    
    return [self convertToDateDay:_selectedDay month:_selectedMonth year:_selectedYear hours:_selectedHour minutes:_selectedMinute seconds:_selectedSecond date:selectedDate];
}

@end
