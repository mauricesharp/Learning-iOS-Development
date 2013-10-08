//  ViewCarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "ViewCarProtocol.h"
#import "MakeModelEditProtocol.h"
#import "YearEditProtocol.h"

@class CDCar;

@interface ViewCarTableViewController : UITableViewController
<MakeModelEditProtocol, UINavigationControllerDelegate, YearEditProtocol>

@property (weak, nonatomic) id <ViewCarProtocol> delegate;

@property (strong, nonatomic) CDCar *myCar;

@property (weak, nonatomic) IBOutlet UILabel *makeLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
