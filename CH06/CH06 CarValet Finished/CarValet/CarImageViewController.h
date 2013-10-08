//  CarImageViewController.h
//  CarValet

#import <UIKit/UIKit.h>

@interface CarImageViewController : UIViewController
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetZoomButton;

- (IBAction)resetZoom:(id)sender;
@end
