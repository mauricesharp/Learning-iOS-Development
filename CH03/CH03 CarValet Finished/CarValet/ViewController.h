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


- (IBAction)newCar:(id)sender;
- (IBAction)previousCar:(id)sender;
- (IBAction)nextCar:(id)sender;

@end
