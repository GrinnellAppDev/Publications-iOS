#import "GADRemoteModel.h"

@class SPARCArticle;

@interface SPARCPublication : GADRemoteModel

typedef void (^GADPublicationsCallback)(NSArray<SPARCPublication *> *_Nullable publications,
                                        NSString *_Nullable token,
                                        NSError *_Nullable error);
typedef void (^GADArticlesCallback)(NSArray<SPARCArticle *> *_Nullable publications,
                                      NSString *_Nullable token,
                                      NSError *_Nullable error);

@property (nonatomic, strong) NSString *_Nonnull publicationId;
@property (nonatomic, strong) NSString *_Nullable name;

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        completion:(_Nonnull GADPublicationsCallback)completion;

- (void) fetchArticlesWithNextPageToken: (NSString * _Nullable)nextPageToken
                             completion:(_Nonnull GADArticlesCallback)completion;

- (NSURL *_Nonnull) urlForArticles;

@end
