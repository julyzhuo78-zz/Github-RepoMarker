//
//  NetworkRequesterTest.m
//  NetworkRequestPracticeTests
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkRequester.h"
#import "GitURLSessionMock.h"

@interface NetworkRequesterTest : XCTestCase
@property (atomic, strong) GitURLSessionMock *gitURLSession;
@property (atomic, strong) NetworkRequester *sut;
@property (atomic, strong) NSURL *url;
@property (atomic, strong) NSString *authorizationToken;

@end

@implementation NetworkRequesterTest

- (void)setUp {
    if (self) {
        self.gitURLSession = [[GitURLSessionMock alloc] init];
        self.sut = [[NetworkRequester alloc] init];
        self.url = [NSURL URLWithString:@"https://api.github.com/users/julyzhuo/repos"];
        self.authorizationToken = @"token aa3b2093a7186436663a661f507d49d7bb5d1812";
        }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMakeNetworkRequestDidSucceed {
    [self.sut makeNetworkRequest:self.url urlSession:self.gitURLSession completionHandler:^(NSDictionary * _Nonnull dict) {
        XCTAssertEqual(self.url, self.gitURLSession.urlRequest.URL);
        XCTAssertEqual([self.gitURLSession.urlRequest.allHTTPHeaderFields valueForKey:@"Authorization"], self.authorizationToken);
        XCTAssertEqual([dict valueForKey:@"commits_url"], @"https://api.github.com/repos/julyzhuo/dev/commits{/sha}");
        XCTAssertEqual([dict valueForKey:@"full_name"], @"julyzhuo/dev");
    }];
}

@end
