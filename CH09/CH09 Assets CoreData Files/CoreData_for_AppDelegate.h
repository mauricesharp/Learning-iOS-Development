#import <CoreData/CoreData.h>

#define MyModelURLFile          @"MODEL_FILE_NAME_GOES_HERE"
#define MySQLDataFileName       @"SQL_STORAGE_FILE_GOES_HERE.sqlite"


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
