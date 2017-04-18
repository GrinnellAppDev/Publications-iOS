#import "GADPublication.h"

@implementation GADPublication

static NSString *const API_PUBLICATION_PATH = @"publications";

static NSString *const API_PUBLICATION_ID = @"id";
static NSString *const API_PUBLICATION_NAME = @"name";

+ (void) fetchAllWithCompletion:(void(^_Nonnull)(NSArray<GADPublication *> *_Nullable publications, NSError *_Nullable error))completion {

    NSURL *queryURL = [GADPublication baseURL];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData) {
                             return [GADPublication publicationsFromJSON:jsonData];
                         }
                        completionHandler:completion];
}

+ (NSArray <GADPublication *> *) publicationsFromJSON:(NSData *)json {

    NSMutableArray <GADPublication *> *publications = [[NSMutableArray alloc] init];
    NSError *JSONParsingError;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:json
                                                         options:kNilOptions error:&JSONParsingError];
    
    NSArray *jsonArray = [jsonDict valueForKey:@"items"];
    
    for (NSDictionary *element in jsonArray) {
        GADPublication *publication = [[GADPublication alloc] init];
        publication.publicationId = element[API_PUBLICATION_ID];
        publication.name = element[API_PUBLICATION_NAME];
        [publications addObject:publication];
    }
    return publications;
}

+ (NSURL *)baseURL {
    return [NSURL URLWithString:API_PUBLICATION_PATH relativeToURL:[super baseURL]];
}

@end
