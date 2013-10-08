//  CarEditViewController.m
//  CarValet

#import "CarEditViewController.h"

#import "Car.h"

@implementation CarEditViewController


#pragma mark - View Lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditDoneSegue"]) {
        self.currentCar.make = self.makeField.text;
        self.currentCar.model = self.modelField.text;
        self.currentCar.year = [self.yearField.text integerValue];

        NSNumberFormatter *readFuel = [NSNumberFormatter new];
        readFuel.locale = [NSLocale currentLocale];
        [readFuel setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber *fuelNum = [readFuel numberFromString:self.fuelField.text];
        self.currentCar.fuelAmount = [fuelNum floatValue];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedStringWithDefaultValue(
                    @"EditViewScreenTitle",
                    nil,
                    [NSBundle mainBundle],
                    @"Edit Car",
                    @"Title for the Edit car screen");

    NSString *labelFormat = @"%@:";
    NSString *local;
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarMakeFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Make",
                @"Label for the line to enter or edit the Make of a car");
    self.carMakeFieldLabel.text = [NSString
                                   stringWithFormat:labelFormat, local];
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarModelFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Model",
                @"Label for the line to enter or edit the Model of a car");
    self.carModelFieldLabel.text = [NSString
                                    stringWithFormat:labelFormat, local];
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarYearFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Year",
                @"Label for the line to enter or edit the Year of a car");
    self.carYearFieldLabel.text = [NSString
                                   stringWithFormat:labelFormat, local];
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarFuelFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Fuel",
                @"Label for the line to enter or edit the Fuel in a car");
    self.carFuelFieldLabel.text = [NSString
                                   stringWithFormat:labelFormat, local];

    NSString *carNumberText;
    carNumberText = [NSString stringWithFormat:@"%@: %d",
                     NSLocalizedString(
                        @"CarNumberLabel",
                        @"Label for the index number of the current car"),
                     [self.delegate carNumber]];
    self.carNumberLabel.text = carNumberText;
    
    self.currentCar = [self.delegate carToEdit];
    self.makeField.text = self.currentCar.make;
    self.modelField.text = self.currentCar.model;
    self.yearField.text = [NSString stringWithFormat:@"%d",
                           self.currentCar.year];
    self.fuelField.text = [NSString localizedStringWithFormat:@"%0.2f",
                           self.currentCar.fuelAmount];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.currentCar.make = self.makeField.text;
    self.currentCar.model = self.modelField.text;
    self.currentCar.year = [self.yearField.text integerValue];

    NSNumberFormatter *readFuel = [NSNumberFormatter new];
    readFuel.locale = [NSLocale currentLocale];
    [readFuel setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *fuelNum = [readFuel numberFromString:self.fuelField.text];
    self.currentCar.fuelAmount = [fuelNum floatValue];
    
    [self.delegate editedCarUpdated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
