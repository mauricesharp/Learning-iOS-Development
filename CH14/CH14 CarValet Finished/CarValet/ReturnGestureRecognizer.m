//  ReturnGestureRecognizer.m
//  CarValet

#import "ReturnGestureRecognizer.h"


#define kRStrokeDelta       5.0f


@implementation ReturnGestureRecognizer
{
    NSInteger   strokePhase;
    CGPoint     firstTap;
}


#pragma mark - UIGestureRecognizer Methods


- (void)reset
{
    [super reset];
    
    strokePhase = 0;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (([touches count] != 1) ||
        ([[touches.anyObject view] isKindOfClass:[UIControl class]])) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    firstTap = [touches.anyObject locationInView:self.view.superview];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if ((self.state == UIGestureRecognizerStateFailed) ||
        (self.state == UIGestureRecognizerStateRecognized)) {
        return;
    }
    
    UIView *superView = [self.view superview];
    CGPoint currPoint = [touches.anyObject locationInView:superView];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:superView];
    
    if ((strokePhase == 0) &&
        ((currPoint.y - firstTap.y) > 10.0) &&
        (currPoint.y <= prevPoint.y)) {
        
        strokePhase = 1;
        
    } else if ((strokePhase == 1) &&
               
               ((currPoint.x - prevPoint.x) >= kRStrokeDelta)) {
        
        strokePhase = 2;
        
    } else if ((strokePhase == 2) &&
               ((currPoint.y - prevPoint.y) <= kRStrokeDelta) &&
               (currPoint.x > prevPoint.x)) {
        
        strokePhase = 3;
        self.state = UIGestureRecognizerStateRecognized;
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}





@end
