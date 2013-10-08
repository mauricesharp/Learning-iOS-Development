//
//  ImageManager.m
//  CarValetScenes
//

#import "ImageManager.h"

@implementation ImageManager
{
    NSMutableArray  *imageNames;
    NSMutableArray  *images;
}


#pragma mark - Initialization

- (id)init {
    if (self = [super init]) {
        imageNames = [NSMutableArray arrayWithArray:
                      @[ @"Acura-16.jpg", @"BMW-11.jpg", @"BMW-13.jpg",
                      @"Cadillac-13.jpg", @"Car-39.jpg",
                      @"Lexus-15.jpg", @"Mercedes Benz-106.jpg",
                      @"Mini-11.jpg", @"Nissan Leaf-4.jpg",
                      @"Nissan Maxima-2.jpg" ]];
        
        images = [NSMutableArray arrayWithArray:imageNames];
    }
    
    return self;
}


#pragma mark - Utility Methods

- (void) loadImages {
    [images removeAllObjects];
    
    for (NSString *atName in imageNames) {
        NSArray *nameParts = [atName componentsSeparatedByString:@"."];
        NSString *imagePath = [[NSBundle mainBundle]
                               pathForResource:[nameParts objectAtIndex:0]
                               ofType:[nameParts objectAtIndex:1]];
        
        [images addObject:[UIImage imageWithContentsOfFile:imagePath]];
    }
}


#pragma mark - Public Methods

- (NSUInteger)imageCount {
    return [imageNames count];
}

- (UIImage*)imageAtIndex:(NSUInteger)index {
    UIImage *theImage = nil;

    if (index < [images count]) {
        [self loadImages];

        theImage = images[index];
    }

    return theImage;
}


#pragma mark - Singleton

+ (ImageManager*)sharedImageManager
{
    static ImageManager *sharedImageManager = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedImageManager = [[super allocWithZone:NULL] init];
    });
    
    return sharedImageManager;
}

@end
