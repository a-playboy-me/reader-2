//
//  AppDelegate.m
//  reader
//
//  Created by Ram Mohan on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreData/CoreData.h>
#import "UserManager.h"
#import "DeviceManager.h"
#import "CatalogManager.h"
#import "AppPreferenceManager.h"
#import "BookPreferenceManager.h"
#import "CovenantWorkers.h"
#import "CovenantNotificationCenter.h"
#import "API.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

@synthesize notificationCenter;

@synthesize managedObjectContext        = __managedObjectContext;
@synthesize managedObjectModel          = __managedObjectModel;
@synthesize persistentStoreCoordinator  = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self doTest];
    
    return YES;
}

-(void) doTest {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    [d setObject:[[NSMutableArray alloc] init] forKey:@"categories"];
    [d setObject:[[NSMutableArray alloc] init] forKey:@"meta_categories"];
    [[d objectForKey:@"categories"] addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"7",@"id", @"3",@"level",
                                                    @"Romance",@"name", @"1",@"position", nil]];
    [[d objectForKey:@"categories"] addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"8",@"id", @"3",@"level",
                                               @"Historical",@"name", @"2",@"position", nil]];
    [[d objectForKey:@"categories"] addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"9",@"id", @"3",@"level",
                                               @"Drama",@"name", @"3",@"position", nil]];
    [[d objectForKey:@"categories"] addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"10",@"id", @"3",@"level",
                                               @"Inspirational",@"name", @"4",@"position", nil]];
    [[d objectForKey:@"categories"] addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"11",@"id", @"3",@"level",
                                               @"Suspense",@"name", @"5",@"position", nil]];
                                               
    CatalogManager *cm = [[CatalogManager alloc] initWithDBContext:self.managedObjectContext];
    if (![cm hasData]) {
        NSLog(@" ! Exists : ");
    } else {
        NSLog(@"Exists : ");
    }
    
    [cm setCategories:d];
    [cm save];
    //[API  getBookSummary:d];
    NSLog(@"Signup Request Made..");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


#pragma mark - CoreData Stack
- (NSManagedObjectContext *)managedObjectContext 
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
        //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        //__managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    __managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return __managedObjectModel;
}

-(NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    
    if (__persistentStoreCoordinator != nil) {
        NSLog(@"DB Exists already");
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"reader.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
            // TODO: rather than abruptly terminating the app, message user appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        NSLog(@"DB Created..");
    }
    
    return __persistentStoreCoordinator;
    
}

#pragma mark - APP Helper methods
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
        {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
            {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            } 
        }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
