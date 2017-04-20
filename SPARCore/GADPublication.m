#import "GADPublication.h"

@implementation GADPublication

static NSString *const API_PUBLICATION_PATH = @"publications";
static NSString *const API_ARTICLE_PATH = @"articles";

static NSString *const API_PUBLICATION_ID = @"id";
static NSString *const API_PUBLICATION_NAME = @"name";

static NSString *const API_PAGE_TOKEN_QUERY = @"pageToken";

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        Completion:(void(^_Nonnull)(NSArray<GADPublication *> *_Nullable publications, NSString *_Nullable token, NSError *_Nullable error))completion {

    NSURL *queryURL = [GADPublication baseURL];
    
    NSMutableDictionary *token=[NSMutableDictionary new];
    if (nextPageToken) {
        [token setObject:nextPageToken forKey:API_PAGE_TOKEN_QUERY];
    }
    
    [super fetchModelsWithParams:queryURL
                 queryParameters:token
                modelTransformer:^(NSArray *jsonArray) {
                    return [self publicationsFromArray:jsonArray];
                }
               completionHandler:completion];
}

+ (NSArray <GADPublication *> *) publicationsFromArray:(NSArray *)jsonArray {

    NSMutableArray <GADPublication *> *publications = [[NSMutableArray alloc] init];
    
    for (NSDictionary *element in jsonArray) {
        GADPublication *publication = [[GADPublication alloc] init];
        publication.publicationId = element[API_PUBLICATION_ID];
        publication.name = element[API_PUBLICATION_NAME];
        [publications addObject:publication];
    }
    return publications;
}

- (NSURL *) urlForArticles{
    NSURL *queryURL = [GADPublication baseURL];
    queryURL = [NSURL URLWithString:API_PUBLICATION_PATH relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:self.publicationId relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:API_ARTICLE_PATH relativeToURL:queryURL];
    return queryURL;
}

+ (NSURL *)baseURL {
    return [NSURL URLWithString:API_PUBLICATION_PATH relativeToURL:[super baseURL]];
}

@end
