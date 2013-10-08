//  CarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ViewCarProtocol.h"


@interface CarTableViewController : UITableViewController
<ViewCarProtocol, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)editTableView:(UIBarButtonItem *)sender;
@end
