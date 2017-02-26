#import <Foundation/Foundation.h>

@interface GADArticle : NSObject

//var publicationId: [String]
//var authors: [Any]
//var etc

@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSString* author;
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

+ (NSArray <GADArticle *> *) loadDummyArticles;

@end

