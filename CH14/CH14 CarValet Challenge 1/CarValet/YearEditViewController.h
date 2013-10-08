//  YearEditViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "YearEditProtocol.h"


@interface YearEditViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id <YearEditProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *editPicker;


- (IBAction)editCanceled:(id)sender;
- (IBAction)editDone:(id)sender;

@end
