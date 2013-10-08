//  Car.h
//  CarValet

#import <Foundation/Foundation.h>

#define kModelTYear 1908

@interface Car : NSObject

@property (nonatomic) int year;
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *model;
@property (nonatomic) float fuelAmount;
@property (readonly) NSString *carInfo;
@property (strong, nonatomic) NSDate *dateCreated;


- (id)initWithMake:(NSString *)make
             model:(NSString *)model
              year:(int)year
        fuelAmount:(float)fuelAmount;

- (void)printCarInfo;

@end
