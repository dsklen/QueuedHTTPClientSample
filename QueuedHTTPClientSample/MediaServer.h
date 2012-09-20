//
//  MediaServer.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 8/20/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchBlock)(NSArray *items, NSError *error);


@interface MediaServer : NSObject

@property (strong) NSOperationQueue *operationQueue;

+ (id)sharedMediaServer;

- (void)fetchTweetsForSearch:(NSString *)searchString block:(FetchBlock)block;

@end
