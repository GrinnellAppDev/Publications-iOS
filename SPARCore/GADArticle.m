#import "GADArticle.h"

@implementation GADArticle

static NSString *const API_ARTICLE_ID = @"id";
static NSString *const API_AUTHORS = @"authors";
static NSString *const API_BRIEF = @"brief";
static NSString *const API_CONTENT = @"content";
static NSString *const API_DATE_PUBLISHED = @"datePublished";
static NSString *const API_HEADER_IMAGE = @"headerImage";
static NSString *const API_PUBLICATION_ID = @"publication";
static NSString *const API_TITLE = @"title";

static NSString *const API_ITMES = @"items";
static NSString *const API_NEXT_PAGE_TOKEN = @"nextPageToken";

static NSString *const API_PUBLICATION_PATH = @"publications";
static NSString *const API_ARTICLE_PATH = @"articles";

+ (void) articlesForPublicationId: (NSString *)publicationId
                   withCompletion:(void(^_Nonnull)(NSArray<GADArticle *>
                                                   *_Nullable articles,
                                                   NSError *_Nullable error))completion {
    GADPublication *pub = [GADPublication new];
    pub.publicationId=publicationId;
    NSURL *queryURL = [pub urlForArticles];
    
    [super fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData) {
                            return [self articlesFromJSON:jsonData];
                         }
                        completionHandler:completion];

}

+ (NSArray <GADArticle *> *) articlesFromJSON: (NSData *)json {
    
    NSDictionary* jsonDict=[NSDictionary new];
    NSArray *jsonArray=[NSArray new];
    NSMutableArray <GADArticle *> *articles = [NSMutableArray new];
    
    NSError *JSONParsingError;
    jsonDict = [NSJSONSerialization JSONObjectWithData:json
                                                         options:kNilOptions error:&JSONParsingError];
    
    jsonArray=[jsonDict valueForKey:API_ITMES];
    
    //get next page token here, but don't know how to return it yet
    NSString *nextPageToken = [jsonDict valueForKey:API_NEXT_PAGE_TOKEN];
    
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
    int timeStamp = (int)dict[API_DATE_PUBLISHED];
    article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
    article.headerImage = [NSURL URLWithString:dict[API_HEADER_IMAGE]];
    article.publicationId = dict[API_PUBLICATION_ID];
    article.articleId = dict[API_ARTICLE_ID];
    article.title = dict[API_TITLE];
    article.authors = dict[API_AUTHORS];
    
    return article;
}

- (void) fetchFullTextWithCompletion: (void(^_Nonnull)(GADArticle *_Nullable article,
                                                       NSError *_Nullable error))completion {
    NSURL *queryURL = [self urlForFullArticle];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData){
                             return [GADArticle fullArticleFromJsonData:jsonData];
                         }
                        completionHandler:^(NSArray <GADArticle *> *_Nullable model, NSError *_Nullable error){
                            GADArticle *fullArticle = model[0];
                            self.content = fullArticle.content;
                            self.authors = fullArticle.authors;
                            completion(self,nil);
                        }];
    
}

+ (NSArray *) fullArticleFromJsonData: (NSData *)json {
    NSDictionary *jsonDict=[NSDictionary new];
    NSError *JSONParsingError;
    jsonDict = [NSJSONSerialization JSONObjectWithData:json
                                               options:kNilOptions error:&JSONParsingError];
    
    GADArticle *article = [[GADArticle alloc] init];
    int timeStamp = (int)jsonDict[API_DATE_PUBLISHED];
    article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
    article.brief = jsonDict[API_BRIEF];
    article.headerImage = [NSURL URLWithString:jsonDict[API_HEADER_IMAGE]];
    article.publicationId = jsonDict[API_PUBLICATION_ID];
    article.articleId = jsonDict[API_ARTICLE_ID];
    article.title = jsonDict[API_TITLE];
    article.authors = jsonDict[API_AUTHORS];
    if (jsonDict[API_CONTENT]) {
        article.content = jsonDict[API_CONTENT];
    }
    
    NSMutableArray *wrapper = [NSMutableArray new];
    [wrapper addObject:article];
    
    return wrapper;
}

- (NSURL *) urlForFullArticle{
    GADPublication *pub = [GADPublication new];
    pub.publicationId=self.publicationId;
    NSURL *queryURL = [pub urlForArticles];
    queryURL = [NSURL URLWithString:[self articleId] relativeToURL:queryURL];
    return queryURL;
}

// needs to be changed
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

