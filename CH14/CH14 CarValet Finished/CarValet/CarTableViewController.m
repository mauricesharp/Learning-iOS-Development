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

    UITableView *currentTableView;
}


#pragma mark - View Lifecyle

- (BOOL)shouldPerformSegueWithIdentifier:(NSString*)identifier
                                  sender:(id)sender
{
    if ([identifier isEqualToString:@"ViewSegue"]) {
        if (self.delegate != nil) {
            return NO;
        }
    }
    
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewSegue"]) {
        ViewCarTableViewController *nextController;
        
        nextController = segue.destinationViewController;
        
        nextController.carToView = ^{return [self carToView];};
        nextController.carViewDone = ^(BOOL dataUpdated)
                                        {[self carViewDone:dataUpdated];};
        nextController.nextOrPreviousCar = ^(BOOL isNext)
                                            {[self nextOrPreviousCar:isNext];};
        
        nextController.delegate = self;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    managedContextObject = appDelegate.managedObjectContext;
    
    if (!self.delegate) {
        self.title = NSLocalizedStringWithDefaultValue(
                       @"AddViewScreenTitle",
                       nil,
                       [NSBundle mainBundle],
                       @"CarValet",
                       @"Title for the main app screen");
    }

    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDCar"];
    
    [self carSortChanged:nil];
    
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
    
    currentTableView = self.tableView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegate == nil) {
        self.navigationItem.leftBarButtonItem = self.editButton;
    } else {
        UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItems = @[addButton, self.editButton];
    }
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
    CarTableViewCell *cell = [self.tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    
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


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexes;
    
    if (self.carSortControl.selectedSegmentIndex == kCarsTableSortYear) {
        indexes = [NSMutableArray new];
        
        for (id <NSFetchedResultsSectionInfo> sectionInfo in
             fetchedResultsController.sections) {
            [indexes insertObject:[sectionInfo name]
                          atIndex:[indexes count]];
        }
    } else {
        indexes = [fetchedResultsController sectionIndexTitles].mutableCopy;
    }
    
    [indexes insertObject:UITableViewIndexSearch atIndex:0];
    
    return indexes;
}


- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    if (index == 0) {
        [tableView setContentOffset:CGPointZero animated:YES];
        return NSNotFound;
    } else {
        index = index - 1;
        
        if (self.carSortControl.selectedSegmentIndex == kCarsTableSortYear) {
            return index;
        }
        
        return [fetchedResultsController sectionForSectionIndexTitle:title
                                                             atIndex:index];
    }
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


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil) {
        NSIndexPath *previousPath = currentViewCarPath;
        
        [self.delegate selectCar:[self carToView]];
        
        if (previousPath != nil) {
            [currentTableView reloadRowsAtIndexPaths:@[previousPath]
                                    withRowAnimation:NO];
        }
    }
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [currentTableView beginUpdates];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [currentTableView endUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [currentTableView insertSections:sections
                          withRowAnimation:
             UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [currentTableView deleteSections:sections
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



#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.carSortControl.hidden = YES;
    self.carSortViewHeightConstraint.constant = 0.0f;
}


- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)
controller {
    [self searchDisplayController:controller
 shouldReloadTableForSearchString:@""];
    currentTableView = self.tableView;
    [self.tableView reloadData];
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.carSortControl.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.carSortViewHeightConstraint.constant = 20.0f;
                         [self.view layoutIfNeeded];
                     }];
}


- (void)searchDisplayController:(UISearchDisplayController *)controller
 willShowSearchResultsTableView:(UITableView *)tableView
{
    currentTableView = tableView;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString && ([searchString length] > 0)) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:
                                  @"%K contains[cd] %@",
                                  [[fetchRequest.sortDescriptors
                                    objectAtIndex:0] key],
                                  searchString];
    } else {
        fetchRequest.predicate = nil;
    }
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return YES;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.rowHeight = self.tableView.rowHeight;
}



#pragma mark - ViewCarProtocol Methods

- (CDCar *)carToView {
    currentViewCarPath = [currentTableView indexPathForSelectedRow];
    
    return [fetchedResultsController objectAtIndexPath:currentViewCarPath];
}


-(void)carViewDone:(BOOL)dataChanged
{
    if (dataChanged) {
        [currentTableView reloadRowsAtIndexPaths:@[currentViewCarPath]
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
    
    if (self.delegate == nil) {
        [self.navigationItem setLeftBarButtonItem:nextButton animated:YES];
    } else {
        UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItems[0];
        
        [self.navigationItem setRightBarButtonItems:@[addButton, nextButton]
                                           animated:YES];
    }
    
    [self.tableView setEditing:startEdit animated:YES];
}


- (IBAction)carSortChanged:(id)sender
{
    NSString *sortKey;
    NSString *keyPath;
    BOOL isAscending;
    SEL compareSelector = nil;
    
    if ((self.delegate != nil) &&
        (self.tableView.indexPathForSelectedRow != nil)) {
        currentViewCarPath = nil;
        [self.delegate selectCar:nil];
    }
    
    switch (self.carSortControl.selectedSegmentIndex) {
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



#pragma mark - View previous/next car

- (NSIndexPath*)indexPathOfNext
{
    NSInteger section = self.tableView.indexPathForSelectedRow.section;
    NSInteger row = self.tableView.indexPathForSelectedRow.row;
    NSInteger maxSection = [self.tableView numberOfSections] - 1;
    NSInteger maxRows = [self.tableView numberOfRowsInSection:section] - 1;
    
    if ((row + 1) > maxRows) {
        if (section > maxSection) {
            section = 0;
            row = 0;
        } else {
            if (section != maxSection) {
                section += 1;
            } else {
                section = 0;
            }
            row = 0;
        }
    } else {
        row += 1;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}


- (NSIndexPath*)indexPathOfPrevious
{
    NSInteger section = self.tableView.indexPathForSelectedRow.section;
    NSInteger row = self.tableView.indexPathForSelectedRow.row;
    NSInteger maxSection = [self.tableView numberOfSections] - 1;
    NSInteger maxRows = [self.tableView numberOfRowsInSection:section] - 1;
    
    if (row == 0) {
        if (maxSection == 0) {
            row = maxRows;
        } else {
            if (section == 0) {
                section = maxSection;
            } else {
                section -= 1;
            }
            row = [self.tableView numberOfRowsInSection:section] - 1;
        }
    } else {
        row -= 1;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}


- (void)nextOrPreviousCar:(BOOL)isNext
{
    NSIndexPath *newSelection;
    
    if (isNext) {
        newSelection = [self indexPathOfNext];
    } else {
        newSelection = [self indexPathOfPrevious];
    }
    
    [self.tableView selectRowAtIndexPath:newSelection
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    
    if (self.delegate != nil) {
        NSIndexPath *previousPath = currentViewCarPath;
        
        [self.delegate selectCar:[self carToView]];
        
        if (previousPath != nil) {
            [currentTableView reloadRowsAtIndexPaths:@[previousPath]
                                    withRowAnimation:NO];
        }
    }
}





@end
