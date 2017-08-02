#import <SPARCore/SPARCore.h>

#import <XCTest/XCTest.h>

@interface SPARCArticleTests : XCTestCase

@end

@implementation SPARCArticleTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testArticleRequest {
  XCTestExpectation *expectation = [self expectationWithDescription:@"completed"];
  
  SPARCPublication *pub=[SPARCPublication new];
  pub.publicationId=@"8e031545-ba66-11e6-8193-a0999b05c023";
  
  [pub fetchArticlesWithNextPageToken:nil completion:^(NSArray<SPARCArticle *> *
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
  
  SPARCPublication *pub=[SPARCPublication new];
  pub.publicationId=@"8e031545-ba66-11e6-8193-a0999b05c023";
  
  [pub fetchArticlesWithNextPageToken:@"CTsT-hXNEeena95pI9PD9gAAAVsir91v"
                           completion:^(NSArray<SPARCArticle *> *
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
  
  SPARCArticle *article = [SPARCArticle new];
  article.articleId=@"01957fd2-15cd-11e7-a76b-de6923d3c3f6";
  article.publication=[SPARCPublication new];
  article.publication.publicationId=@"s-and-b";
  [article fetchFullTextWithCompletion:^(SPARCArticle * _Nullable article, NSError * _Nullable error) {
    XCTAssertNotNil(article,@"Fail to fetch full text!");
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}


@end
