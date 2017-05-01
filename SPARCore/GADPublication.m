#import "GADPublication.h"
#import "GADArticle.h"

@implementation GADPublication

#pragma mark - API Constants
static NSString *const API_PUBLICATION_SUFFIX = @"publications";
static NSString *const API_ARTICLE_SUFFIX = @"articles";

static NSString *const API_KEY_PUBLICATION_ID = @"id";
static NSString *const API_KEY_PUBLICATION_NAME = @"name";

static NSString *const API_QUERY_PAGE_TOKEN = @"pageToken";

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        completion:(GADPublicationsCallback)completion {
  [super fetchModelsWithURL:[self baseURL]
            queryParameters:nil
              nextPageToken:nextPageToken
           modelTransformer:^(NSArray<NSDictionary *> *jsonArray) {
             return [self publicationsFromArray:jsonArray];
           }
          completionHandler:completion];
}

- (void) fetchArticlesWithNextPageToken: (NSString * _Nullable)nextPageToken
                             completion:(GADPublicationsCallback)completion {
  [GADRemoteModel fetchModelsWithURL:[self urlForArticles]
                     queryParameters:nil
                       nextPageToken:nextPageToken
                    modelTransformer:^(NSArray<NSDictionary *> *jsonArray) {
                      return [GADArticle articlesFromArray:jsonArray];
                    }
                   completionHandler:completion];
}

#pragma mark - Class Object Generators

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

#pragma mark - URL Generators

- (NSURL *) urlForArticles{
  NSURL *queryURL = [GADPublication baseURL];
  queryURL = [queryURL URLByAppendingPathComponent:self.publicationId];
  queryURL = [queryURL URLByAppendingPathComponent:API_ARTICLE_SUFFIX];
  return queryURL;
}

+ (NSURL *)baseURL {
  return [[super baseURL] URLByAppendingPathComponent:API_PUBLICATION_SUFFIX];
}

@end
