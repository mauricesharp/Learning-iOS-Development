//
//  ViewController.m
//  CarValet
//

#import "ViewController.h"

#import "Car.h"

#import "CarEditViewController.h"

@implementation ViewController
{
    NSMutableArray *arrayOfCars;
    NSInteger displayedCarIndex;
    
    NSArray *rootViewLandscapeConstraints;
    NSArray *addCarViewLandscapeConstraints;
    NSArray *separatorViewLandscapeConstraints;
    
    __weak IBOutlet UIView *addCarView;
    __weak IBOutlet UIView *separatorView;
    __weak IBOutlet UIView *viewCarView;
    
    BOOL isShowingPortrait;
}


#pragma mark - View Lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditSegue"]) {
        CarEditViewController *nextController;
        
        nextController = segue.destinationViewController;
        nextController.delegate = self;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.toolbarHidden = NO;
    
    // WORKAROUND
    // IB sets preferredMaxLayoutWidth overriding intrinsicContentSize
    //    Constraints will not work propertly unless it is set to 0.
    self.carInfoLabel.preferredMaxLayoutWidth = 0.0f;
    self.totalCarsLabel.preferredMaxLayoutWidth = 0.0f;
    self.carNumberLabel.preferredMaxLayoutWidth = 0.0f;
    // END WORKAROUND
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = NSLocalizedStringWithDefaultValue(
                    @"AddViewScreenTitle",
                    nil,
                    [NSBundle mainBundle],
                    @"CarValet",
                    @"Title for the main app screen");
    
    NSString *local;
    
    local = NSLocalizedStringWithDefaultValue (
                   @"NewCarButton",
                   nil,
                   [NSBundle mainBundle],
                   @"New Car",
                   @"Button to create and add a new car");
    [self.addCarButton setTitle:local forState:UIControlStateNormal];
        
    UIInterfaceOrientation currOrientation = [[UIApplication sharedApplication]
                                              statusBarOrientation];
    isShowingPortrait = UIInterfaceOrientationIsPortrait(currOrientation);
    
    [self setupLandscapeConstraints];

    arrayOfCars = [NSMutableArray new];
    [self newCar:nil];
    
    displayedCarIndex = 0;
    [self displayCurrentCarInfo];
}


// BEGIN WORKAROUND for labels not correctly updating during rotation
- (void)viewWillLayoutSubviews {
    self.totalCarsLabel.preferredMaxLayoutWidth = 0.0;
}


- (void)viewDidLayoutSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalCarsLabel.preferredMaxLayoutWidth =
        self.totalCarsLabel.frame.size.width;
    });
}
// END WORKAROUND for labels not correctly updating during rotation


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLocaleLanguageDirection langDirection;
    langDirection = [NSLocale characterDirectionForLanguage:
                     [NSLocale preferredLanguages][0]];
    
    if (langDirection == NSLocaleLanguageDirectionRightToLeft) {
        self.carInfoLabel.textAlignment = NSTextAlignmentRight;
        self.totalCarsLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.carInfoLabel.textAlignment = NSTextAlignmentLeft;
        self.totalCarsLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    UIInterfaceOrientation currOrientation = [[UIApplication sharedApplication]
                                              statusBarOrientation];
    BOOL currIsPortrait = UIInterfaceOrientationIsPortrait(currOrientation);
    
    if ((isShowingPortrait && !currIsPortrait) ||
        (!isShowingPortrait && currIsPortrait)) {
        [self willAnimateRotationToInterfaceOrientation:currOrientation
                                               duration:0.0f];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.view removeConstraints:rootViewLandscapeConstraints];
        [addCarView removeConstraints:addCarViewLandscapeConstraints];
        [separatorView removeConstraints:separatorViewLandscapeConstraints];
        
        [self.view addConstraints:self.rootViewPortraitConstraints];
        [addCarView addConstraints:self.addCarViewPortraitConstraints];
        [separatorView addConstraints:self.separatorViewPortraitConstraints];
        
        isShowingPortrait = YES;
        
    } else {
        
        [self.view removeConstraints:self.rootViewPortraitConstraints];
        [addCarView removeConstraints:self.addCarViewPortraitConstraints];
        [separatorView removeConstraints:self.separatorViewPortraitConstraints];
        
        [self.view addConstraints:rootViewLandscapeConstraints];
        [addCarView addConstraints:addCarViewLandscapeConstraints];
        [separatorView addConstraints:separatorViewLandscapeConstraints];
        
        isShowingPortrait = NO;
    }
}


#pragma mark - Utility Methods

- (void)displayCurrentCarInfo {
    Car *currentCar;
    currentCar = arrayOfCars[displayedCarIndex];
    
    self.carInfoLabel.text = currentCar.carInfo;
    
    [self updateLabel:self.carNumberLabel
       withBaseString:NSLocalizedStringWithDefaultValue(
                        @"CarNumberLabel",
                        nil,
                        [NSBundle mainBundle],
                        @"Car Number",
                        @"Label for the index number of the current car")

                count:displayedCarIndex + 1];
}


