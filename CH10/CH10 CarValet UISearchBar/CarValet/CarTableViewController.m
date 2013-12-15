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


#pragma mark - Utility Methods

- (void)changeCarSort:(NSInteger)toSort
{
    NSString *sortKey;
    NSString *keyPath;
    BOOL isAscending;
    SEL compareSelector = nil;
    
    switch (toSort) {
        case kCarsTableSortMake:
            sortKey = @"make";
            keyPath = sortKey;
            isAscending = YES;
            compareSelector = @selector(localizedCaseInsensitiveCompare:);
            break;
            
        case kCarsTableSortModel:
            sortKey = @"model";
            keyPath = sortKey;
            isAscending = YES;
            compareSelector = @selector(localizedCaseInsensitiveCompare:);
            break;
            
        case kCarsTableSortYear:
            sortKey = @"year";
            keyPath = sortKey;
            isAscending = NO;
            break;
            
        default:
            sortKey = @"dateCreated";
            keyPath = nil;
            isAscending = NO;
            break;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:sortKey
                                        ascending:isAscending
                                        selector:compareSelector];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:managedContextObject
                                sectionNameKeyPath:keyPath
                                cacheName:nil];
    fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
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
    
    [self changeCarSort:kCarsTableSortDateCreated];
    
    self.navigationItem.leftBarButtonItem = self.editButton;
    
    UIColor *magnesium = [UIColor colorWithRed:204.0/255.0
                                         green:204.0/255.0
                                          blue:204.0/255.0
                                         alpha:1.0];
    self.tableView.sectionIndexColor = magnesium;
    
    UIColor *mercuryWithAlpha = [UIColor colorWithRed:230.0/255.0
                                                green:230.0/255.0
                                                 blue:230.0/255.0
                                                alpha:0.1];
    self.tableView.sectionIndexBackgroundColor = mercuryWithAlpha;
    
    UIColor *mercury = [UIColor colorWithRed:230.0/255.0
                                       green:230.0/255.0
                                        blue:230.0/255.0
                                       alpha:1.0];
    self.tableView.sectionIndexTrackingBackgroundColor = mercury;
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


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [fetchedResultsController sections][section];
    return [sectionInfo name];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.mySearchBar.selectedScopeButtonIndex == kCarsTableSortYear) {
        NSMutableArray *indexes = [NSMutableArray new];
        
        for (id <NSFetchedResultsSectionInfo> sectionInfo in
             fetchedResultsController.sections) {
            [indexes insertObject:[sectionInfo name]
                          atIndex:[indexes count]];
        }
        
        return indexes;
    }
    
    return [fetchedResultsController sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    if (self.mySearchBar.selectedScopeButtonIndex == kCarsTableSortYear) {
        return index;
    }

    return [fetchedResultsController sectionForSectionIndexTitle:title
                                                         atIndex:index];
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
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:sections
                          withRowAnimation:
             UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:sections
                          withRowAnimation:
             UITableViewRowAnimationFade];
            break;
    }
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

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self changeCarSort:selectedScope];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    [self searchBar:searchBar textDidChange:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText && ([searchText length] > 0)) {                      // 1
        fetchRequest.predicate = [NSPredicate predicateWithFormat:          // 2
                                  @"%K contains[cd] %@",                    // 3
                                  [[fetchRequest.sortDescriptors            // 4
                                    objectAtIndex:0] key],
                                  searchText];                            // 5
    } else {
        fetchRequest.predicate = nil;                                       // 6
    }
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];                         // 7
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
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
