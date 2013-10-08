//  ViewCarTableViewController.m
//  CarValet

#import "ViewCarTableViewController.h"

#import "CDCar.h"
#import "MakeModelEditViewController.h"
#import "YearEditViewController.h"


#define kCurrentEditMake    0
#define kCurrentEditModel   1

@implementation ViewCarTableViewController
{
    NSInteger currentEditType;
    BOOL dataUpdated;
}


#pragma mark - View Lifecyle

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MakeEditSegue"]) {
        MakeModelEditViewController *nextController;
        nextController = segue.destinationViewController;
        
        nextController.delegate = self;
        currentEditType = kCurrentEditMake;
        
    } else if ([segue.identifier isEqualToString:@"ModelEditSegue"]) {
        MakeModelEditViewController *nextController;
        nextController = segue.destinationViewController;
        
        nextController.delegate = self;
        currentEditType = kCurrentEditModel;
    } else if ([segue.identifier isEqualToString:@"YearEditSegue"]) {
        YearEditViewController *nextController;
        nextController = segue.destinationViewController;
        
        nextController.delegate = self;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myCar = [self.delegate carToView];
    
    dataUpdated = NO;

    self.makeLabel.text = self.myCar.make;
    
    self.modelLabel.text = self.myCar.model;
    
    self.yearLabel.text = [NSString stringWithFormat:@"%@",
                           self.myCar.year];
    
    self.fuelLabel.text = [NSString stringWithFormat:@"%0.2f",
                           [self.myCar.fuelAmount floatValue]];
    
    self.dateLabel.text = [NSDateFormatter
                           localizedStringFromDate:self.myCar.dateCreated
                           dateStyle:NSDateFormatterMediumStyle
                           timeStyle:NSDateFormatterNoStyle];
    
    self.timeLabel.text = [NSDateFormatter
                           localizedStringFromDate:self.myCar.dateCreated
                           dateStyle:NSDateFormatterNoStyle
                           timeStyle:NSDateFormatterMediumStyle];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UINavigationControllerProtocol Methods

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (viewController == (UIViewController*)self.delegate) {
        if (dataUpdated) {
            [self.delegate carViewDone:dataUpdated];
        }
        
        navigationController.delegate = nil;
    }
}



#pragma mark - MakeModelEditProtocol Methods

-(NSString*)titleText
{
    NSString *titleString = @"";
    
    switch (currentEditType) {
        case kCurrentEditMake:
            titleString = @"Edit Make";
            break;
            
        case kCurrentEditModel:
            titleString = @"Edit Model";
            break;
    }
    
    return titleString;
}


-(NSString*)editLabelText
{
    NSString *labelText = @"";
    
    switch (currentEditType) {
        case kCurrentEditMake:
            labelText = @"Enter the Make:";
            break;
            
        case kCurrentEditModel:
            labelText = @"Enter the Model:";
            break;
    }
    
    return labelText;
}


-(NSString*)editFieldText
{
    NSString *fieldText = @"";
    
    switch (currentEditType) {
        case kCurrentEditMake:
            fieldText = self.myCar.make;
            break;
            
        case kCurrentEditModel:
            fieldText = self.myCar.model;
            break;
    }
    
    return fieldText;
}


-(NSString*)editFieldPlaceholderText
{
    NSString *placeholderText = @"";
    
    switch (currentEditType) {
        case kCurrentEditMake:
            placeholderText = @"Car Make";
            break;
            
        case kCurrentEditModel:
            placeholderText = @"Car Model";
            break;
    }
    
    return placeholderText;
}


-(void)editDone:(NSString*)textFieldValue {
    if (textFieldValue != nil &&
        [textFieldValue length] > 0) {
        switch (currentEditType) {
            case kCurrentEditMake:
                if ((self.myCar.make == nil) ||
                    !([self.myCar.make isEqualToString:textFieldValue])) {
                    self.myCar.make = textFieldValue;
                    
                    self.makeLabel.text = textFieldValue;
                    
                    dataUpdated = YES;
                }
                break;
                
            case kCurrentEditModel:
                if ((self.myCar.model == nil) ||
                    !([self.myCar.model isEqualToString:textFieldValue])) {
                    self.myCar.model = textFieldValue;
                    
                    self.modelLabel.text = textFieldValue;

                    dataUpdated = YES;
                }
                break;
        }
    }
}



#pragma mark - YearEditProtocol Methods

- (NSInteger)editYearValue
{
    return [self.myCar.year integerValue];
}


- (void)editYearDone:(NSInteger)yearValue
{
    if (yearValue != [self.myCar.year integerValue]) {
        self.myCar.year = @(yearValue);
        
        self.yearLabel.text = [self.myCar.year stringValue];
        
        dataUpdated = YES;
    }
}



@end
