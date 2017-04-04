#import "GADArticle.h"

@implementation GADArticle

+ (void) articlesFromPublication: (NSString *)publicationId
                                        completionHandler:(void(^_Nonnull)(NSArray<GADArticle *>
                                                                           *_Nullable articles,
                                                            NSError *_Nullable error))completion {
    //Should we create NSDictionary parameters within each method and just request the publicationId
    //from the front end?

}

- (void) populateArticleWithId: (NSString *)articleId
                                        completionHandler:(void(^_Nonnull)(GADRemoteModel *
                                                                           *_Nullable models,
                                                            NSError *_Nullable error))completion {
    //Similarly, should we create NSDictionary parameters within each method and just request the
    //articleId from the front end?
    
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
        GADArticle *article = [[GADArticle alloc] init];
        //Map fields of element to fields of article
        article.datePublished = element[@"datePublished"];
        article.brief = element[@"brief"];
        article.headerImage = element[@"headerImage"];
        article.publicationId = element[@"publication"];
        article.articleId = element[@"id"];
        article.title = element[@"title"];
        [articles addObject:article];
    }
    return articles;
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
        //article.datePublished = [NSDate date];
        article.issue = @"ae2f3b54-a49f-11e6-b1ab-a0999b05c023";
        article.articleId = @"db7bc676-ba7d-11e6-8de8-a20f19d048b3";
    
        [articleArray addObject:article];
    }
    return articleArray;
}

@end

