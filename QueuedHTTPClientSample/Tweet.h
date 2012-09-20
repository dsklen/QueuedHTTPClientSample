//
//  Tweet.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 9/13/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

/*
 * Lightweight data object for storing fetched tweets.
 */

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *screenNameString;
@property (nonatomic, strong) NSDate *createdAtDate;
@property (nonatomic, strong) NSString *tweetTextString;

- (id)initWithJSON:(NSDictionary *)JSONObject;

@end
