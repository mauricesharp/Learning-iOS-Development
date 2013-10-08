//  MainMenuViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "CarTableViewProtocol.h"


#define kPadMenuCarsItem    0
#define kPadMenuImagesItem  1
#define kPadMenuAboutItem   2

@interface MainMenuViewController : UITableViewController
<CarTableViewProtocol>

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *menuImages;
@end
