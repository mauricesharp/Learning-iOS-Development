//  CarTableViewController.m
//  CarValet

#import "CarTableViewController.h"

#import "Car.h"
#import "CarTableViewCell.h"
#import "ViewCarTableViewController.h"


@implementation CarTableViewController
{
    NSMutableArray *arrayOfCars;
    
    NSIndexPath *currentViewCarPath;
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
    
    self.title = NSLocalizedStringWithDefaultValue(
                   @"AddViewScreenTitle",
                   nil,
                   [NSBundle mainBundle],
                   @"CarValet",
                   @"Title for the main app screen");


    arrayOfCars = [NSMutableArray new];
    
    [self newCar:nil];
    
    self.navigationItem.leftBarButtonItem = self.editButton;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfCars count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CarCell";
    CarTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    cell.myCar = arrayOfCars[indexPath.row];
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
        [arrayOfCars removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
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



#pragma mark - ViewCarProtocol Methods

- (Car *)carToView {
    currentViewCarPath = [self.tableView indexPathForSelectedRow];
    
    return arrayOfCars[currentViewCarPath.row];
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
    Car *newCar = [Car new];
    
    [arrayOfCars insertObject:newCar atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (IBAction)editTableView:(id)sender {
    BOOL startEdit = (sender == self.editButton);
    
    UIBarButtonItem *nextButton = (startEdit) ?
    self.doneButton : self.editButton;
    
    [self.navigationItem setLeftBarButtonItem:nextButton animated:YES];
    [self.tableView setEditing:startEdit animated:YES];
}



@end
