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
        NSLog(@"AUTHOR!!!!!!!!!%@",article.authors);
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
