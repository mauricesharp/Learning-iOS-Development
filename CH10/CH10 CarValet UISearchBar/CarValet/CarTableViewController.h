//  CarTableViewController.h
//  CarValet

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ViewCarProtocol.h"


#define kCarsTableSortDateCreated   0
#define kCarsTableSortMake          1
#define kCarsTableSortModel         2
#define kCarsTableSortYear          3

@interface CarTableViewController : UITableViewController
<ViewCarProtocol, NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

- (IBAction)editTableView:(UIBarButtonItem *)sender;
@end
