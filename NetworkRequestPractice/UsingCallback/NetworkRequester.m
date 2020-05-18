//
//  NetworkRequester.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-29.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "NetworkRequester.h"
static NSString *authorizationToken = @"token 765e30ead6006953d850250d0afc2a7ff8577704";

@implementation NetworkRequester

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)makeNetworkRequest:(NSURL *)url urlSession:(id<URLSessionProtocol>)urlSession completionHandler:(void (^)(NSDictionary *))completionHandler {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
    [[urlSession dataTaskWithRequest:urlRequest
                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          if (error) {
              return completionHandler(nil);
          }
          
          NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          if ([array isKindOfClass:[NSDictionary class]]) {
              self.dict = (NSDictionary *)array;
          } else if ([array isKindOfClass:[NSArray class]]){
              self.dict = [array objectAtIndex:0];
          }
          completionHandler(self.dict);
      }] resume];
}


@end
