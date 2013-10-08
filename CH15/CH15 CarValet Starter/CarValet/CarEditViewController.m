//  CarEditViewController.m
//  CarValet

#import "CarEditViewController.h"

#import "Car.h"

@implementation CarEditViewController
{
    CGFloat defaultScrollViewHeightConstraint;
}

#pragma mark - View Lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditDoneSegue"]) {
        self.currentCar.make = self.makeField.text;
        self.currentCar.model = self.modelField.text;
        self.currentCar.year = [self.yearField.text integerValue];

        NSNumberFormatter *readFuel = [NSNumberFormatter new];
        readFuel.locale = [NSLocale currentLocale];
        [readFuel setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber *fuelNum = [readFuel numberFromString:self.fuelField.text];
        self.currentCar.fuelAmount = [fuelNum floatValue];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = YES;

    defaultScrollViewHeightConstraint =
                self.scrollViewHeightConstraint.constant;
    
    self.formView.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self.scrollView addSubview:self.formView];
    
    self.formView.frame = CGRectMake(0.0, 0.0,
                                     self.scrollView.frame.size.width,
                                     self.formView.frame.size.height);
    
    self.scrollView.contentSize = self.formView.bounds.size;
    
    self.title = NSLocalizedStringWithDefaultValue(
                    @"EditViewScreenTitle",
                    nil,
                    [NSBundle mainBundle],
                    @"Edit Car",
                    @"Title for the Edit car screen");

    NSString *labelFormat = @"%@:";
    NSString *local;
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarMakeFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Make",
                @"Label for the line to enter or edit the Make of a car");
    self.carMakeFieldLabel.text = [NSString
                                   stringWithFormat:labelFormat, local];
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarModelFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Model",
                @"Label for the line to enter or edit the Model of a car");
    self.carModelFieldLabel.text = [NSString
                                    stringWithFormat:labelFormat, local];
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarYearFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Year",
                @"Label for the line to enter or edit the Year of a car");
    self.carYearFieldLabel.text = [NSString
                                   stringWithFormat:labelFormat, local];
    
    local = NSLocalizedStringWithDefaultValue(
                @"CarFuelFieldLabel",
                nil,
                [NSBundle mainBundle],
                @"Fuel",
                @"Label for the line to enter or edit the Fuel in a car");
    self.carFuelFieldLabel.text = [NSString
                                   stringWithFormat:labelFormat, local];

    NSString *carNumberText;
    carNumberText = [NSString localizedStringWithFormat:@"%@: %d",
                     NSLocalizedString(
                        @"CarNumberLabel",
                        @"Label for the index number of the current car"),
                     [self.delegate carNumber]];
    self.carNumberLabel.text = carNumberText;
    
    self.currentCar = [self.delegate carToEdit];
    self.makeField.text = self.currentCar.make;
    self.modelField.text = self.currentCar.model;
    self.yearField.text = [NSString stringWithFormat:@"%d",
                           self.currentCar.year];
    self.fuelField.text = [NSString localizedStringWithFormat:@"%0.2f",
                           self.currentCar.fuelAmount];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(keyboardDidShow:)
         name:UIKeyboardDidShowNotification
         object:nil];
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(keyboardWillHide:)
         name:UIKeyboardWillHideNotification
         object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:UIKeyboardDidShowNotification
         object:nil];
    [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:UIKeyboardWillHideNotification
         object:nil];
    
    self.currentCar.make = self.makeField.text;
    self.currentCar.model = self.modelField.text;
    self.currentCar.year = [self.yearField.text integerValue];

    NSNumberFormatter *readFuel = [NSNumberFormatter new];
    readFuel.locale = [NSLocale currentLocale];
    [readFuel setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *fuelNum = [readFuel numberFromString:self.fuelField.text];
    self.currentCar.fuelAmount = [fuelNum floatValue];
    
    [self.delegate editedCarUpdated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Keyboard Handling

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGRect intersect = CGRectIntersection(self.scrollView.frame, keyboardRect);
    
    self.scrollViewHeightConstraint.constant -= intersect.size.height;
    [self.view updateConstraints];
    
    self.scrollView.contentSize = self.formView.frame.size;
}


- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollViewHeightConstraint.constant =
                defaultScrollViewHeightConstraint;
    [self.view updateConstraints];
    
    self.scrollView.contentSize = self.formView.frame.size;
}

@end
