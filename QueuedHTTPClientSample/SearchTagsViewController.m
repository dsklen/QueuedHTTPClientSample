//
//  SearchTagsViewController.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "SearchTagsViewController.h"
#import "TweetsViewController.h"
#import "Constants.h"

#define EDIT_ALERT_TAG 4

@interface SearchTagsViewController ()

- (IBAction)showTweets:(id)sender;
- (IBAction)showAddTagPrompt:(id)sender;
- (void)addTag:(NSString *)tag;
- (void)editTagAtIndex:(NSInteger)index newTag:(NSString *)editedTag;
- (void)removeTag:(NSString *)tag;
- (void)reloadTags;

@end

@implementation SearchTagsViewController


#pragma mark - Properties

@synthesize searchTags = _searchTags;


#pragma mark - Private API

- (IBAction)showTweets:(id)sender;
{
    UIViewController *vc = [[TweetsViewController alloc] initWithTags:self.searchTags];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showAddTagPrompt:(id)sender;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Add tag", @"" ) message:NSLocalizedString( @"Add a twitter search tag.", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"Cancel", @"" ) otherButtonTitles:NSLocalizedString( @"Add", @"" ), nil];
    alertView.tag = 1;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)addTag:(NSString *)tag;
{
    NSArray *currentTags = [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchTagsKey"];
    
    if ( [currentTags containsObject:tag])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Error", @"" ) message:NSLocalizedString( @"You have already added this tag.", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"Okay", @"" ) otherButtonTitles: nil];
        alertView.tag = 2;
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        [alertView show];
        
        return;
    }
    
    if ( [currentTags count] > 0) 
    {
        NSMutableArray *mutableCurrentTags = [currentTags mutableCopy];
        [mutableCurrentTags addObject:tag];
        [[NSUserDefaults standardUserDefaults] setObject:[mutableCurrentTags copy] forKey:TagsDefaultsKey];
    }
    else 
    {   
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:tag] forKey:TagsDefaultsKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)editTagAtIndex:(NSInteger)index newTag:(NSString *)editedTag;
{
    NSArray *currentTags = [[NSUserDefaults standardUserDefaults] arrayForKey:TagsDefaultsKey];
    
    NSMutableArray *mutableCurrentTags = [currentTags mutableCopy];
    
    [mutableCurrentTags replaceObjectAtIndex:index withObject:editedTag];
        
    [[NSUserDefaults standardUserDefaults] setObject:[mutableCurrentTags copy] forKey:TagsDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeTag:(NSString *)tag;
{
    NSArray *currentTags = [[NSUserDefaults standardUserDefaults] arrayForKey:TagsDefaultsKey];
    
    NSMutableArray *mutableCurrentTags = [currentTags mutableCopy];
    
    [mutableCurrentTags removeObject:tag];
    
    [[NSUserDefaults standardUserDefaults] setObject:[mutableCurrentTags copy] forKey:TagsDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reloadTags;
{
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] arrayForKey:TagsDefaultsKey] mutableCopy]);
    
    self.searchTags = [[[NSUserDefaults standardUserDefaults] arrayForKey:TagsDefaultsKey] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if ( self ) 
    {
        _searchTags = [[NSMutableArray alloc] init];
        
        self.title = NSLocalizedString( @"Tags", @"" );
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddTagPrompt:)];
    
    self.toolbarItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"View Tweets", @"" ) style:UIBarButtonItemStylePlain target:self action:@selector(showTweets:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], nil];
    
    [self reloadTags];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    return ( interfaceOrientation == UIInterfaceOrientationPortrait );
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if ( alertView.tag == 1 ) 
    {
        if ( buttonIndex == 1 ) 
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [self addTag:textField.text];
            [self reloadTags];
        }
    }
    else if ( alertView.tag > 3)
    {
        if ( buttonIndex == 1 ) 
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [self editTagAtIndex:alertView.tag - EDIT_ALERT_TAG newTag:textField.text];
            [self reloadTags];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    return (textField.text.length > 0 );
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.searchTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.searchTags objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ( editingStyle == UITableViewCellEditingStyleDelete ) 
    {
        [self removeTag:[self.searchTags objectAtIndex:indexPath.row]];
        [self.searchTags removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Edit tag", @"" ) message:NSLocalizedString( @"Edit this twitter search tag.", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"Cancel", @"" ) otherButtonTitles:NSLocalizedString( @"Save", @"" ), nil];
    alertView.tag = indexPath.row + EDIT_ALERT_TAG;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = [self.searchTags objectAtIndex:indexPath.row];
    
    [alertView show];
}

@end
