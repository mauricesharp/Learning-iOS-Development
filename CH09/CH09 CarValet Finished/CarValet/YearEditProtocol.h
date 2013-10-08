//  YearEditProtocol.h
//  CarValet

#import <Foundation/Foundation.h>

@protocol YearEditProtocol <NSObject>

- (NSInteger) editYearValue;

- (void) editYearDone:(NSInteger)yearValue;

@end
