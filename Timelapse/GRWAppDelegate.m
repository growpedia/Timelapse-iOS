//
//  GRWAppDelegate.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWAppDelegate.h"
#import "GRWBrowserViewController.h"
#import "GRWEditorViewController.h"

@implementation GRWAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    GRWBrowserViewController *fileBrowser = [[GRWBrowserViewController alloc] init];
    UINavigationController *browserNavController = [[UINavigationController alloc] initWithRootViewController:fileBrowser];
    UIViewController *rootViewController = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        GRWEditorViewController *editorViewController = fileBrowser.editorViewController;
        UINavigationController *editorNavController = [[UINavigationController alloc] initWithRootViewController:editorViewController];
        splitViewController.viewControllers = [NSArray arrayWithObjects:browserNavController, editorNavController, nil];
        splitViewController.delegate = editorViewController;
        rootViewController = splitViewController;
    } else {
        rootViewController = browserNavController;
    }
    
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
