#import "SPARCPublication.h"

#import <SPARCore/SPARCore.h>

@implementation SPARCPublication

#pragma mark - API Constants

static NSString *const API_PUBLICATION_SUFFIX = @"publications";
static NSString *const API_ARTICLE_SUFFIX = @"articles";

static NSString *const API_KEY_PUBLICATION_ID = @"id";
static NSString *const API_KEY_PUBLICATION_NAME = @"name";

static NSString *const API_QUERY_PAGE_TOKEN = @"pageToken";

#pragma mark - Remote Content Fetching

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

- (void) fetchArticlesWithNextPageToken:(NSString * _Nullable)nextPageToken
                             completion:(GADArticlesCallback)completion {
  [[super class] fetchModelsWithURL:[self urlForArticles]
                     queryParameters:nil
                       nextPageToken:nextPageToken
                    modelTransformer:^(NSArray<NSDictionary *> *jsonArray) {
                      return [SPARCArticle articlesFromArray:jsonArray];
                    }
                   completionHandler:completion];
}

#pragma mark - Class Object Generators

+ (NSArray <SPARCPublication *> *) publicationsFromArray:(NSArray<NSDictionary *> *)jsonArray {
  
  NSMutableArray<SPARCPublication *> *publications = [NSMutableArray new];
  
  for (NSDictionary *element in jsonArray) {
    SPARCPublication *publication = [SPARCPublication new];
    publication.publicationId = element[API_KEY_PUBLICATION_ID];
    publication.name = element[API_KEY_PUBLICATION_NAME];
    [publications addObject:publication];
  }
  return publications;
}

#pragma mark - URL Generators

- (NSURL *_Nonnull) urlForArticles{
  NSURL *queryURL = [self.class baseURL];
  queryURL = [queryURL URLByAppendingPathComponent:self.publicationId];
  queryURL = [queryURL URLByAppendingPathComponent:API_ARTICLE_SUFFIX];
  return queryURL;
}

+ (NSURL *_Nonnull)baseURL {
  return [[super baseURL] URLByAppendingPathComponent:API_PUBLICATION_SUFFIX];
}

@end
