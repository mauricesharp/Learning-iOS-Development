//  HybridCar.m
//  CarValet

#import "HybridCar.h"

@implementation HybridCar

#pragma mark - Initialization

- (id)init
{
    self = [super init] ;
    
    if (self != nil) {
        _milesPerGallon = 0.0f;
    }
    
    return self;
}


- (id)initWithMake:(NSString *)make
             model:(NSString *)model
              year:(int)year
        fuelAmount:(float)fuelAmount
               MPG:(float)MPG {
    self = [super initWithMake:make model:model year:year fuelAmount:fuelAmount];
    
    if (self != nil) {
        _milesPerGallon = MPG;
    }
    
    return self;
}



#pragma mark - Public Methods

- (void)printCarInfo {
    [super printCarInfo];
    
    NSLog(@"Miles Per Gallon: %0.2f", self.milesPerGallon);
    
    if (self.milesPerGallon > 0.0f) {
        NSLog(@"Miles until empty: %0.2f",
              [self milesUntilEmpty]);
    }
}


- (float)milesUntilEmpty {
    return (self.fuelAmount * self.milesPerGallon);
}



@end
