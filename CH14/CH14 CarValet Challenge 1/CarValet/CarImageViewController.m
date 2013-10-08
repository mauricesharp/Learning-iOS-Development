//
//  CarImageViewController.m
//  CarValet

#import "CarImageViewController.h"

#import "ImageManager.h"


@implementation CarImageViewController {
    UIView *carImageContainerView;
}


#pragma mark - Utility Methods

- (void)setupScrollContent {
    ImageManager *sharedImageManager = [ImageManager sharedImageManager];
    NSUInteger numImages = [sharedImageManager imageCount];
    
    if (carImageContainerView != nil) {
        [carImageContainerView removeFromSuperview];
    }
    
    CGFloat scrollWidth = self.view.bounds.size.width;
    CGFloat totalWidth = scrollWidth * numImages;
    
    carImageContainerView = [[UIView alloc] initWithFrame:
                             CGRectMake(0.0, 0.0,
                                        totalWidth,
                                        self.scrollView.frame.size.height)];
    
    CGFloat atX = 0.0;
    CGFloat maxHeight = 0.0;
    UIImage *carImage;
    
    for (NSUInteger atIndex = 0; atIndex < numImages; atIndex++) {
        carImage = [sharedImageManager imageAtIndex:atIndex];
        
        CGFloat scale = scrollWidth / carImage.size.width;
        
        UIImageView *atImageView = [[UIImageView alloc]
                                    initWithImage:carImage];
        
        CGFloat newHeight = atImageView.bounds.size.height * scale;
        
        atImageView.frame = CGRectMake(atX, 0.0, scrollWidth, newHeight);
        
        if (newHeight > maxHeight) {
            maxHeight = newHeight;
        }
        
        atX += scrollWidth;
        
        [carImageContainerView addSubview:atImageView];
    }
    
    CGRect newFrame = carImageContainerView.frame;
    newFrame.size.height = maxHeight;
    carImageContainerView.frame = newFrame;
    
    [self.scrollView addSubview:carImageContainerView];
    self.scrollView.contentSize = carImageContainerView.frame.size;
}



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = YES;
    
    self.resetZoomButton.enabled = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupScrollContent];

    [self updateCarNumberLabel];
}



#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    
    [self setupScrollContent];
}



#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return carImageContainerView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale {
    
    self.resetZoomButton.enabled = scale != 1.0;
}


- (void) updateCarNumberLabel {
    NSInteger carIndex = [self carIndexForPoint:self.scrollView.contentOffset];
    
    NSString *newText = [NSString stringWithFormat:@"Car Number: %d",
                         carIndex + 1];
    
    self.carNumberLabel.text = newText;
}


- (NSInteger)carIndexForPoint:(CGPoint)thePoint {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    pageWidth *= self.scrollView.zoomScale;
    
    return (NSInteger)(thePoint.x / pageWidth);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCarNumberLabel];
}



#pragma mark - Actions

- (IBAction)resetZoom:(id)sender
{
    [self.scrollView setZoomScale:1.0 animated:YES];
}
@end
