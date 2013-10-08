//  AboutViewController.h
//  CarValet

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *taxiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxiHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxiWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTaxiSpace;


@end
