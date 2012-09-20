//
//  Tweet.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

@synthesize screenNameString;
@synthesize createdAtDate;
@synthesize tweetTextString;


- (id)initWithJSON:(NSDictionary *)JSONObject;
{
 	if ( self = [super init] )
    {
        self.screenNameString = [JSONObject objectForKey:@"from_user"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, d LLL yyyy HH:mm:ss Z"];
        self.createdAtDate = [dateFormatter dateFromString:[JSONObject objectForKey:@"created_at"]];
        
        self.tweetTextString = [JSONObject objectForKey:@"text"];
    }
    
    return self;
}

@end
