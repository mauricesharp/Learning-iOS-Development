//
//  AppDelegate.h
//  CarValet
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#define MyModelURLFile          @"CarValet"
#define MySQLDataFileName       @"CarValet.sqlite"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext
                                                *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel
                                                *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator
                                                *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
