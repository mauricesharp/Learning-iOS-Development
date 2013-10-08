//  CarDetailViewController.h
//  CarValet

#import <UIKit/UIKit.h>


@class CDCar;

@interface CarDetailViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) CDCar *myCar;

@property (weak, nonatomic) IBOutlet UITextField *carMakeField;
@property (weak, nonatomic) IBOutlet UITextField *carModelField;
@property (weak, nonatomic) IBOutlet UITextField *carYearField;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayParkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeParkedLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *fuelPicker;

@property (copy, nonatomic) void (^nextOrPreviousCar)(BOOL isNext);


@end
