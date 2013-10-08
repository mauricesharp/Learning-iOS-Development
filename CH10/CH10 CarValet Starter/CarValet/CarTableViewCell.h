//  CarTableViewCell.h
//  CarValet

#import <UIKit/UIKit.h>

@class CDCar;

@interface CarTableViewCell : UITableViewCell

@property (strong, nonatomic) CDCar *myCar;

- (void)configureCell;

@end
