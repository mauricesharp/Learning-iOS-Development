//  ViewCarProtocol.h
//  CarValet

#import <Foundation/Foundation.h>

@class Car;

@protocol ViewCarProtocol <NSObject>

-(Car*)carToView;

-(void)carViewDone:(BOOL)dataChanged;

@end
