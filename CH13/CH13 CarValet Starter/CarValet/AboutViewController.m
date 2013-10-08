//  AboutViewController.m
//  CarValet

#import "AboutViewController.h"

#import "DragViewGesture.h"


@implementation AboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.toolbarHidden = YES;
    
    DragViewGesture *dragView = [[DragViewGesture alloc] init];
    [self.taxiView addGestureRecognizer:dragView];
}


@end
