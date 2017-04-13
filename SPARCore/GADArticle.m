#import "GADArticle.h"
#import "GADRemoteModel.h"

@implementation GADArticle

static NSString *const API_ARTICLE_ID = @"id";
static NSString *const API_AUTHORS = @"authors";
static NSString *const API_BRIEF = @"brief";
static NSString *const API_CONTENT = @"content";
static NSString *const API_DATE_PUBLISHED = @"datePublished";
static NSString *const API_HEADER_IMAGE = @"headerImage";
static NSString *const API_PUBLICATION_ID = @"publication";
static NSString *const API_TITLE = @"title";

static NSString *const API_HOSTNAME = @"https://g2j7qs2xs7.execute-api.us-west-2.amazonaws.com/";
static NSString *const API_PREFIX = @"devstable";
static NSString *const API_PUBLICATION_PATH = @"publications";
static NSString *const API_ARTICLE_PATH = @"articles";

+ (void) articlesFromPublication: (NSString *)publicationId
                                        completionHandler:(void(^_Nonnull)(NSArray<GADArticle *>
                                                                           *_Nullable articles,
                                                            NSError *_Nullable error))completion {
    NSURL *queryURL = [GADArticle createURLWithPublication:publicationId];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData) {
                            return [GADArticle articlesFromJSON:jsonData];
                         }
                        completionHandler:completion];

}

- (void) populateArticleWithId: (void(^_Nonnull)(GADRemoteModel * *_Nullable model,
                                                NSError *_Nullable error))completion {
    NSURL *queryURL = [GADArticle createURLWithArticle:self.articleId publication:self.publicationId];
    
    [GADRemoteModel fetchModelsWithParams:queryURL
                          queryParameters:@{}
                         modelTransformer:^(NSData *jsonData){
                             return [GADArticle articlesFromJSON:jsonData];
                         }
                        completionHandler:^(NSArray <GADArticle *> *_Nullable model, NSError *_Nullable error){
                            GADArticle *fullArticle = model[0];
                            self.content = fullArticle.content;
                            self.authors = fullArticle.authors;
                            //completion(); --How should we call the completion handler here?
                        }];
    
}

+ (NSArray <GADArticle *> *) articlesFromJSON: (NSData *)json {
    
    NSMutableArray <GADArticle *> *articles = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:json
                                                         options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    
    for (NSDictionary *element in jsonArray) {
        //Map fields of element to fields of article
        GADArticle *article = [[GADArticle alloc] init];
        //datePublished field is a UNIX Timestamp number - converting to NSDate here
        int timeStamp = (int)element[API_DATE_PUBLISHED];
        article.datePublished = [NSDate dateWithTimeIntervalSince1970: timeStamp];
        article.brief = element[API_BRIEF];
        article.headerImage = element[API_HEADER_IMAGE];
        article.publicationId = element[API_PUBLICATION_ID];
        article.articleId = element[API_ARTICLE_ID];
        article.title = element[API_TITLE];
        if (element[API_CONTENT]) {
            article.content = element[API_CONTENT];
            article.authors = element[API_AUTHORS];
        }
        [articles addObject:article];
    }
    return articles;
}

+ (NSURL *) createBaseURL {
    NSURL *queryURL = [NSURL URLWithString:API_HOSTNAME];
    queryURL = [NSURL URLWithString:API_PREFIX relativeToURL:queryURL];
    return queryURL;
}

+ (NSURL *) createURLWithPublication: (NSString *)publicationId{
    NSURL *queryURL = [GADArticle createBaseURL];
    queryURL = [NSURL URLWithString:API_PUBLICATION_PATH relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:publicationId relativeToURL:queryURL];
    queryURL = [NSURL URLWithString:API_ARTICLE_PATH relativeToURL:queryURL];
    return queryURL;
}

+ (NSURL *) createURLWithArticle: (NSString *)articleId publication:(NSString *)publicationId{
    NSURL *queryURL = [GADArticle createURLWithPublication:publicationId];
    queryURL = [NSURL URLWithString:articleId relativeToURL:queryURL];
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

