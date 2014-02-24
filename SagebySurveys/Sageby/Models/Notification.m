//
//  Notification.m
//  Sageby
//
//  Created by LuoJia on 23/10/12.
//
//

#import "Notification.h"

@implementation Notification

@synthesize title;
@synthesize body;
@synthesize date;
@synthesize resultBodyString;

- (id)init
{
    if([super init]) {
        resultBodyString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setTitle:[d objectForKey:@"title"]];
//    [self setBody:[self convertEntiesInString:[d objectForKey:@"body"]]];
    [self setBody:[d objectForKey:@"body"]];
    
    NSString *dateString = [d objectForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self setDate:[dateFormatter dateFromString:dateString]];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
    [self.resultBodyString appendString:s];
}

- (NSString*)convertEntiesInString:(NSString*)s
{
    if(s == nil) {
        NSLog(@"ERROR : Parameter string is nil");
    }
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
    NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    return [NSString stringWithFormat:@"%@",resultBodyString];
}

@end
