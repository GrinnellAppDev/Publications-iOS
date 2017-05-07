#import <SPARCore/SPARCore.h>

#import <XCTest/XCTest.h>

@interface SPARPublicationTests : XCTestCase

@end

@implementation SPARPublicationTests

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
    
    [SPARCPublication fetchAllWithNextPageToken:nil
                                   completion:^(NSArray<SPARCPublication *> *
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
@end
