#import "GADRemoteModel.h"
@class GADArticle;

@interface GADPublication : GADRemoteModel

@property (nonatomic, strong) NSString *_Nonnull publicationId;
@property (nonatomic, strong) NSString *_Nullable name;

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        Completion:(void(^_Nonnull)(NSArray<GADPublication *>
                                                    *_Nullable publications,
                                                    NSString *_Nullable token,
                                                    NSError *_Nullable error))completion;

- (void) fetchArticlesWithNextPageToken: (NSString * _Nullable)nextPageToken
                             Completion:(void(^_Nonnull)(NSArray<GADArticle *>
                                                         *_Nullable articles,
                                                         NSString *_Nullable token,
                                                         NSError *_Nullable error))completion;

- (NSURL *_Nonnull) urlForArticles;

@end
