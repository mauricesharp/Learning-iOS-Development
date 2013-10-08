//  YearEditViewController.m
//  CarValet

#import "YearEditViewController.h"

#import "Car.h"


@implementation YearEditViewController


#pragma mark - Utility Methods

-(NSInteger)getYearFromDate:(NSDate*)theDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components;
    
    components = [gregorian components:NSYearCalendarUnit fromDate:theDate];
    
    return components.year;
}



#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSInteger yearValue = [self.delegate editYearValue];
    
    if (yearValue == kModelTYear) {
        yearValue = [self getYearFromDate:[NSDate date]];
    }
    
    NSInteger rows = [self.editPicker numberOfRowsInComponent:0];
    NSInteger maxYear = (kModelTYear + rows) - 1;
    NSInteger row = maxYear - yearValue;
    
    [self.editPicker selectRow:row inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    NSInteger maxYear = [self getYearFromDate:[NSDate date]];
    
    maxYear += 1;
    
    return (maxYear - kModelTYear) + 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    NSInteger totalRows = [pickerView numberOfRowsInComponent:component];
    
    NSInteger displayVal = ((kModelTYear + totalRows) - 1) - row;
    
    return [NSString stringWithFormat:@"%d", displayVal];
}



#pragma mark - Actions

- (IBAction)editCanceled:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editDone:(id)sender
{
    NSInteger rows = [self.editPicker numberOfRowsInComponent:0];
    NSInteger maxYear = (kModelTYear + rows) - 1;
    NSInteger year = maxYear - [self.editPicker selectedRowInComponent:0];
    
    [self.delegate editYearDone:year];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
