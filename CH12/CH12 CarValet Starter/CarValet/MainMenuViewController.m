//  MainMenuViewController.m
//  CarValet

#import "MainMenuViewController.h"

#import "AppDelegate.h"
#import "DetailController.h"
#import "CarTableViewController.h"
#import "CarDetailViewController.h"

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
    
    BOOL updateDetailController = YES;
    
    switch (indexPath.row) {
        case kPadMenuCarsItem:
            nextController = [iPhoneStory
                              instantiateViewControllerWithIdentifier:
                              @"CarTableViewController"];
            
            nextController.navigationItem.title = @"Cars";
            ((CarTableViewController*)nextController).delegate = self;

            [self.navigationController pushViewController:nextController
                                                 animated:YES];
            
            if (currentCarDetailController == nil) {
                currentCarDetailController = [[self storyboard]
                                              instantiateViewControllerWithIdentifier:
                                              @"CarDetailViewController"];
                
                [detailController setCurrDetailController:currentCarDetailController
                                              hidePopover:NO];
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



@end
