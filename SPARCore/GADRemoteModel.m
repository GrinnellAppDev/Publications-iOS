#import "GADRemoteModel.h"

static NSString *const API_HOSTNAME = @"https://g2j7qs2xs7.execute-api.us-west-2.amazonaws.com/";
static NSString *const API_PREFIX = @"devstable";

static NSString *const API_ITEMS = @"items";
static NSString *const API_NEXT_PAGE_TOKEN = @"nextPageToken";

const NSTimeInterval timeoutInterval = 60.0;

@implementation GADRemoteModel

+ (void) fetchModelsWithParams:(NSURL * _Nonnull)baseURL
               queryParameters:(NSDictionary * _Nullable)queryParams
              modelTransformer:(NSArray<GADRemoteModel *>*(^_Nonnull)
                                (NSArray<NSDictionary *>* _Nonnull objects))modelTransformer
             completionHandler:(void(^_Nonnull)(NSArray<GADRemoteModel *> *_Nullable models, NSString *_Nullable token, NSError *_Nullable error))completion {
    
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
            completion(nil,nil,error);
            return;
        }
        
        NSError *JSONParsingError;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions error:&JSONParsingError];
        
        if (JSONParsingError) {
            NSLog(@"JSONParsingError: %@", JSONParsingError);
            completion(nil,nil,JSONParsingError);
            return;
        }
        
        NSArray *objects=[jsonDict valueForKey:API_ITEMS];
        NSString *token=[jsonDict valueForKey:API_NEXT_PAGE_TOKEN];
        
        NSArray<GADRemoteModel *> *modelObjects = modelTransformer(objects);
        completion(modelObjects, token, nil);
        return;
    }];
    [task resume];
}

+ (NSURL *) baseURL {
    NSURL *queryURL = [NSURL URLWithString:API_HOSTNAME];
    queryURL = [queryURL URLByAppendingPathComponent:API_PREFIX];
    return queryURL;
}

@end
