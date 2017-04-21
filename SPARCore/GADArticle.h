#import <Foundation/Foundation.h>
#import "GADRemoteModel.h"
#import "GADPublication.h"

@interface GADArticle : GADRemoteModel

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *dateEdited;
@property (nonatomic, strong) NSDate *datePublished;
@property (nonatomic, strong) NSURL *headerImage;
@property (nonatomic, strong) NSString *issue;
@property (nonatomic, strong) GADPublication *publication;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

+ (void) articlesForPublicationId: (NSString *)publicationId
                    nextPageToken: (NSString * _Nullable)nextPageToken
                   withCompletion:(void(^_Nonnull)(NSArray<GADArticle *>
                                                   *_Nullable articles,
                                                   NSString *_Nullable token,
                                                   NSError *_Nullable error))completion;

- (void) fetchFullTextWithCompletion: (void(^_Nonnull)(GADArticle *_Nullable article,
                                                       NSError *_Nullable error))completion;

+ (NSArray <GADArticle *> *) loadDummyArticles;

@end

