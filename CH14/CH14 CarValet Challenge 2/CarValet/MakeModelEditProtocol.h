//  MakeModelEditProtocol.h
//  CarValet

#import <Foundation/Foundation.h>

@protocol MakeModelEditProtocol <NSObject>

-(NSString*)titleText;

-(NSString*)editLabelText;

-(NSString*)editFieldText;

-(NSString*)editFieldPlaceholderText;

-(void)editDone:(NSString*)textFieldValue;

@end
