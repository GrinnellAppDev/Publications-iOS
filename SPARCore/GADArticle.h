//
//  GADArticle.h
//  Publications
//
//  Created by Alex French on 2/12/17.
//  Copyright © 2017 comp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADArticle : NSObject

@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSArray *authors;
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
@property (nonatomic, strong) NSString *id;

@end
