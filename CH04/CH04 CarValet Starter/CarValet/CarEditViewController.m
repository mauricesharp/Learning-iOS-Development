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
        self.currentCar.fuelAmount = [self.fuelField.text floatValue];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *carNumberText;
    carNumberText = [NSString stringWithFormat:@"Car Number: %d",
                     [self.delegate carNumber]];
    self.carNumberLabel.text = carNumberText;
    
    self.currentCar = [self.delegate carToEdit];
    self.makeField.text = self.currentCar.make;
    self.modelField.text = self.currentCar.model;
    self.yearField.text = [NSString stringWithFormat:@"%d",
                           self.currentCar.year];
    self.fuelField.text = [NSString stringWithFormat:@"%0.2f",
                           self.currentCar.fuelAmount];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.currentCar.make = self.makeField.text;
    self.currentCar.model = self.modelField.text;
    self.currentCar.year = [self.yearField.text integerValue];
    self.currentCar.fuelAmount = [self.fuelField.text floatValue];
    
    [self.delegate editedCarUpdated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
