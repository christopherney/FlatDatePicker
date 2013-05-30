FlatDatePicker
==============

The FlatDatePicker is a iOS control **Date Picker** with **Flat-UI** appearance.

This control is compatible with **ARC** and **iOS 5+**.

For user FlatDatePicker follow the instructions :

 - Import de controller to your project by drad-and-drop.
 - Import in the header file of the View Controller the FlatDatePicker controller.
 - Create a new FlatDatePicker;

Code :

    #import "FlatDatePicker.h"

    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Select your birthday"; 
    [self.flatDatePicker show];
