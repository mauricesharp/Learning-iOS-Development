//  CarEditViewControllerProtocol.h
//  CarValet

#import <Foundation/Foundation.h>

@class Car;

@protocol CarEditViewControllerProtocol <NSObject>

- (Car*)carToEdit;

- (NSInteger)carNumber;

- (void)editedCarUpdated;

@end
