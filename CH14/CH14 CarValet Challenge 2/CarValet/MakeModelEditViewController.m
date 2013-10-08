//  MakeModelEditViewController.m
//  CarValet

#import "MakeModelEditViewController.h"


@implementation MakeModelEditViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myNavigationItem.title = [self.delegate titleText] ;
    
    self.editLabel.text = [self.delegate editLabelText];
    self.editField.text = [self.delegate editFieldText];
    self.editField.placeholder = [self.delegate editFieldPlaceholderText];
    
    [self.editField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions

- (IBAction)editCancelled:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editDone:(id)sender {
    [self.delegate editDone:self.editField.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
