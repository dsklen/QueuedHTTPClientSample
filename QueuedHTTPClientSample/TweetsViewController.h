//
//  TweetsViewController.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UITableViewController

@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSMutableSet *tweets;

- (id)initWithTags:(NSArray *)tags;

@end
