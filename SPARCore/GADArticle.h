#import <Foundation/Foundation.h>

@interface GADArticle : NSObject

@property (nonatomic, strong) NSDate *datePublished;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *headerImage;
@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSDate *dateEdited;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, strong) NSURL *url;
//@property (nonatomic, strong) NSInteger *pictureSize;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *issue;

+ (NSArray <GADArticle *> *) loadDummyArticles;

@end

