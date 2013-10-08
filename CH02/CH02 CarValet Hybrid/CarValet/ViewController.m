//
//  ViewController.m
//  CarValet
//

#import "ViewController.h"

#import "Car.h"
#import "HybridCar.h"

@implementation ViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    myCar.make = @"Ford";
//    myCar.model = @"Escape";
//    myCar.year = 2014;
//    myCar.fuelAmount = 10.0f;
//    
//    [myCar printCarInfo];
    
    Car *otherCar = [[Car alloc] initWithMake:@"Honda"
                                        model:@"Accord"
                                         year:2010
                                   fuelAmount:12.5f];
    [otherCar printCarInfo];
    
    [otherCar shoutMake];
    [otherCar printCarInfo];
    
    otherCar.showLiters = YES;
    [otherCar printCarInfo];
    
    HybridCar *myHybrid = [[HybridCar alloc] initWithMake:@"Toyota"
                                                    model:@"Prius"
                                                     year:2012
                                               fuelAmount:8.3f
                                                      MPG:42.0f];
    
    [myHybrid printCarInfo];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
