FlatDatePicker
==============

The FlatDatePicker is a iOS control **Date Picker** with **Flat-UI** appearance.

This control is compatible with **ARC** and **iOS 5+**.

For user FlatDatePicker follow the instructions :

 - Import the controller by **drag-and-drop** the folder **FlatDatePicker** into your **Xcode project**.
 - Import the **header file** of  **FlatDatePicker** into the View Controller.
 - Create a new **FlatDatePicker**;
 - And used It !

Code :

    #import "FlatDatePicker.h"

    @implementation ViewController

    - (void)viewDidLoad
    {
        [super viewDidLoad];
   
        self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
        self.flatDatePicker.delegate = self;
        self.flatDatePicker.title = @"Select your birthday";  
        [self.flatDatePicker show];
    }
    
    #pragma mark - FlatDatePicker Delegate

    - (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *value = [dateFormatter stringFromDate:date];
    
        self.labelDateSelected.text = value;
    }

    @end
