#import "GADRemoteModel.h"

static NSString *const API_HOSTNAME = @"https://g2j7qs2xs7.execute-api.us-west-2.amazonaws.com/";
static NSString *const API_PREFIX = @"devstable";

const NSTimeInterval timeoutInterval = 60.0;

@implementation GADRemoteModel

+ (void) fetchModelsWithParams:(NSURL * _Nonnull)baseURL
               queryParameters:(NSDictionary * _Nonnull)queryParams
              modelTransformer:(NSArray<GADRemoteModel *>*_Nonnull(^_Nonnull)
                                (NSData* _Nonnull jsonData))modelTransformer
             completionHandler:(void(^_Nonnull)(NSArray<GADRemoteModel *> *_Nullable models,
                                                NSError *_Nullable error))completion {
    
    NSMutableArray *queryItems = [NSMutableArray<NSURLQueryItem *> new];
    
    for (NSString *key in queryParams) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParams[key]]];
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:false];
    components.queryItems = queryItems;
    NSURL *url = components.URL;
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completion(nil, error);
            return;
        }
        NSArray<GADRemoteModel *> *modelObjects = modelTransformer(data);
        completion(modelObjects, nil);
        return;
    }];
    [task resume];
}

+ (NSURL *) baseURL {
    NSURL *queryURL = [NSURL URLWithString:API_HOSTNAME];
    queryURL = [NSURL URLWithString:API_PREFIX relativeToURL:queryURL];
    return queryURL;
}

@end
