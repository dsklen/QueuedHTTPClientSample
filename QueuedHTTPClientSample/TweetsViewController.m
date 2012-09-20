//
//  TweetsViewController.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "TweetsViewController.h"
#import "MediaServer.h"
#import "Tweet.h"

@interface TweetsViewController ()

@end

@implementation TweetsViewController


#pragma mark - Properties

@synthesize tags = _tags;
@synthesize tweets = _tweets;



#pragma mark - View lifecycle

- (id)initWithTags:(NSArray *)tags;
{
    self = [super initWithStyle:UITableViewStylePlain];
    if ( self ) 
    {
        _tags = tags;
        _tweets = [[NSMutableSet alloc] init];
        
        self.title = NSLocalizedString( @"Tweets", @"" );
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    MediaServer *server = [MediaServer sharedMediaServer];
    
    for (NSString *tag in self.tags) 
    {
        [server fetchTweetsForSearch:tag block:^(NSArray *items, NSError *error) {
            
            [self.tweets addObjectsFromArray:items];

            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tweets allObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:CellIdentifier];
        
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10.0f, 10.0f, 300.0f, 20.0f )];
        authorLabel.tag = 1;
        authorLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        authorLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:authorLabel];
        
        UILabel *tweetLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15.0f, 30.0f, 300.0f, 300.0f )];
        tweetLabel.tag = 2;
        tweetLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        tweetLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:tweetLabel];
    }
    
    Tweet *tweet = (Tweet *)[[self.tweets sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAtDate" ascending:YES]]] objectAtIndex:indexPath.row];
    
    [(UILabel *)[cell.contentView viewWithTag:1] setText:tweet.screenNameString];
    
    UILabel *tweetLabel = (UILabel *)[cell.contentView viewWithTag:2];
    [tweetLabel setText:tweet.tweetTextString];
    [tweetLabel setNumberOfLines:0];

    CGSize maxLabelSize = CGSizeMake( 300.0f, 9999.0f );;    
    CGSize labelSize = [tweet.tweetTextString sizeWithFont:tweetLabel.font 
                                    constrainedToSize:maxLabelSize 
                                        lineBreakMode:tweetLabel.lineBreakMode]; 
    
    CGRect newScreenNameFrame = tweetLabel.frame;
    newScreenNameFrame.size.height = labelSize.height;
    tweetLabel.frame = newScreenNameFrame;
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    Tweet *tweet = (Tweet *)[[self.tweets sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAtDate" ascending:YES]]] objectAtIndex:indexPath.row];
    NSString *string = tweet.tweetTextString;
    CGSize maximumLabelSize = CGSizeMake( 300.0f, 9999.0f );
    CGSize expectedLabelSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap]; 
    
    return expectedLabelSize.height + 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
