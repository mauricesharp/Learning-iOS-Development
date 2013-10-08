//  CarTableViewController.m
//  CarValet

#import "CarTableViewController.h"

#import "AppDelegate.h"
#import "CDCar.h"
#import "CarTableViewCell.h"
#import "ViewCarTableViewController.h"


@implementation CarTableViewController
{
    NSIndexPath *currentViewCarPath;

    NSManagedObjectContext *managedContextObject;
    NSFetchRequest *fetchRequest;
    NSFetchedResultsController *fetchedResultsController;
}


#pragma mark - View Lifecyle

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewSegue"]) {
        ViewCarTableViewController *nextController;
        
        nextController = segue.destinationViewController;
        
        nextController.delegate = self;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    managedContextObject = appDelegate.managedObjectContext;
    
    self.title = NSLocalizedStringWithDefaultValue(
                   @"AddViewScreenTitle",
                   nil,
                   [NSBundle mainBundle],
                   @"CarValet",
                   @"Title for the main app screen");


    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDCar"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"dateCreated"
                                        ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:managedContextObject
                                sectionNameKeyPath:nil
                                cacheName:nil];
    fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    self.navigationItem.leftBarButtonItem = self.editButton;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CarCell";
    CarTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    cell.myCar = [fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCell];
    
    return cell;
}


//- (BOOL)tableView:(UITableView *)tableView
//    canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (indexPath.row % 2 != 0);
//}


- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [managedContextObject deleteObject:[fetchedResultsController
                                            objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        
        [managedContextObject save:&error];
        
        if (error != nil) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
//        case NSFetchedResultsChangeUpdate:
//            code to update the content of the cell at indexPath
//            break;

//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:@[indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:@[newIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;
            
    }
}



#pragma mark - ViewCarProtocol Methods

- (CDCar *)carToView {
    currentViewCarPath = [self.tableView indexPathForSelectedRow];
    
    return [fetchedResultsController objectAtIndexPath:currentViewCarPath];
}


-(void)carViewDone:(BOOL)dataChanged
{
    if (dataChanged) {
        [self.tableView reloadRowsAtIndexPaths:@[currentViewCarPath]
                              withRowAnimation:YES];
    }
    
    currentViewCarPath = nil;
}



#pragma mark - Actions

- (IBAction)newCar:(id)sender
{
    CDCar *newCar = [NSEntityDescription
                     insertNewObjectForEntityForName:@"CDCar"
                     inManagedObjectContext:managedContextObject];
    
    newCar.dateCreated = [NSDate date];
    
    NSError *error;
    
    [managedContextObject save:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (IBAction)editTableView:(id)sender {
    BOOL startEdit = (sender == self.editButton);
    
    UIBarButtonItem *nextButton = (startEdit) ?
    self.doneButton : self.editButton;
    
    [self.navigationItem setLeftBarButtonItem:nextButton animated:YES];
    [self.tableView setEditing:startEdit animated:YES];
}



@end
