//
//  NSString+EncodeURL.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 10/16/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "NSString+EncodeURL.h"

@implementation NSString (EncodeURL)

- (NSString *)stringWithURLEncoding;
{
    // Note that stringByAddingPercentEscapesUsingEncoding is not safe for
    // every input string, but CFURLCreateStringByAddingPercentEscapes should
    // be fine.
    
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
}

@end
