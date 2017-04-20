#import "GADArticle.h"

const NSTimeInterval timeoutInterval = 60.0;

@implementation GADArticle

static NSString *const API_KEY_ARTICLE_ID = @"id";
static NSString *const API_KEY_AUTHORS = @"authors";
static NSString *const API_KEY_BRIEF = @"brief";
static NSString *const API_KEY_CONTENT = @"content";
static NSString *const API_KEY_DATE_PUBLISHED = @"datePublished";
static NSString *const API_KEY_HEADER_IMAGE = @"headerImage";
static NSString *const API_KEY_PUBLICATION_ID = @"publication";
static NSString *const API_KEY_TITLE = @"title";

static NSString *const API_QUERY_PAGE_TOKEN = @"pageToken";

+ (void) articlesForPublicationId: (NSString *)publicationId
                    nextPageToken: (NSString * _Nullable)nextPageToken
                   withCompletion:(void(^_Nonnull)(NSArray<GADArticle *>
                                                   *_Nullable articles,
                                                   NSString *_Nullable token,
                                                   NSError *_Nullable error))completion {
    GADPublication *pub = [GADPublication new];
    pub.publicationId=publicationId;
    NSURL *queryURL = [pub urlForArticles];
    
    NSMutableDictionary *token=[NSMutableDictionary new];
    if (nextPageToken) {
        [token setObject:nextPageToken forKey:API_QUERY_PAGE_TOKEN];
    }
    
    [super fetchModelsWithParams:queryURL
                          queryParameters:token
                         modelTransformer:^(NSArray *jsonArray) {
                            return [self articlesFromArray:jsonArray];
                         }
                        completionHandler:completion];
}

+ (NSArray <GADArticle *> *) articlesFromArray: (NSArray *)jsonArray {
    
    NSMutableArray <GADArticle *> *articles = [NSMutableArray new];
    
    for (NSDictionary *element in jsonArray) {
        GADArticle *article = [self articleFromDictionary:element];
        [articles addObject:article];
    }
    return articles;
}

+ (GADArticle *) articleFromDictionary: (NSDictionary*)dict {
    //Map fields of element to fields of article
    GADArticle *article = [[GADArticle alloc] init];
    //datePublished field is a UNIX Timestamp number - converting to NSDate here
    int timeStamp = (int)dict[API_KEY_DATE_PUBLISHED];
    article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
    article.headerImage = [NSURL URLWithString:dict[API_KEY_HEADER_IMAGE]];
    article.publicationId = dict[API_KEY_PUBLICATION_ID];
    article.articleId = dict[API_KEY_ARTICLE_ID];
    article.title = dict[API_KEY_TITLE];
    article.authors = dict[API_KEY_AUTHORS];
    
    return article;
}

- (void) fetchFullTextWithCompletion: (void(^_Nonnull)(GADArticle *_Nullable article,
                                                       NSError *_Nullable error))completion {
    NSURL *queryURL = [self urlForFullArticle];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:queryURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completion(nil, error);
            return;
        }
        NSDictionary *jsonDict = [NSDictionary new];
        NSError *JSONParsingError;
        jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions error:&JSONParsingError];
        
        self.content = [jsonDict valueForKey:API_KEY_CONTENT];
        completion(self, nil);
    }];
    [task resume];
}

- (NSURL *) urlForFullArticle{
    GADPublication *pub = [GADPublication new];
    pub.publicationId=self.publicationId;
    NSURL *queryURL = [pub urlForArticles];
    queryURL = [NSURL URLWithString:[self articleId] relativeToURL:queryURL];
    return queryURL;
}

+ (NSArray <GADArticle *> *) loadDummyArticles {

    NSMutableArray <GADArticle *> *articleArray = [[NSMutableArray alloc] init];
    NSArray <NSString *> *authorNames = @[@"Alex", @"Mitchell", @"Addi", @"Gould", @"Garrett", @"Wang", @"Alex2", @"French", @"Nathan", @"Gifford"];
    
    for (int i = 0; i < 10; i++) {
        GADArticle *article = [[GADArticle alloc] init];
        article.publicationId = @"8e031545-ba66-11e6-8193-a0999b05c023";
        article.title = [NSString stringWithFormat:@"Testarticle %i", i];
        article.authors = [NSArray arrayWithObjects:@{@"name": authorNames[i], @"email": @"addisemail.edu"}, nil];
        article.series = @"ada28c7d-a49f-11e6-b9d3-a0999b05c023";
        //URL needs to change for each article
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

@end

