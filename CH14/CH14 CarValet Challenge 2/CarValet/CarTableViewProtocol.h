//  CarTableViewProtocol.h
//  CarValet

#import <Foundation/Foundation.h>

@class CDCar;

@protocol CarTableViewProtocol <NSObject>

- (void) selectCar:(CDCar*)selectedCar;

@end
