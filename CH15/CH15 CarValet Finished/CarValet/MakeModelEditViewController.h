//  MakeModelEditViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "MakeModelEditProtocol.h"


@interface MakeModelEditViewController : UIViewController

@property (weak, nonatomic) id <MakeModelEditProtocol> delegate;

@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UITextField *editField;

@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;

- (IBAction)editCancelled:(id)sender;
- (IBAction)editDone:(id)sender;

@end
