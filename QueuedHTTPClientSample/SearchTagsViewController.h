//
//  SearchTagsViewController.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

/*
 * View controller to display and manage a set of search tags to use
 * for querying Twitter with MediaServer.
 */

#import <UIKit/UIKit.h>

@interface SearchTagsViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *searchTags;

@end
