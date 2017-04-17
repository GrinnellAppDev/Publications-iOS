#import "GADPublication.h"

@implementation GADPublication

static NSString *const API_HOSTNAME = @"https://g2j7qs2xs7.execute-api.us-west-2.amazonaws.com/";
static NSString *const API_PREFIX = @"devstable";
static NSString *const API_PUBLICATION_PATH = @"publications";

static NSString *const API_PUBLICATION_ID = @"id";
static NSString *const API_PUBLICATION_NAME = @"name";

+ (void) fetchPublicationsWithCompletionHandler:(void(^_Nonnull)(NSArray<GADPublication *> *_Nullable publications, NSError *_Nullable error))completion {

    NSURL *queryURL = [GADPublication urlForPublications];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData) {
                             return [GADPublication publicationsFromJSON:jsonData];
                         }
                        completionHandler:completion];
}

+ (NSArray <GADPublication *> *) publicationsFromJSON:(NSData *)json {

    NSMutableArray <GADPublication *> *publications = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:json
                                                         options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    
    NSArray *jsonArray = [jsonDict valueForKey:@"items"];
    
    for (NSDictionary *element in jsonArray) {
        GADPublication *publication = [[GADPublication alloc] init];
        publication.publicationId = element[API_PUBLICATION_ID];
        publication.name = element[API_PUBLICATION_NAME];
        [publications addObject:publication];
    }
    return publications;
}

+ (NSURL *) baseURL {
    NSURL *queryURL = [NSURL URLWithString:API_HOSTNAME];
    queryURL = [NSURL URLWithString:API_PREFIX relativeToURL:queryURL];
    return queryURL;
}

+ (NSURL *) urlForPublications {
    NSURL *queryURL = [GADPublication baseURL];
    queryURL = [NSURL URLWithString:API_PUBLICATION_PATH relativeToURL:queryURL];
    return queryURL;
}

@end
