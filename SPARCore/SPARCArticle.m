#import "SPARCArticle.h"

#import <SPARCore/SPARCore.h>

static const NSTimeInterval timeoutInterval = 60.0;

@implementation SPARCArticle

#pragma mark - Utility Methods

+ (NSString *) parseAuthors: (NSArray<NSDictionary<NSString*, id>*>*) authorArr {
    NSString *authorText = @"by ";
    for (NSDictionary<NSString*, id> *auth in authorArr) {
        if ([auth objectForKey:@"name"] != (id)[NSNull null]) {
            NSString *authorName = [auth objectForKey:@"name"];
            authorText = [authorText stringByAppendingString:authorName];
        } else {
            authorText = [authorText stringByAppendingString:@"Anonymous"];
        }
    }
    return authorText;
}

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

+ (SPARCArticle *) articleFromDictionary: (NSDictionary*)dict {
  NSLog(@"converting");

  SPARCArticle *article = [SPARCArticle new];
  article.articleId = dict[API_KEY_ARTICLE_ID];
  article.authors = dict[API_KEY_AUTHORS];
  article.brief = dict[API_KEY_BRIEF];
  article.content = dict[API_KEY_CONTENT];
    NSLog(@"%@", article.content);

  //datePublished field is a UNIX Timestamp number - converting to NSDate here
  NSString *time = [dict[API_KEY_DATE_EDITED] stringValue];
  NSString *convertedTime = [time substringToIndex:[time length]-3];
  int timeStamp = [convertedTime intValue];
  article.dateEdited = [NSDate dateWithTimeIntervalSince1970: timeStamp];
  time = [dict[API_KEY_DATE_PUBLISHED] stringValue];
  convertedTime = [time substringToIndex:[time length]-3];
  timeStamp = [convertedTime intValue];
  article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
  //Fetching Header image from the URL we pulled from the server
  if (dict[API_KEY_HEADER_IMAGE] == [NSNull null]) {
    article.headerImageURL = nil;
  } else {
    article.headerImageURL = [NSURL URLWithString:dict[API_KEY_HEADER_IMAGE]];
    NSLog(@"HEY, FOUND AN IMAGE: %@", article.headerImageURL);
  }
    
  article.headerImage = [SPARCArticle getImageFromImageURL:article.headerImageURL];
  article.issue = dict[API_KEY_ISSUE];
  article.publication=[SPARCPublication new];
  article.publication.publicationId = dict[API_KEY_PUBLICATION_ID];
  article.series = dict[API_KEY_SERIES];
  article.tags = dict[API_KEY_TAGS];
  article.title = dict[API_KEY_TITLE];
  article.url = dict[API_KEY_URL];
  return article;
}

+ (NSArray <SPARCArticle *> *)articlesFromArray:(NSArray<NSDictionary *> *)array {
    
    NSMutableArray <SPARCArticle *> *articles = [NSMutableArray new];
    
    for (NSDictionary *element in array) {
        NSLog(@"converting article");
        SPARCArticle *article = [self articleFromDictionary:element];
        [articles addObject:article];
    }
    return articles;
}

+ (UIImage * _Nullable) getImageFromImageURL:(NSURL * _Nullable) imageURL {
    if (imageURL == nil) {
        return nil;
    } else {
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        return [[UIImage alloc] initWithData:imageData];
    }
}

#pragma mark - Instance Updaters

- (void) updateWithDictionary:(NSDictionary *)dict {
    NSLog(@"updating");

    self.articleId = dict[API_KEY_ARTICLE_ID];
    self.authors = dict[API_KEY_AUTHORS];
    self.brief = dict[API_KEY_BRIEF];
    self.content = dict[API_KEY_CONTENT];
    NSLog(@"printing contenttt");

    //NSLog(@"%@", self.content);
    //datePublished field is a UNIX Timestamp number - converting to NSDate here
    NSString *time = [dict[API_KEY_DATE_EDITED] stringValue];
    NSString *convertedTime = [time substringToIndex:[time length]-3];
    int timeStamp = [convertedTime intValue];
    self.dateEdited = [NSDate dateWithTimeIntervalSince1970: timeStamp];
    time = [dict[API_KEY_DATE_PUBLISHED] stringValue];
    convertedTime = [time substringToIndex:[time length]-3];
    timeStamp = [convertedTime intValue];
    self.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
    //Pull header image from server
    if (dict[API_KEY_HEADER_IMAGE] == [NSNull null]) {
        self.headerImageURL = nil;
        NSLog(@"Cannot fetch ANY IMAGE.");
    } else {
        self.headerImageURL = [NSURL URLWithString:dict[API_KEY_HEADER_IMAGE]];
        NSLog(@"HEY, FOUND AN IMAGE: %@", self.headerImageURL);
    }
    self.headerImage = [SPARCArticle getImageFromImageURL:self.headerImageURL];
    self.issue = dict[API_KEY_ISSUE];
    self.publication=[SPARCPublication new];
    self.publication.publicationId = dict[API_KEY_PUBLICATION_ID];
    self.series = dict[API_KEY_SERIES];
    self.tags = dict[API_KEY_TAGS];
    self.title = dict[API_KEY_TITLE];
    self.url = dict[API_KEY_URL];
}

#pragma mark - Remote Content Fetching

