//
//  GADRemoteModel.m
//  Publications
//
//  Created by Addison Gould on 3/5/17.
//  Copyright © 2017 comp. All rights reserved.
//

#import "GADRemoteModel.h"

@implementation GADRemoteModel

static NSString *apiURL = @"https://g2j7qs2xs7.execute-api.us-west-2.amazonaws.com/devstable/publications";
const NSTimeInterval timeoutInterval = 60.0;

+ (void) fetchArticlesFromPublication: (NSString *)publicationId completionHandler:(void(^_Nonnull)(NSData*))completion {
    NSMutableArray *queryItems = [NSMutableArray<NSURLQueryItem *> new];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publication" value:publicationId]];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:apiURL];
    components.queryItems = queryItems;
    NSURL *url = components.URL;
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        completion(data);
    }];
    [task resume];
}

@end
