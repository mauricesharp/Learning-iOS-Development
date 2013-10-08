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
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:self.year];
    
    NSDate *yearDate = [[NSCalendar currentCalendar]
                        dateFromComponents:dateComponents];
    
    NSString *yearFormat = [NSDateFormatter
                            dateFormatFromTemplate:@"YYYY"
                            options: 0
                            locale:[NSLocale currentLocale]];
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:yearFormat];
    
    NSString *localYear = [yearFormatter stringFromDate:yearDate];
    
    return [NSString stringWithFormat:
                            @"%@\n    %@: %@\n    %@: %@\n    %@: %@",
                            infoLabel, makeLabel,
                            self.make ? self.make : unknownMake,
                            modelLabel,
                            self.model ? self.model : unknownModel,
                            yearLabel, localYear];
}



#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self != nil) {
        _year = kModelTYear;
        _fuelAmount = 0.0f;
        _dateCreated = [NSDate date];
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
        _dateCreated = [NSDate date];
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
