//
//  GADArticle.m
//  Publications
//
//  Created by Alex French on 2/12/17.
//  Copyright © 2017 comp. All rights reserved.
//

#import "GADArticle.h"

@implementation GADArticle

//- (Array of GADArticle) populateArticles: (NSString* publicationId) { } //pid is going to be S&B

//-

- (GADArticle *) initWithDictionary: (NSDictionary*) dict {
    
    GADArticle *article = [[GADArticle alloc] init];
 
    article.publicationId = [dict valueForKey:@"publication"];
    article.authors = [dict valueForKey:@"authors"];
    //article.url = [dict valueForKey:@"publication"];
    //article.pictureSize = [dict valueForKey:@"publication"];
    //TODO: Finish property filling
    return article;
    
}

- (GADArticle *) updateArticleWithContent: (GADArticle*) articleStub {
    
    //DO the thing, add the stuff
    
    return articleStub;
}

+ (NSArray <GADArticle *> *) loadArticles {

    GADArticle *article = [[GADArticle alloc] init];
    article.publicationId = @"8e031545-ba66-11e6-8193-a0999b05c023";
    article.title = @"Testarticle";
    article.authors = [NSArray arrayWithObjects:@{@"name": @"Addi", @"email": @"addisemail.edu"}, nil];
    article.series = @"ada28c7d-a49f-11e6-b9d3-a0999b05c023";
    article.url = [NSURL URLWithString:@"http://www.thesandb.com/news/shacs-to-offer-funds-for-students-in-need.html"];
    article.tags = [NSArray arrayWithObjects:@"amazing!", @"fantastic!", @"Computer science!", nil];
    article.brief = @"This is very brief";
    article.content = @"This is much less brief because it should be longer than the brief";
    article.datePublished = [NSDate date];
    article.issue = @"ae2f3b54-a49f-11e6-b1ab-a0999b05c023";
    article.id = @"db7bc676-ba7d-11e6-8de8-a20f19d048b3";
    

    
    NSArray <GADArticle *> *articleArray;
    [articleArray arrayByAddingObject:article];
    
    return articleArray;
    
}


@end
