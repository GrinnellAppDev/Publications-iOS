#import <XCTest/XCTest.h>
#import "GADPublication.h"
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

/*
- (void)testJsonParser {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    GADArticle *expectedArticle = [[GADArticle alloc] init];
    expectedArticle.datePublished = [NSDate dateWithTimeIntervalSince1970:1486373851046];
    expectedArticle.brief = @"Did you ever hear the tragedy of Darth Plagueis \"the wise\"? I thought not. It's not a story the Jedi would tell you. It's a Sith legend.";
    expectedArticle.headerImage = @"https://i.ytimg.com/vi/05dT34hGRdg/maxresdefault.jpg";
    expectedArticle.publicationId = @"8e031545-ba66-11e6-8193-a0999b05c023";
    expectedArticle.articleId = @"049bd2c4-ec0d-11e6-a0f4-5e7d89de32e6";
    expectedArticle.title = @"Top 10 Tragedies the Jedi Won't Tell You!";
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"testArticles" ofType:@"json"];
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:path];
    NSLog(@"Debuggg: %@", path);
    NSArray <GADArticle *> *returnValues = [GADArticle articlesFromJSON:jsonData];

    XCTAssertEqualObjects(expectedArticle.datePublished, returnValues[0].datePublished);
    XCTAssertEqualObjects(expectedArticle.brief, returnValues[0].brief);
    XCTAssertEqualObjects(expectedArticle.headerImage, returnValues[0].headerImage);
    XCTAssertEqualObjects(expectedArticle.publicationId, returnValues[0].publicationId);
    XCTAssertEqualObjects(expectedArticle.articleId, returnValues[0].articleId);
    XCTAssertEqualObjects(expectedArticle.title, returnValues[0].title);
}
*/

- (void)testPublicationRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed"];
    
    [GADPublication fetchAllWithNextPageToken:nil
                                   Completion:^(NSArray<GADPublication *> *
                                                _Nullable publications,
                                                NSString * _Nullable token,
                                                NSError * _Nullable error) {
        XCTAssertNotNil(publications,@"Fail to fetch pubs!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testArticleRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed"];
    
    GADPublication *pub=[GADPublication new];
    pub.publicationId=@"8e031545-ba66-11e6-8193-a0999b05c023";
    
    [pub fetchArticlesWithNextPageToken:nil Completion:^(NSArray<GADArticle *> *
                                                         _Nullable articles,
                                                         NSString * _Nullable token,
                                                         NSError * _Nullable error) {
            XCTAssertNotNil(articles,@"Fail to fetch articles!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testArticleRequestWithToken {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed"];
    
    GADPublication *pub=[GADPublication new];
    pub.publicationId=@"8e031545-ba66-11e6-8193-a0999b05c023";
    
    [pub fetchArticlesWithNextPageToken:@"CTsT-hXNEeena95pI9PD9gAAAVsir91v"
                             Completion:^(NSArray<GADArticle *> *
                                          _Nullable articles, NSString *
                                          _Nullable token, NSError *
                                          _Nullable error) {
        XCTAssertNotNil(articles,@"Fail to fetch articles with token!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testFullTextRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"completed"];
    
    GADArticle *article = [GADArticle new];
    article.articleId=@"d3515d1a-ec0c-11e6-b33b-fa2f958eba33";
    article.publication=[GADPublication new];
    article.publication.publicationId=@"8e031545-ba66-11e6-8193-a0999b05c023";
    
    [article fetchFullTextWithCompletion:^(GADArticle * _Nullable article,
                                           NSError * _Nullable error) {
        XCTAssertNotNil(article,@"Fail to fetch full text!");
        NSLog(@"CONTENT!!!!!!!!!!%@",article.content);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
