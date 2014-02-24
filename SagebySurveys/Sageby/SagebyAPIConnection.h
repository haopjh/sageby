//
//  SagebyAPIConnection.h
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SagebyAPIConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
    NSHTTPURLResponse *httpResponse;
}

- (id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, id statusCode, NSError *err);
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

- (void) start;

@end
