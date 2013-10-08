//  ViewCarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "MakeModelEditProtocol.h"
#import "YearEditProtocol.h"

@class CDCar;

@interface ViewCarTableViewController : UITableViewController
<MakeModelEditProtocol, UINavigationControllerDelegate, YearEditProtocol>

@property (weak, nonatomic) UIViewController *delegate;

@property (strong, nonatomic) CDCar *myCar;

@property (weak, nonatomic) IBOutlet UILabel *makeLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (copy, nonatomic) CDCar* (^carToView)(void);
@property (copy, nonatomic) void (^carViewDone)(BOOL dataChanged);
@property (copy, nonatomic) void (^nextOrPreviousCar)(BOOL isNext);


@end
