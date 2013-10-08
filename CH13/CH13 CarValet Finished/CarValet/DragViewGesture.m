//  DragViewGesture.m
//  CarValet

#import "DragViewGesture.h"

@implementation DragViewGesture



#pragma mark - UIGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([touches count] != 1) {
        return;
    }
    
    self.state = UIGestureRecognizerStateBegan;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateRecognized;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateRecognized;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if ((self.state == UIGestureRecognizerStateFailed) ||
        (self.state == UIGestureRecognizerStateRecognized)) {
        return;
    }
    
    CGPoint currPoint = [touches.anyObject
                         locationInView:self.view.superview];
    CGPoint prevPoint = [touches.anyObject
                         previousLocationInView:self.view.superview];
    
    CGRect newRect = CGRectOffset(self.view.frame,
                                  currPoint.x - prevPoint.x,
                                  currPoint.y - prevPoint.y);
    
    if (CGRectContainsRect(self.view.superview.frame,
                           newRect)) {
        self.view.frame = newRect;
    }
    
    self.state = UIGestureRecognizerStateChanged;
}





@end
