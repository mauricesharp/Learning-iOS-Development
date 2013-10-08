//  Car.h
//  CarValet

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property int year;
@property NSString *make;
@property NSString *model;
@property float fuelAmount;


- (id)initWithMake:(NSString *)make
             model:(NSString *)model
              year:(int)year
        fuelAmount:(float)fuelAmount;

- (void)printCarInfo;
- (float)fuelAmount;
- (void)setFuelAmount:(float)fuelAmount;
- (int)year;
- (NSString*)make;
- (NSString*)model;

@end
