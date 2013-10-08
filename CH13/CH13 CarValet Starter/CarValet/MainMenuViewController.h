//  MainMenuViewController.h
//  CarValet

#import <UIKit/UIKit.h>

#import "CarTableViewProtocol.h"

#import "ViewCarProtocol.h"


#define kPadMenuCarsItem    0
#define kPadMenuImagesItem  1
#define kPadMenuAboutItem   2

@interface MainMenuViewController : UITableViewController
<CarTableViewProtocol, ViewCarProtocol>

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *menuImages;
@end
