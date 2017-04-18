#import <Foundation/Foundation.h>
#import "GADRemoteModel.h"

@interface GADArticle : GADRemoteModel

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *dateEdited;
@property (nonatomic, strong) NSDate *datePublished;
@property (nonatomic, strong) NSString *headerImage;
@property (nonatomic, strong) NSString *issue;
@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

+ (void) articlesFromPublication: (NSString *)publicationId
               completionHandler:(void(^_Nonnull)(NSArray<GADArticle *>
                                                  *_Nullable articles,
                                                  NSError *_Nullable error))completion;

+ (NSArray <GADArticle *> *) loadDummyArticles;

+ (NSArray <GADArticle *> *) articlesFromJSON:(NSData *)json;

@end

