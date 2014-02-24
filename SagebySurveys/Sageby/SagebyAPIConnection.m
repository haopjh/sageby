//
//  SagebyAPIConnection.m
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SagebyAPIConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation SagebyAPIConnection
@synthesize request, completionBlock, jsonRootObject;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if(self) {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    container = [[NSMutableData alloc] init];
    
    httpResponse = [[NSHTTPURLResponse alloc] init];
    
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
    NSString *jsonCheck = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonCheck = %@", jsonCheck);// if the http connection is made successfully, u should be again to see jsonCheck= sth sth in the console
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject = nil;
    
    if ([self jsonRootObject]){
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:container options:0 error:nil];
        
        [[self jsonRootObject] readFromJSONDictionary:d];
        
        rootObject = [self jsonRootObject];
    }
    
    if([self completionBlock])
        [self completionBlock](rootObject, httpResponse, nil);
    
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //Pass the error from the connection to the completionBlock
    if([self completionBlock])
        [self completionBlock](nil, nil, error);
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    httpResponse = (NSHTTPURLResponse*)response;
}

@end
