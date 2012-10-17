//
//  MediaServer.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 8/20/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "MediaServer.h"
#import "NSString+EncodeURL.h"
#import "Tweet.h"

#define DEFAULT_TIMEOUT 120.0f
#define SEARCH_RESULTS_PER_TAG 20

@implementation MediaServer


#pragma mark - Properties

@synthesize operationQueue = _operationQueue;


#pragma mark - API

+ (id)sharedMediaServer;
{
    static dispatch_once_t onceToken;
    static id sharedMediaServer = nil;
    
    dispatch_once( &onceToken, ^{
        sharedMediaServer = [[[self class] alloc] init];
    });
    
    return sharedMediaServer;
}

- (void)fetchTweetsForSearch:(NSString *)searchString block:(FetchBlock)block;
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSMutableArray *tweetObjects = [[NSMutableArray alloc] init];
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;

        NSString *encodedSearchString = [searchString stringWithURLEncoding];
        NSString *URLString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@&rpp=%i&include_entities=true&result_type=mixed", encodedSearchString, SEARCH_RESULTS_PER_TAG];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *tweets = [JSON objectForKey:@"results"];
        
        // Serialize JSON response into lightweight Tweet objects for convenience.
        
        for ( NSDictionary *tweetDictionary in tweets )
        {
            Tweet *tweet = [[Tweet alloc] initWithJSON:tweetDictionary];
            [tweetObjects addObject:tweet];
        }        
        
        NSLog(@"Search for '%@' returned %i results.", searchString, [tweetObjects count]);
        
        // Return to the main queue once the request has been processed.
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if ( error )
                block( nil, error );
            else
                block( tweetObjects, nil );
        }];
        

    }];
    
    // Optionally, set the operation priority. This is useful when flooding
    // the operation queue with different requests.
    
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.operationQueue addOperation:operation];
}


#pragma mark - NSObject

- (id)init;
{
    if ( ( self = [super init] ) )
    {
        // The maxConcurrentOperationCount should reflect the number of open
        // connections the server can handle. Right now, limit it to two for
        // the sake of this example.
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 2;
    }
    
    return self;
}

@end
