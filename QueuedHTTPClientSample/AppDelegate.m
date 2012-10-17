//
//  AppDelegate.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 8/20/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "AppDelegate.h"

#import "SearchTagsViewController.h"

@implementation AppDelegate


#pragma mark - Properties

@synthesize window = _window;


#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register default search tags for initial launch.
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObject:[NSArray arrayWithObjects:@"Portland", @"Oregon", @"Boise", @"Buckman", @"Cathedral Park", @"Goose Hollow", @"Ladd's Addition", @"Laurelhurst", @"Powell", @"Reed", @"Willamette Heights", nil]  forKey:@"SearchTagsKey"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    // Set application root view controller.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SearchTagsViewController *tagsViewController = [[SearchTagsViewController alloc] initWithStyle:UITableViewStylePlain];    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tagsViewController];   
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
