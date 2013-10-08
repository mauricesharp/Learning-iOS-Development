//  Car.m
//  CarValet

#import "Car.h"

@implementation Car

#pragma mark - Accessors

- (NSString *)carInfo {
    NSString *infoLabel = NSLocalizedStringWithDefaultValue(
                            @"CarInfoLabel",
                            nil,
                            [NSBundle mainBundle],
                            @"Car Info",
                            @"Label for the information of one car");
    
    NSString *makeLabel = NSLocalizedStringWithDefaultValue(
                            @"CarInfoMakeLabel",
                            nil,
                            [NSBundle mainBundle],
                            @"Make",
                            @"Make Label for the make of one car");
    
    NSString *modelLabel =  NSLocalizedStringWithDefaultValue(
                            @"CarInfoModelLabel",
                            nil,
                            [NSBundle mainBundle],
                            @"Model",
                            @"Model label for the model of one car");
    
    NSString *yearLabel = NSLocalizedStringWithDefaultValue(
                            @"CarInfoYearLabel",
                            nil,
                            [NSBundle mainBundle],
                            @"Year",
                            @"Year label for one car");
    
    NSString *unknownMake = NSLocalizedStringWithDefaultValue(
                            @"UnknownMakePlaceholder",
                            nil,
                            [NSBundle mainBundle],
                            @"Unknown Make",
                            @"Placeholder string for an unknown car make");
    
    NSString *unknownModel = NSLocalizedStringWithDefaultValue(
                            @"UnknownModelPlaceholder",
                            nil,
                            [NSBundle mainBundle],
                            @"Unknown Model",
                            @"Placeholder string for an unknown car model");
    
    return [NSString stringWithFormat:
                            @"%@\n    %@: %@\n    %@: %@\n    %@: %d",
                            infoLabel, makeLabel,
                            self.make ? self.make : unknownMake,
                            modelLabel,
                            self.model ? self.model : unknownModel,
                            yearLabel, self.year];
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
