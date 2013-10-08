//  HybridCar.h
//  CarValet

#import "Car.h"

@interface HybridCar : Car

@property (nonatomic) float milesPerGallon;


- (float)milesUntilEmpty;

- (id)initWithMake:(NSString *)make
             model:(NSString *)model
              year:(int)year
        fuelAmount:(float)fuelAmount
               MPG:(float)MPG;
@end
