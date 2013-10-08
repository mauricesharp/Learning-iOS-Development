//
//  ImageManager.h
//  CarValetScenes
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject


+ (ImageManager*)sharedImageManager;


- (NSUInteger)imageCount;
- (UIImage*)imageAtIndex:(NSUInteger)index;

@end
