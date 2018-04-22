#import "GADRemoteModel.h"

@class SPARCArticle;

@interface SPARCPublication : GADRemoteModel

typedef void (^GADPublicationsCallback)(NSArray<SPARCPublication *> *_Nullable publications,
                                        NSString *_Nullable token,
                                        NSError *_Nullable error);
typedef void (^GADArticlesCallback)(NSArray<SPARCArticle *> *_Nullable articles,
                                    NSString *_Nullable token,
                                    NSError *_Nullable error);

@property (nonatomic, strong) NSString *_Nonnull publicationId;
@property (nonatomic, strong) NSString *_Nullable name;

/*
 @brief For front-end to use. Fetch all publications from database. Optional nextPageToken.
 */
+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                      nextPageSize:(NSString * _Nullable)nextPageSize
                        completion:(_Nonnull GADPublicationsCallback)completion;

/*
 @brief For front-end to use. Fetch all articles from database for this publication instance. Optional nextPageToken.
 */
- (void) fetchArticlesWithNextPageToken:(NSString * _Nullable)nextPageToken
                           nextPageSize:(NSString * _Nullable)nextPageSize
                             completion:(_Nonnull GADArticlesCallback)completion;

/*
 @brief For SPARCArticle class to use.
 */
- (NSURL *_Nonnull) urlForArticles;

@end
