#import "SPARCArticle.h"

#import <SPARCore/SPARCore.h>

@implementation SPARCArticle

#pragma mark - API Constants
static NSString *const API_KEY_ARTICLE_ID = @"id";
static NSString *const API_KEY_AUTHORS = @"authors";
static NSString *const API_KEY_BRIEF = @"brief";
static NSString *const API_KEY_CONTENT = @"content";
static NSString *const API_KEY_DATE_EDITED = @"dateEdited";
static NSString *const API_KEY_DATE_PUBLISHED = @"datePublished";
static NSString *const API_KEY_HEADER_IMAGE = @"headerImage";
static NSString *const API_KEY_ISSUE = @"issue";
static NSString *const API_KEY_PUBLICATION_ID = @"publication";
static NSString *const API_KEY_SERIES = @"series";
static NSString *const API_KEY_TAGS = @"tags";
static NSString *const API_KEY_TITLE = @"title";
static NSString *const API_KEY_URL = @"url";

static NSString *const API_QUERY_PAGE_TOKEN = @"pageToken";

# pragma mark - Class Object Generators
+ (NSArray <SPARCArticle *> *)articlesFromArray:(NSArray<NSDictionary *> *)array {
  
  NSMutableArray <SPARCArticle *> *articles = [NSMutableArray new];
  
  for (NSDictionary *element in array) {
    SPARCArticle *article = [self articleFromDictionary:element];
    [articles addObject:article];
  }
  return articles;
}

+ (SPARCArticle *) articleFromDictionary: (NSDictionary*)dict {
  SPARCArticle *article = [SPARCArticle new];
  article.articleId = dict[API_KEY_ARTICLE_ID];
  article.authors = dict[API_KEY_AUTHORS];
  article.brief = dict[API_KEY_BRIEF];
  article.content = dict[API_KEY_CONTENT];
  //datePublished field is a UNIX Timestamp number - converting to NSDate here
  int timeStamp = (int)dict[API_KEY_DATE_EDITED];
  article.dateEdited = [NSDate dateWithTimeIntervalSince1970: timeStamp];
  timeStamp = (int)dict[API_KEY_DATE_PUBLISHED];
  article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
  article.headerImageURL = [NSURL URLWithString:dict[API_KEY_HEADER_IMAGE]];
  article.issue = dict[API_KEY_ISSUE];
  article.publication=[SPARCPublication new];
  article.publication.publicationId = dict[API_KEY_PUBLICATION_ID];
  article.series = dict[API_KEY_SERIES];
  article.tags = dict[API_KEY_TAGS];
  article.title = dict[API_KEY_TITLE];
  article.url = dict[API_KEY_URL];
  return article;
}

#pragma mark - Instance Updaters
- (void)updateWithArticle:(SPARCArticle *)article {
  self.articleId = article.articleId;
  self.authors = article.authors;
  self.brief = article.brief;
  self.content = article.content;
  self.dateEdited = article.dateEdited;
  self.datePublished = article.datePublished;
  self.headerImage = article.headerImage;
  self.headerImageURL = article.headerImageURL;
  self.issue = article.issue;
  self.publication = article.publication;
  self.series = article.series;
  self.tags = article.tags;
  self.title = article.title;
  self.url = article.url;
}

- (void) fetchFullTextWithCompletion: (void(^_Nonnull)(SPARCArticle *_Nullable article,
                                                       NSError *_Nullable error))completion {
  [[super class] fetchModelsWithURL:[self urlForFullArticle]
                    queryParameters:nil
                      nextPageToken:nil
                   modelTransformer:^NSArray<GADRemoteModel *> * _Nonnull (NSArray<NSDictionary *> * _Nonnull objects) {
     return [[super class]articlesFromArray:objects];
   } completionHandler:^(NSArray<GADRemoteModel *> * _Nullable models,
                         GADNextPageToken  _Nullable token,
                         NSError * _Nullable error) {
     SPARCArticle *article = (SPARCArticle *)[models firstObject];
     if (article) {
       [self updateWithArticle:article];
     }
     completion(self,error);
   }];
}

#pragma mark - URL Generators

- (NSURL *) urlForFullArticle{
  NSURL *queryURL = [self.publication urlForArticles];
  queryURL = [queryURL URLByAppendingPathComponent:self.articleId];
  return queryURL;
}



@end
