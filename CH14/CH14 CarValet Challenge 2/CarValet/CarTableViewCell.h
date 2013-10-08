//  CarTableViewCell.h
//  CarValet

#import <UIKit/UIKit.h>

@class CDCar;

@interface CarTableViewCell : UITableViewCell

@property (strong, nonatomic) CDCar *myCar;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *makeModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

- (void)configureCell;

@end
