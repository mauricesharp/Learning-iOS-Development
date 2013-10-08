//  DetailController.h
//  CarValet

#import <Foundation/Foundation.h>

@interface DetailController : NSObject
<UISplitViewControllerDelegate>

@property (weak, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) UIViewController *currDetailController ;

@property (strong, nonatomic) UIGestureRecognizer *returnGesture;


+ (DetailController*)sharedDetailController;

- (void)setCurrDetailController:(UIViewController*)currDetailController
                    hidePopover:(BOOL)hidePopover;

- (void)hidePopover;

@end
