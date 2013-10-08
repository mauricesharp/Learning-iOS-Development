//  AboutViewController.m
//  CarValet

#import "AboutViewController.h"

#import "DragViewGesture.h"


@implementation AboutViewController
{
    BOOL        draggedOnce;
    BOOL        paused;
    NSInteger   pulseCount;
}



#pragma mark - Pulse the Taxi

- (void)pulseTaxi
{
    if (!paused && !draggedOnce) {
        
        CGFloat pulseAmount = 6.0f;
        CGFloat spaceAmount = pulseAmount / 2.0f;
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.taxiWidth.constant += pulseAmount;
                             self.taxiHeight.constant += pulseAmount;
                             self.labelTaxiSpace.constant -= spaceAmount;
                             
                             [self.view layoutIfNeeded];
                             
                             pulseCount++ ;
                         }
                         completion:^(BOOL finished) {
                             self.taxiWidth.constant -= pulseAmount;
                             self.taxiHeight.constant -= pulseAmount;
                             self.labelTaxiSpace.constant += spaceAmount;
                             
                             [self.view layoutIfNeeded];
                             
                             if (!draggedOnce) {
                                 NSTimeInterval delay = 0.1f;
                                 
                                 if (pulseCount > 1) {
                                     pulseCount = 0;
                                     
                                     delay = 2.8f;
                                 };
                                 
                                 [self performSelector:@selector(pulseTaxi)
                                            withObject:nil
                                            afterDelay:delay];
                                 
                             }
                         }];
    }
}


#pragma mark - View Lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    draggedOnce = NO;
    paused = NO;
    pulseCount = 0;
    self.navigationController.toolbarHidden = YES;
    
    DragViewGesture *dragView = [[DragViewGesture alloc] init];
    [self.taxiView addGestureRecognizer:dragView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!draggedOnce) {
        pulseCount = 0;
        paused = NO;
        [self pulseTaxi];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    paused = YES;
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (!draggedOnce &&
        [gestureRecognizer isKindOfClass:[DragViewGesture class]]) {
        draggedOnce = YES;
    }
    
    return YES;
}

@end
