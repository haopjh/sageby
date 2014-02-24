//
//  Notification.h
//  Sageby
//
//  Created by LuoJia on 23/10/12.
//
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface Notification : NSObject <JSONSerializable, NSXMLParserDelegate>
{
    NSMutableString *resultBodyString;
}

@property (nonatomic, retain) NSMutableString* resultBodyString;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *date;

- (NSString*)convertEntiesInString:(NSString*)s;

@end
