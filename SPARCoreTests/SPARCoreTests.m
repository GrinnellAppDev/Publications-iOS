//
//  SPARCoreTests.m
//  SPARCoreTests
//
//  Created by Alex Mitchell on 2/11/17.
//  Copyright © 2017 comp. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GADArticle.h"

@interface SPARCoreTests : XCTestCase

@end

@implementation SPARCoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJsonParser {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    GADArticle *expectedArticle = [[GADArticle alloc] init];
    expectedArticle.datePublished = @"2017-02-06 01:38:53.743015";
    expectedArticle.brief = @"Did you ever hear the tragedy of Darth Plagueis \"the wise\"? I thought not. It's not a story the Jedi would tell you. It's a Sith legend.";
    expectedArticle.headerImage = @"https://i.ytimg.com/vi/05dT34hGRdg/maxresdefault.jpg";
    expectedArticle.publicationId = @"8e031545-ba66-11e6-8193-a0999b05c023";
    expectedArticle.articleId = @"049bd2c4-ec0d-11e6-a0f4-5e7d89de32e6";
    expectedArticle.title = @"Top 10 Tragedies the Jedi Won't Tell You!";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testArticles" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSArray <GADArticle *> *returnValues = [GADArticle articlesFromJSON:jsonData];
    XCTAssertEqualObjects(expectedArticle, returnValues[0]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
