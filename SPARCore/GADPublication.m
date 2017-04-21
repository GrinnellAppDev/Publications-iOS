#import "GADPublication.h"
#import "GADArticle.h"

@implementation GADPublication

static NSString *const API_PUBLICATION_SUFFIX = @"publications";
static NSString *const API_ARTICLE_SUFFIX = @"articles";

static NSString *const API_KEY_PUBLICATION_ID = @"id";
static NSString *const API_KEY_PUBLICATION_NAME = @"name";

static NSString *const API_QUERY_PAGE_TOKEN = @"pageToken";

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        Completion:(void(^_Nonnull)
                                    (NSArray<GADPublication *> *_Nullable publications,
                                     NSString *_Nullable token,
                                     NSError *_Nullable error))completion {

    NSURL *queryURL = [self baseURL];
    
    NSMutableDictionary *params=[NSMutableDictionary new];
    if (nextPageToken) {
        [params setObject:nextPageToken forKey:API_QUERY_PAGE_TOKEN];
    }
    
    [super fetchModelsWithParams:queryURL
                 queryParameters:params
                modelTransformer:^(NSArray<NSDictionary *> *jsonArray) {
                    return [self publicationsFromArray:jsonArray];
                }
               completionHandler:completion];
}

- (void) fetchArticlesWithNextPageToken: (NSString * _Nullable)nextPageToken
                             Completion:(void(^_Nonnull)(NSArray<GADArticle *>
                                                         *_Nullable articles,
                                                         NSString *_Nullable token,
                                                         NSError *_Nullable error))completion {
    
    NSURL *queryURL = [self urlForArticles];
    
    NSMutableDictionary *params=[NSMutableDictionary new];
    if (nextPageToken) {
        [params setObject:nextPageToken forKey:API_QUERY_PAGE_TOKEN];
    }
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:params
                         modelTransformer:^(NSArray<NSDictionary *> *jsonArray) {
                             return [GADArticle articlesFromArray:jsonArray];
                         }
                        completionHandler:completion];
}

+ (NSArray <GADPublication *> *) publicationsFromArray:(NSArray<NSDictionary *> *)jsonArray {

    NSMutableArray <GADPublication *> *publications = [NSMutableArray new];
    
    for (NSDictionary *element in jsonArray) {
        GADPublication *publication = [GADPublication new];
        publication.publicationId = element[API_KEY_PUBLICATION_ID];
        publication.name = element[API_KEY_PUBLICATION_NAME];
        [publications addObject:publication];
    }
    return publications;
}

- (NSURL *) urlForArticles{
    NSURL *queryURL = [GADPublication baseURL];
    queryURL = [NSURL URLWithString:self.publicationId relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:API_ARTICLE_SUFFIX relativeToURL:queryURL];
    return queryURL;
}

+ (NSURL *)baseURL {
    return [NSURL URLWithString:API_PUBLICATION_SUFFIX relativeToURL:[super baseURL]];
}

@end
