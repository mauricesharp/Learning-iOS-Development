//  Car.m
//  CarValet

#import "Car.h"

@implementation Car

#pragma mark - Accessors

- (NSString *)carInfo {
    return [NSString stringWithFormat:
            @"Car Info\n    Make: %@\n    Model: %@\n    Year: %d",
            self.make ? self.make : @"Unknown Make",
            self.model ? self.model : @"Unknown Model",
            self.year];
}



#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self != nil) {
        _year = 1900;
        _fuelAmount = 0.0f;
    }
    return self;
}


- (id)initWithMake:(NSString *)make
             model:(NSString *)model
              year:(int)year
        fuelAmount:(float)fuelAmount {
    
    self = [super init];
    if (self != nil) {
        _make = [make copy];
        _model = [model copy];
        _year = year;
        _fuelAmount = fuelAmount;
    }
    
    return self;
}



#pragma mark - Public Methods

- (void)printCarInfo {
    if (self.make && self.model) {
        NSLog(@"Car Make: %@", self.make);
        NSLog(@"Car Model: %@", self.model);
        NSLog(@"Car Year: %d", self.year);
        NSLog(@"Number of Gallons in Tank: %0.2f", self.fuelAmount);
    } else {
        NSLog(@"Car undefined: no make or model specified.");
    }
}



@end
