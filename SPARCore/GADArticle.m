#import "GADArticle.h"
#import "GADRemoteModel.h"

@implementation GADArticle

static NSString *const API_KEY_ARTICLE_ID = @"id";
static NSString *const API_KEY_AUTHORS = @"authors";
static NSString *const API_KEY_BRIEF = @"brief";
static NSString *const API_KEY_CONTENT = @"content";
static NSString *const API_KEY_DATE_PUBLISHED = @"datePublished";
static NSString *const API_KEY_HEADER_IMAGE = @"headerImage";
static NSString *const API_KEY_PUBLICATION_ID = @"publication";
static NSString *const API_KEY_TITLE = @"title";

static NSString *const API_HOSTNAME = @"https://g2j7qs2xs7.execute-api.us-west-2.amazonaws.com/";
static NSString *const API_PREFIX = @"devstable";
static NSString *const API_PUBLICATION_PATH = @"publications";
static NSString *const API_SUFFIX = @"articles";

+ (void) articlesForPublicationId: (NSString *)publicationId
                completionHandler:(void(^_Nonnull)(NSArray<GADArticle *>
                                  *_Nullable articles,
                                  NSError *_Nullable error))completion {
    NSURL *queryURL = [GADArticle urlForArticlesWithPublicationId:publicationId];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData) {
                            return [GADArticle articlesFromJSON:jsonData];
                         }
                        completionHandler:completion];
}


- (void) fetchFulltextWithCompletion: (void(^_Nonnull)(GADArticle * *_Nullable article,
                                      NSError *_Nullable error))completion {
    NSURL *queryURL = [self urlForFulltextArticle];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData){
                             return [GADArticle articlesFromJSON:jsonData];
                         }
                        completionHandler:^(NSArray <GADArticle *> *_Nullable article, NSError *_Nullable error){
                            GADArticle *fullArticle = article[0];
                            self.content = fullArticle.content;
                            self.authors = fullArticle.authors;
                            completion(self, nil);
                        }];
}

+ (NSArray <GADArticle *> *) articlesFromJSON: (NSData *)json {
    
    NSMutableArray <GADArticle *> *articles = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:json
                                                         options:kNilOptions
                                                           error:&error];
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    
    for (NSDictionary *element in jsonArray) {
        //Map fields of element to fields of article
        GADArticle *article = [[GADArticle alloc] init];
        //datePublished field is a UNIX Timestamp number - converting to NSDate here
        int timeStamp = (int)element[API_KEY_DATE_PUBLISHED];
        article.articleId = element[API_KEY_ARTICLE_ID];
        article.brief = element[API_KEY_BRIEF];
        article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
        article.headerImage = element[API_KEY_HEADER_IMAGE];
        article.publicationId = element[API_KEY_PUBLICATION_ID];
        article.title = element[API_KEY_TITLE];
        if (element[API_KEY_CONTENT]) {
            article.authors = element[API_KEY_AUTHORS];
            article.content = element[API_KEY_CONTENT];
        }
        [articles addObject:article];
    }
    return articles;
}

+ (NSURL *) baseQueryUrl {
    NSURL *queryURL = [NSURL URLWithString:API_HOSTNAME];
    queryURL = [NSURL URLWithString:API_PREFIX
                      relativeToURL:queryURL];
    return queryURL;
}

+ (NSURL *) urlForArticlesWithPublicationId: (NSString *)publicationId{
    NSURL *queryURL = [GADArticle baseQueryUrl];
    queryURL = [NSURL URLWithString:API_PUBLICATION_PATH
                      relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:publicationId
                      relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:API_SUFFIX
                      relativeToURL:queryURL];
    return queryURL;
}

- (NSURL *) urlForFulltextArticle {
    NSURL *queryURL = [GADArticle urlForArticlesWithPublicationId:self.publicationId];
    queryURL = [NSURL URLWithString:self.articleId
                      relativeToURL:queryURL];
    return queryURL;
}

- (void)updateWithArticle:(GADArticle *)newArticle {
    self.authors = newArticle.authors;
    self.brief = newArticle.brief;
    self.content = newArticle.content;
    self.datePublished = newArticle.datePublished;
    self.headerImage = newArticle.headerImage;
    self.title = newArticle.title;
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

