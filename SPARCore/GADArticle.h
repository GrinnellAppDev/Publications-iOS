#import <Foundation/Foundation.h>

@interface GADArticle : NSObject

@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, strong) NSURL *url;
//@property (nonatomic, strong) NSInteger *pictureSize;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSDate *datePublished;
@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) NSSOMETHING *headerImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *issue;
@property (nonatomic, strong) NSString *articleId;

- (GADArticle *) initWithDictionary: (NSDictionary*) dict;

- (GADArticle *) updateArticleWithContent: (GADArticle*) articleStub;

+ (NSArray <GADArticle *> *) loadArticles;

@end
