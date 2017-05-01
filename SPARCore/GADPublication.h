#import "GADRemoteModel.h"

@class GADArticle;

@interface GADPublication : GADRemoteModel

typedef void (^GADPublicationsCallback)(NSArray<GADPublication *> *_Nullable publications,
                                        NSString *_Nullable token,
                                        NSError *_Nullable error) ;

@property (nonatomic, strong) NSString *_Nonnull publicationId;
@property (nonatomic, strong) NSString *_Nullable name;

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        completion:(_Nonnull GADPublicationsCallback)completion;

- (void) fetchArticlesWithNextPageToken: (NSString * _Nullable)nextPageToken
                             completion:(_Nonnull GADPublicationsCallback)completion;

- (NSURL *_Nonnull) urlForArticles;

@end
