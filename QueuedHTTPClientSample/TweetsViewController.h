//
//  TweetsViewController.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

/*
 * View controller to fetch and display twitter results for search tags.
 */

#import <UIKit/UIKit.h>

@interface TweetsViewController : UITableViewController

@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

- (id)initWithTags:(NSArray *)tags;

@end
