//  DetailController.m
//  CarValet

#import "DetailController.h"
#import <QuartzCore/QuartzCore.h>


@implementation DetailController
{
    UIBarButtonItem *menuPopoverButtonItem;
    UIPopoverController *menuPopoverController;
    UINavigationController *detailNavController;
}


#pragma mark - Setter

- (void)setCurrDetailController:(UIViewController*)currDetailController
{
    [self setCurrDetailController:currDetailController hidePopover:YES];
}

- (void)setSplitViewController:(UISplitViewController *)splitViewController
{
    if (splitViewController != _splitViewController) {
        _splitViewController = splitViewController;
        detailNavController = [splitViewController.viewControllers lastObject];
        _splitViewController.delegate = self;
    }
}


- (void)setCurrDetailController:(UIViewController*)currDetailController
                    hidePopover:(BOOL)hidePopover{
    NSArray *newStack = nil;
    
    if (currDetailController == nil) {
        UINavigationController *rootController =
                                    detailNavController.viewControllers[0];
        
        if (detailNavController.topViewController != rootController) {
            
            newStack = @[detailNavController.viewControllers[0]];
            
        }
    } else if (![currDetailController isMemberOfClass:
                 [detailNavController.topViewController class]]) {
        
        newStack = @[detailNavController.viewControllers[0],
                     currDetailController];
    }
    
    if (hidePopover)
        [self hidePopover];
    
    if (newStack != nil) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction
                                     functionWithName:
                                     kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [detailNavController.view.layer addAnimation:transition forKey:nil];
        
        [detailNavController setViewControllers:newStack animated:YES];
        
        _currDetailController = detailNavController.topViewController;
        _currDetailController.navigationItem.leftBarButtonItem =
                                                menuPopoverButtonItem;
    }
}


#pragma mark – UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}


- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Menu";
    
    menuPopoverButtonItem = barButtonItem;
    menuPopoverController = pc;
    
    UINavigationItem *detailNavItem =
    detailNavController.topViewController.navigationItem;
    detailNavItem.leftBarButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    menuPopoverButtonItem = nil;
    menuPopoverController = nil;
    
    UINavigationItem *detailNavItem =
    detailNavController.topViewController.navigationItem;
    detailNavItem.leftBarButtonItem = nil;
}



#pragma mark - Public Methods

- (void)hidePopover
{
    [menuPopoverController dismissPopoverAnimated:YES];
}



#pragma mark - Singleton

+ (DetailController*)sharedDetailController
{
    static DetailController *sharedDetailController = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedDetailController = [super new];
    });
    
    return sharedDetailController;
}





@end