- (void)changeDisplayedCar:(NSInteger)newIndex {
    if (newIndex < 0) {
        newIndex = 0;
    } else if (newIndex >= [arrayOfCars count]) {
        newIndex = [arrayOfCars count] - 1;
    }
    
    if (displayedCarIndex != newIndex) {
        displayedCarIndex = newIndex;
        [self displayCurrentCarInfo];
    }
}


- (void)updateLabel:(UILabel*)theLabel
     withBaseString:(NSString*)baseString
              count:(NSInteger)theCount {
    NSString *newText;
    newText = [NSString localizedStringWithFormat:@"%@: %d",
               baseString, theCount];
    
    theLabel.text = newText;
}


- (void)setupLandscapeConstraints {
    NSDictionary *views;
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    views = NSDictionaryOfVariableBindings(topGuide,
                                           bottomGuide,
                                           addCarView,
                                           separatorView,
                                           viewCarView);
    
    NSMutableArray *tempRootViewConstraints = [NSMutableArray new];
    
    NSArray *generatedConstraints;
    
    generatedConstraints =
        [NSLayoutConstraint
         constraintsWithVisualFormat:@"H:[addCarView]-2-[separatorView]"
         options:0
         metrics:nil
         views:views];
    [tempRootViewConstraints addObjectsFromArray:generatedConstraints];
    
    generatedConstraints =
        [NSLayoutConstraint
         constraintsWithVisualFormat:@"V:[topGuide]-[separatorView]-[bottomGuide]"
         options:0
         metrics:nil
         views:views];
    [tempRootViewConstraints addObjectsFromArray:generatedConstraints];
    
    generatedConstraints =
            [NSLayoutConstraint
             constraintsWithVisualFormat:@"V:[topGuide]-[addCarView]-[bottomGuide]"
             options:0
             metrics:nil
             views:views];
    [tempRootViewConstraints addObjectsFromArray:generatedConstraints];
    
    generatedConstraints =
            [NSLayoutConstraint
             constraintsWithVisualFormat:@"V:[topGuide]-[viewCarView]"
             options:0
             metrics:nil
             views:views];
    [tempRootViewConstraints addObjectsFromArray:generatedConstraints];
    
    generatedConstraints =
            [NSLayoutConstraint
             constraintsWithVisualFormat:@"[separatorView]-40-[viewCarView]-|"
             options:0
             metrics:nil
             views:views];
    [tempRootViewConstraints addObjectsFromArray:generatedConstraints];
    
    rootViewLandscapeConstraints = [NSArray
                                    arrayWithArray:tempRootViewConstraints];
    
    addCarViewLandscapeConstraints =
            [NSLayoutConstraint
             constraintsWithVisualFormat:@"H:[addCarView(132)]"
             options:0
             metrics:nil
             views:views];
    
    separatorViewLandscapeConstraints =
            [NSLayoutConstraint
             constraintsWithVisualFormat:@"H:[separatorView(2)]"
             options:0
             metrics:nil
             views:views];
}



#pragma mark - CarEditViewControllerProtocol Methods

- (Car*)carToEdit {
    return arrayOfCars[displayedCarIndex];
}

- (NSInteger)carNumber {
    return displayedCarIndex + 1;
}

- (void)editedCarUpdated {
    [self displayCurrentCarInfo];
    NSLog(@"\neditedCarUpdated called!\n");
}

#pragma mark - Actions

- (IBAction)newCar:(id)sender
{
    Car *newCar = [Car new];
    
    [arrayOfCars addObject:newCar];
    
    [self updateLabel:self.totalCarsLabel
       withBaseString:NSLocalizedStringWithDefaultValue(
                        @"TotalCarsLabel",
                        nil,
                        [NSBundle mainBundle],
                        @"Total Cars",
                        @"Label for the total number of cars")

                count:[arrayOfCars count]];
}


- (IBAction)previousCar:(id)sender {
    NSInteger indexShift = -1;
    
    NSLocaleLanguageDirection langDirection;
    langDirection = [NSLocale characterDirectionForLanguage:
                     [NSLocale preferredLanguages][0]];
    
    if (langDirection == NSLocaleLanguageDirectionRightToLeft) {
        indexShift = 1;
    }
    
    [self changeDisplayedCar:displayedCarIndex + indexShift];
}

- (IBAction)nextCar:(id)sender {
    NSInteger indexShift = 1;
    
    NSLocaleLanguageDirection langDirection;
    langDirection = [NSLocale characterDirectionForLanguage:
                     [NSLocale preferredLanguages][0]];
    
    if (langDirection == NSLocaleLanguageDirectionRightToLeft) {
        indexShift = -1;
    }
    
    [self changeDisplayedCar:displayedCarIndex + indexShift];
}


// Unwind segue action
- (IBAction)editingDone:(UIStoryboardSegue*)segue {
    [self displayCurrentCarInfo];
}



@end
