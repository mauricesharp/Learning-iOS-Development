//  CarDetailViewController.m
//  CarValet

#import "CarDetailViewController.h"

#import "CDCar.h"


#define kFuelPickerHundreds 0
#define kFuelPickerTens     1
#define kFuelPickerOnes     2
#define kFuelPickerDecimal  3
#define kFuelPickerTenths   4


@implementation CarDetailViewController


#pragma mark - Setters

- (void)setMyCar:(CDCar *)myCar
{
    if (myCar != _myCar) {
        [self saveCar];
        
        [self updateEditableState:(myCar != nil)];
        
        _myCar = myCar;

        self.carMakeField.text = _myCar.make;
        self.carModelField.text = _myCar.model;
        self.carYearField.text = [_myCar.year stringValue];
        
        self.dayParkedLabel.text = [NSDateFormatter
                                    localizedStringFromDate:_myCar.dateCreated
                                    dateStyle:NSDateFormatterMediumStyle
                                    timeStyle:NSDateFormatterNoStyle];
        
        self.timeParkedLabel.text = [NSDateFormatter
                                     localizedStringFromDate:_myCar.dateCreated
                                     dateStyle:NSDateFormatterNoStyle
                                     timeStyle:NSDateFormatterMediumStyle];
        
        [self setFuelValues];
    }
}



#pragma mark - Gestures

- (IBAction)swipeCarRight:(UISwipeGestureRecognizer*)sender
{
    self.nextOrPreviousCar(YES);
}


- (IBAction)swipeCarLeft:(UISwipeGestureRecognizer*)sender
{
    self.nextOrPreviousCar(NO);
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldReceiveTouch:(UITouch *)touch
{
    return (self.myCar != nil);
}



#pragma mark – Utility Methods

- (float) getFuelValue
{
    float fuel = 0.0;
    
    fuel = [self.fuelPicker selectedRowInComponent:kFuelPickerHundreds]
    * 100.0;
    fuel += [self.fuelPicker selectedRowInComponent:kFuelPickerTens]
    * 10.0;
    fuel += [self.fuelPicker selectedRowInComponent:kFuelPickerOnes]
    * 1.0;
    fuel += [self.fuelPicker selectedRowInComponent:kFuelPickerTenths]
    * 0.1;
    
    return fuel;
}


- (void)setFuelValues
{
    float fuel = [self.myCar.fuelAmount floatValue];
    
    NSInteger currentValue;
    
    currentValue = (NSInteger)floor(fuel / 100);
    [self.fuelPicker selectRow:currentValue
                   inComponent:kFuelPickerHundreds
                      animated:YES];
    fuel -= (currentValue * 100);
    
    currentValue = (NSInteger)floor(fuel / 10);
    [self.fuelPicker selectRow:currentValue
                   inComponent:kFuelPickerTens
                      animated:YES];
    fuel -= (currentValue * 10);
    
    
    currentValue = (NSInteger)floor(fuel);
    [self.fuelPicker selectRow:currentValue
                   inComponent:kFuelPickerOnes
                      animated:YES];
    fuel -= currentValue;
    
    fuel *= 10;
    currentValue = (NSInteger)floor(fuel);
    [self.fuelPicker selectRow:currentValue
                   inComponent:kFuelPickerTenths
                      animated:YES];
}


- (void)saveCar
{
    self.myCar.make = self.carMakeField.text;
    self.myCar.model = self.carModelField.text;
    self.myCar.year = @([self.carYearField.text floatValue]);
    
    self.myCar.fuelAmount = @([self getFuelValue]);
}


- (void)updateEditableState:(BOOL)enabled {
    self.carMakeField.enabled = enabled;
    self.carModelField.enabled = enabled;
    self.carYearField.enabled = enabled;
    self.fuelPicker.userInteractionEnabled = enabled;
}



#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    [self updateEditableState:NO];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self saveCar];
}



#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == 3) {
        return 1;
    }
    
    return 10;
}



#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    if (component == 3) {
        return @".";
    }
    
    return [NSString stringWithFormat:@"%d", row];
}






@end
