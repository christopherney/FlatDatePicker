FlatDatePicker
==============

The FlatDatePicker is a iOS control **Date Picker** with **Flat-UI** appearance.

This control is compatible with **ARC** and **iOS 5+**.

<!-- MacBuildServer Install Button -->
<div class="macbuildserver-block">
    <a class="macbuildserver-button" href="http://macbuildserver.com/project/github/build/?xcode_project=FlatDatePicker.xcodeproj&amp;target=FlatDatePicker&amp;repo_url=https%3A%2F%2Fgithub.com%2Fchristopherney%2FFlatDatePicker.git&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png"/></a><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup>
</div>
<!-- MacBuildServer Install Button -->

Screenshot :

![ScreenShot](https://raw.github.com/christopherney/FlatDatePicker/master/Screenshot.png)

How installed and used FlatDatePicker ? Follow the instructions :

 - Import the control files by **drag-and-drop** the folder **FlatDatePicker** into your **Xcode project**.
 - Import the **header file** of  **FlatDatePicker.h** into the View Controller.
 - Create a new object **FlatDatePicker**;
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
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *date = [dateFormatter dateFromString:@"07-12-1985"];
        
        [self.flatDatePicker setDate:date animated:NO];
    }
    
    #pragma mark - FlatDatePicker Delegate
    
    - (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
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
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        NSString *value = [dateFormatter stringFromDate:date];
    
        self.labelDateSelected.text = value;
    
        NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
  
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }

    @end
