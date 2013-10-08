//  Car.h
//  CarValet

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property (readonly, nonatomic) int year;
@property (readonly, nonatomic) NSString *make;
@property (readonly, nonatomic) NSString *model;
@property (nonatomic) float fuelAmount;
@property (getter = isShowingLiters, nonatomic) BOOL showLiters;


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

- (void)shoutMake;

@end
