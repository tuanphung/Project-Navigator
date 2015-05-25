//
//  AFHTTPRequestOperationManager+Extend.h
//  upaty
//
//  Created by Tuan Phung on 11/30/14.
//  Copyright (c) 2014 Tuan Phung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/* Add PUT method with Multipart/form-data */

@interface AFHTTPRequestOperationManager(Extend)

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                     parameters:(id)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
