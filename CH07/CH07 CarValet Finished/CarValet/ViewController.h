//
//  ViewController.h
//  CarValet
//

#import <UIKit/UIKit.h>

#import "CarEditViewControllerProtocol.h"

@interface ViewController : UIViewController
<CarEditViewControllerProtocol>

@property (weak, nonatomic) IBOutlet UILabel *totalCarsLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousCarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextCarButton;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint)
                                NSArray *addCarViewPortraitConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint)
                                NSArray *separatorViewPortraitConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint)
                                NSArray *rootViewPortraitConstraints;

- (IBAction)newCar:(id)sender;
- (IBAction)previousCar:(id)sender;
- (IBAction)nextCar:(id)sender;

@end
