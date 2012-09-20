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
            
            if ( items && error == nil )
            {
                [self.tweets addObjectsFromArray:items];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
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
        authorLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:authorLabel];
        
        UILabel *tweetLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10.0f, 35.0f, 300.0f, 300.0f )];
        tweetLabel.tag = 2;
        tweetLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        tweetLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:tweetLabel];
        
        UILabel *tweetTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 230.0f, 10.0f, 80.0f, 20.0f )];
        tweetTimeLabel.tag = 3;
        tweetTimeLabel.textAlignment = UITextAlignmentRight;
        tweetTimeLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        tweetTimeLabel.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:tweetTimeLabel];
    }
    
    NSArray *sortDescriptorsArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAtDate" ascending:NO]];
    Tweet *tweet = (Tweet *)[[self.tweets sortedArrayUsingDescriptors:sortDescriptorsArray] objectAtIndex:indexPath.row];
    
    [(UILabel *)[cell.contentView viewWithTag:1] setText:tweet.screenNameString];
    
    UILabel *tweetLabel = (UILabel *)[cell.contentView viewWithTag:2];
    [tweetLabel setText:tweet.tweetTextString];
    [tweetLabel setNumberOfLines:0];

    // Calculate tweet label size based on tweet length.
    
    CGSize maxLabelSize = CGSizeMake( tweetLabel.frame.size.width, 9999.0f );;    
    CGSize labelSize = [tweet.tweetTextString sizeWithFont:tweetLabel.font 
                                    constrainedToSize:maxLabelSize 
                                        lineBreakMode:tweetLabel.lineBreakMode]; 
    
    CGRect newScreenNameFrame = tweetLabel.frame;
    newScreenNameFrame.size.height = labelSize.height;
    tweetLabel.frame = newScreenNameFrame;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];    
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    NSString *dateString = [dateFormatter stringFromDate:tweet.createdAtDate];
    
    [(UILabel *)[cell.contentView viewWithTag:3] setText:dateString];
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Calculate label size based on tweet length.
    
    NSArray *sortDescriptorsArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdAtDate" ascending:NO]];
    Tweet *tweet = (Tweet *)[[self.tweets sortedArrayUsingDescriptors:sortDescriptorsArray] objectAtIndex:indexPath.row];

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
