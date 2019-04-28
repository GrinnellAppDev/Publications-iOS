#import "GADRemoteModel.h"

#pragma mark - API Constants
//static NSString *const API_HOSTNAME = @"https://appdev.grinnell.edu/api/publications/v1/";
static NSString *const API_HOSTNAME = @"https://chenziwe.com/";

static NSString *const API_PREFIX = @"";

static NSString *const API_ITEMS = @"items";
static NSString *const API_NEXT_PAGE_TOKEN = @"nextPageToken";

static NSString *const API_QUERY_PAGE_SIZE = @"pageSize";
static NSString *const API_QUERY_PAGE_TOKEN = @"pageToken";

static const NSTimeInterval timeoutInterval = 60.0;

@implementation GADRemoteModel

#pragma mark - Remote Content Fetching

+ (void) fetchModelsWithURL:(NSURL * _Nonnull)url
            queryParameters:(NSDictionary * _Nullable)queryParams
               nextPageSize:(GADNextPageSize _Nullable)nextPageSize
              nextPageToken:(GADNextPageToken _Nullable)nextPageToken
           modelTransformer:(GADModelTransformer _Nonnull)modelTransformer
          completionHandler:(GADRemoteCompletionHandler _Nonnull)completion {
  
  NSMutableArray *queryItems = [NSMutableArray<NSURLQueryItem *> new];
  if (nextPageToken) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:API_QUERY_PAGE_TOKEN
                                                      value:nextPageToken]];
  }
  if (nextPageSize) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:API_QUERY_PAGE_SIZE
                                                          value:nextPageSize]];
  }
  for (NSString *key in queryParams) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParams[key]]];
  }
  
  NSURLComponents *components = [NSURLComponents componentsWithURL:url
                                           resolvingAgainstBaseURL:false];
  components.queryItems = queryItems;
  
  url = components.URL;
  
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
    NSLog(@"article count: %lu", [objects count]);
    NSLog(@"page token: %@", token);

    NSArray<GADRemoteModel *> *modelObjects = modelTransformer(objects);
    NSLog(@"transformed!");
    NSLog(@"article count2: %lu", [modelObjects count]);


    if ([jsonDict objectForKey:API_NEXT_PAGE_TOKEN] == [NSNull null]) {
        completion(modelObjects, nil, nil);
    } else {
        completion(modelObjects, token, nil);
    }


    return;
  }];
  [task resume];
}

#pragma mark - URL Generators

+ (NSURL *) baseURL {
  NSURL *queryURL = [NSURL URLWithString:API_HOSTNAME];
  queryURL = [queryURL URLByAppendingPathComponent:API_PREFIX];
  return queryURL;
}

@end
