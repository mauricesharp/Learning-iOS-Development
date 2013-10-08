//  CarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ViewCarProtocol.h"
#import "CarTableViewProtocol.h"


#define kCarsTableSortDateCreated   0
#define kCarsTableSortMake          1
#define kCarsTableSortModel         2
#define kCarsTableSortYear          3

@interface CarTableViewController : UIViewController
<ViewCarProtocol, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) id <CarTableViewProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *carSortControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint
                                        *carSortViewHeightConstraint;


- (IBAction)editTableView:(UIBarButtonItem *)sender;
- (IBAction)carSortChanged:(id)sender;
@end
