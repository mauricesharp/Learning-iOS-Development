//  ViewCarProtocol.h
//  CarValet

#import <Foundation/Foundation.h>

@class CDCar;

@protocol ViewCarProtocol <NSObject>

-(CDCar*)carToView;

-(void)carViewDone:(BOOL)dataChanged;

@optional
- (void)nextOrPreviousCar:(BOOL)isNext;

@end
