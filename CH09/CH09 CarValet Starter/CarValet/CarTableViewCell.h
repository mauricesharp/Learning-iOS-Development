//  CarTableViewCell.h
//  CarValet

#import <UIKit/UIKit.h>

@class Car;

@interface CarTableViewCell : UITableViewCell

@property (strong, nonatomic) Car *myCar;

- (void)configureCell;

@end
