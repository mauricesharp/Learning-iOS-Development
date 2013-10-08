//  MainMenuViewController.m
//  CarValet

#import "MainMenuViewController.h"

#import "AppDelegate.h"
#import "DetailController.h"
#import "CarTableViewController.h"
#import "CarDetailViewController.h"
#import "ReturnGestureRecognizer.h"

#import "CDCar.h"


@implementation MainMenuViewController
{
    CDCar *currentCar;
    CarDetailViewController *currentCarDetailController;
}



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIImageView *atView in self.menuImages) {
        atView.image = [atView.image imageWithRenderingMode:
                        UIImageRenderingModeAlwaysTemplate];
        atView.highlightedImage = [atView.highlightedImage
                                   imageWithRenderingMode:
                                   UIImageRenderingModeAlwaysTemplate];
    }
    
    ReturnGestureRecognizer *returnGesture = [[ReturnGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(returnHome:)];
    
    [DetailController sharedDetailController].returnGesture = returnGesture;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (currentCarDetailController != nil) {
        [DetailController sharedDetailController].currDetailController = nil;
        currentCarDetailController = nil;
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    DetailController *detailController = [DetailController
                                          sharedDetailController];
    
    UIStoryboard *iPhoneStory = [UIStoryboard
                                 storyboardWithName:@"Main_iPhone"
                                 bundle:nil];

    UIViewController *nextController;
    CarTableViewController *carTable;
    
    BOOL updateDetailController = YES;
    
    switch (indexPath.row) {
        case kPadMenuCarsItem:
            carTable = [iPhoneStory instantiateViewControllerWithIdentifier:
                        @"CarTableViewController"];
            
            carTable.navigationItem.title = @"Cars";
            carTable.delegate = self;
            
            nextController = carTable;
            
            [self.navigationController pushViewController:nextController
                                                 animated:YES];
            
            if (currentCarDetailController == nil) {
                currentCarDetailController = [[self storyboard]
                                              instantiateViewControllerWithIdentifier:
                                              @"CarDetailViewController"];
                
                [detailController setCurrDetailController:currentCarDetailController
                                              hidePopover:NO];
                
                currentCarDetailController.nextOrPreviousCar = ^(BOOL isNext)
                                        {[carTable nextOrPreviousCar:isNext];};
            }
            
            updateDetailController = NO;
            break;
            
        case kPadMenuImagesItem:
            nextController = [iPhoneStory
                              instantiateViewControllerWithIdentifier:
                              @"CarImagesViewController"];
            
            nextController.navigationItem.hidesBackButton = YES;
            nextController.navigationItem.rightBarButtonItem = nil;
            break;
            
        case kPadMenuAboutItem:
            nextController = (UIViewController*)appDelegate.aboutViewController;
            break;
    }
    
    if (updateDetailController) {
        detailController.currDetailController = nextController;
    }
}



#pragma mark - CarTableViewProtocol

- (void)selectCar:(CDCar *)selectedCar {
    NSLog(@"\nSELECT a car: %@ %@ %@\n\n",
          selectedCar.make, selectedCar.model, selectedCar.year);
    
    currentCarDetailController.myCar = selectedCar;
    [[DetailController sharedDetailController] hidePopover];
}


#pragma mark - ViewCarProtocol

-(CDCar*)carToView
{
    return currentCar;
}

-(void)carViewDone:(BOOL)dataChanged
{
    NSLog(@"\ncarViewDone\n\n");
}



#pragma mark - Return Gesture Action Method

- (IBAction)returnHome:(UIGestureRecognizer*)sender
{
    [self.tableView
     deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow
     animated:YES];
    
    if (currentCarDetailController != nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        currentCarDetailController = nil;
    }
    
    [DetailController sharedDetailController].currDetailController = nil;
}


@end
