//
//  ViewController.m
//  CarValet
//

#import "ViewController.h"

#import "Car.h"

#import "CarEditViewController.h"

@implementation ViewController
{
    NSMutableArray *arrayOfCars;
    NSInteger displayedCarIndex;
}


#pragma mark - View Lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditSegue"]) {
        CarEditViewController *nextController;
        
        nextController = segue.destinationViewController;
        nextController.delegate = self;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    arrayOfCars = [[NSMutableArray alloc] init];
    [self newCar:nil];
    
    displayedCarIndex = 0;
    [self displayCurrentCarInfo];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Car *myCar = [[Car alloc] init];
    [myCar printCarInfo];
    
    myCar.make = @"Ford";
    myCar.model = @"Escape";
    myCar.year = 2014;
    myCar.fuelAmount = 10.0f;
    
    [myCar printCarInfo];
    
    Car *otherCar = [[Car alloc] initWithMake:@"Honda"
                                        model:@"Accord"
                                         year:2010
                                   fuelAmount:12.5f];
    [otherCar printCarInfo];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Utility Methods

- (void)displayCurrentCarInfo {
    Car *currentCar;
    currentCar = [arrayOfCars objectAtIndex:displayedCarIndex];
    
    self.carInfoLabel.text = currentCar.carInfo;
    
    [self updateLabel:self.carNumberLabel
       withBaseString:@"Car Number"
                count:displayedCarIndex + 1];
}


- (void)changeDisplayedCar:(NSInteger)newIndex {
    if (newIndex < 0) {
        newIndex = 0;
    } else if (newIndex >= [arrayOfCars count]) {
        newIndex = [arrayOfCars count] - 1;
    }
    
    if (displayedCarIndex != newIndex) {
        displayedCarIndex = newIndex;
        [self displayCurrentCarInfo];
    }
}


- (void)updateLabel:(UILabel*)theLabel
     withBaseString:(NSString*)baseString
              count:(NSInteger)theCount {
    NSString *newText;
    newText = [NSString stringWithFormat:@"%@: %d", baseString, theCount];
    
    theLabel.text = newText;
}



#pragma mark - CarEditViewControllerProtocol Methods

- (Car*)carToEdit {
    return arrayOfCars[displayedCarIndex];
}

- (NSInteger)carNumber {
    return displayedCarIndex + 1;
}

- (void)editedCarUpdated {
    [self displayCurrentCarInfo];
    NSLog(@"\neditedCarUpdated called!\n");
}

#pragma mark - Actions

- (IBAction)newCar:(id)sender
{
    Car *newCar = [[Car alloc] init];
    
    [arrayOfCars addObject:newCar];
    
    [self updateLabel:self.totalCarsLabel
       withBaseString:@"Total Cars"
                count:[arrayOfCars count]];
}


- (IBAction)previousCar:(id)sender
{
    [self changeDisplayedCar:displayedCarIndex - 1];
}


- (IBAction)nextCar:(id)sender
{
    [self changeDisplayedCar:displayedCarIndex + 1];
}


// Unwind segue action
- (IBAction)editingDone:(UIStoryboardSegue*)segue {
    [self displayCurrentCarInfo];
}



@end
