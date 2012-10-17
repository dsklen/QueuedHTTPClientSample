//
//  NSString+EncodeURL.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 10/16/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

/*
 * Category to safely URL encode search strings for the Twitter API.
 * 
 * Note that using NSString's stringByAddingPercentEscapesUsingEncoding: method
 * is not safe because '&' and '/' characters are not properly encoded.
 *
 * For more information, see: http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
 *
 */

#import <Foundation/Foundation.h>

@interface NSString (EncodeURL)

- (NSString *)stringWithURLEncoding;

@end