- (void) fetchFullTextWithCompletion: (void(^_Nonnull)(SPARCArticle *_Nullable article,
                                                       NSError *_Nullable error))completion {
    NSURL *queryURL = [self urlForFullArticle];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:queryURL
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:timeoutInterval];
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest:req
                                  completionHandler:^(NSData *_Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError *_Nullable error) {
                                      if (error) {
                                          NSLog(@"Error: %@", error);
                                          completion(nil, error);
                                          return;
                                      }
                                      
                                      NSError *JSONParsingError;
                                      NSDictionary *jsonDict = [NSJSONSerialization
                                                                JSONObjectWithData:data
                                                                options:kNilOptions
                                                                error:&JSONParsingError];
                                      if (JSONParsingError) {
                                          NSLog(@"JSONParsingError: %@", JSONParsingError);
                                          completion(nil,JSONParsingError);
                                          return;
                                      }
                                      
                                      [self updateWithDictionary:jsonDict];
                                      completion(self, nil);
                                  }];
    [task resume];
}

#pragma mark - URL Generators

- (NSURL *) urlForFullArticle{
  NSURL *queryURL = [self.publication urlForArticles];
  queryURL = [queryURL URLByAppendingPathComponent:self.articleId];
  return queryURL;
}

#pragma mark - Dummy Data

+ (NSArray <SPARCArticle *> *) loadDummyArticles {
    
    NSMutableArray <SPARCArticle *> *articleArray = [NSMutableArray new];
    NSArray <NSString *> *authorNames = @[@"Alex", @"Mitchell", @"Addi", @"Gould", @"Garrett", @"Wang", @"Alex2", @"French", @"Nathan", @"Gifford"];
    
    for (int i = 0; i < 10; i++) {
        SPARCArticle *article = [SPARCArticle new];
        article.publication=[SPARCPublication new];
        article.publication.publicationId = @"8e031545-ba66-11e6-8193-a0999b05c023";
        article.title = [NSString stringWithFormat:@"Testarticle %i", i];
        article.authors = [NSArray arrayWithObjects:@{@"name": authorNames[i], @"email": @"addisemail.edu"}, nil];
        article.series = @"ada28c7d-a49f-11e6-b9d3-a0999b05c023";
        article.url = [NSURL URLWithString:@"http://www.thesandb.com/news/shacs-to-offer-funds-for-students-in-need.html"];
        article.tags = [NSArray arrayWithObjects:@"amazing!", @"fantastic!", @"Computer science!", nil];
        article.brief = [NSString stringWithFormat:@"This is very brief %i", i];
        article.content = @"This is much less brief because it should be longer than the brief";
        article.datePublished = [NSDate date];
        article.issue = @"ae2f3b54-a49f-11e6-b1ab-a0999b05c023";
        article.articleId = @"db7bc676-ba7d-11e6-8de8-a20f19d048b3";
        
        [articleArray addObject:article];
    }
    return articleArray;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.articleId = [decoder decodeObjectForKey:API_KEY_ARTICLE_ID];
        self.authors = [decoder decodeObjectForKey:API_KEY_AUTHORS];
        self.brief = [decoder decodeObjectForKey:API_KEY_BRIEF];
        self.content = [decoder decodeObjectForKey:API_KEY_CONTENT];
        //datePublished field is a UNIX Timestamp number - converting to NSDate here
        self.dateEdited = [decoder decodeObjectForKey:API_KEY_DATE_EDITED];
        self.datePublished = [decoder decodeObjectForKey:API_KEY_DATE_PUBLISHED];
        NSData* imageData = [decoder decodeObjectForKey:API_KEY_HEADER_IMAGE];
        NSLog(@"imagedataaaaaa %@",imageData);
        if (imageData == nil) {
            self.headerImage = nil;
        } else {
            self.headerImage = [UIImage imageWithData:imageData];
            //NSLog(@"image %@",self.headerImage);
        }
        self.issue = [decoder decodeObjectForKey:API_KEY_ISSUE];
        // self.publication=[SPARCPublication new];
        // self.publication.publicationId = dict[API_KEY_PUBLICATION_ID];
        self.series = [decoder decodeObjectForKey:API_KEY_SERIES];
        self.tags = [decoder decodeObjectForKey:API_KEY_TAGS];
        self.title = [decoder decodeObjectForKey:API_KEY_TITLE];
        self.url = [decoder decodeObjectForKey:API_KEY_URL];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_articleId forKey:API_KEY_ARTICLE_ID];
    [encoder encodeObject:_authors forKey:API_KEY_AUTHORS];
    [encoder encodeObject:_brief forKey:API_KEY_BRIEF];
    [encoder encodeObject:_content forKey:API_KEY_CONTENT];
    [encoder encodeObject:_dateEdited forKey:API_KEY_DATE_EDITED];
    [encoder encodeObject:_datePublished forKey:API_KEY_DATE_PUBLISHED];
    [encoder encodeObject:UIImageJPEGRepresentation(_headerImage, 1) forKey:API_KEY_HEADER_IMAGE];
    [encoder encodeObject:_issue forKey:API_KEY_ISSUE];
    // Ignored publication field. Can add later.
    [encoder encodeObject:_tags forKey:API_KEY_TAGS];
    [encoder encodeObject:_title forKey:API_KEY_TITLE];
    [encoder encodeObject:_url forKey:API_KEY_URL];
}

@end
