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

    NSArray <GADArticle *> *articleArray;
    
    return articleArray;
    
}


@end
