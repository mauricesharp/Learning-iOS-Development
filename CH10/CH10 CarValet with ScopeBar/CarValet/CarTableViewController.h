//  CarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ViewCarProtocol.h"


#define kCarsTableSortDateCreated   0
#define kCarsTableSortMake          1
#define kCarsTableSortModel         2
#define kCarsTableSortYear          3

@interface CarTableViewController : UIViewController
<ViewCarProtocol, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *carSortControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint
                                        *carSortViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)editTableView:(UIBarButtonItem *)sender;
- (IBAction)carSortChanged:(id)sender;
@end
