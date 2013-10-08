//  CarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "ViewCarProtocol.h"


@interface CarTableViewController : UITableViewController
<ViewCarProtocol>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)editTableView:(UIBarButtonItem *)sender;
@end
