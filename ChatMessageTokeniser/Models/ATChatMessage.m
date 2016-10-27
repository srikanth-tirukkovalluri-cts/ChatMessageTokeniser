//
//  ATChatMessage.m
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/27/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import "ATChatMessage.h"

@interface ATChatMessage ()

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSMutableArray *mentions;
@property (nonatomic, strong) NSMutableArray *emoticons;
@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, strong) NSMutableDictionary *outputDictionary;

@end

@implementation ATChatMessage

- (id)initWithMessage:(NSString *)message {
    self = [super init];
    
    if (self) {
        self.message = message;
        
        // A regular expression which identifies mentions, emoticons and links in a string
        // Example: Mentions -> @chris @srikanth | Emoticons -> (success) (failure) | Links -> http://www.google.com https://www.atlassian.com
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(@[a-z,0-9]+|\\([a-z]+\\)|http://[^\\s]*|https://[^\\s]*)" options:NSRegularExpressionCaseInsensitive error:NULL];
        NSArray *matches = [regex matchesInString:message options:0 range:NSMakeRange(0, [message length])] ;
        
        self.mentions = [NSMutableArray array];
        self.emoticons = [NSMutableArray array];
        self.links = [NSMutableArray array];
        
        // Iterate over the matched results and identify the matched string either as a Mention or Emoticon or as a Link
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match rangeAtIndex:1];
            NSString *matchedString = [message substringWithRange:matchRange];
            
            // If the matched string has @ as a prefix, then its a Mention
            if ([matchedString hasPrefix:@"@"]) {
                matchedString = [matchedString substringFromIndex:1];
                [self.mentions addObject:matchedString];
            }
            
            // If the matched string has ( as a prefix, then its a Emoticon
            if ([matchedString hasPrefix:@"("]) {
                matchedString = [matchedString substringWithRange:NSMakeRange(1, matchedString.length - 2)];
                [self.emoticons addObject:matchedString];
            }
            
            // If the matched string has http as a prefix, then its a Link
            if ([matchedString hasPrefix:@"http"]) {
                [self.links addObject:[@{@"url": matchedString, @"title": @"Loading..."} mutableCopy]];
            }
        }
        
        // Initialize the outputDictionary and build it with the found Mentions, Emoticons and Links
        self.outputDictionary = [NSMutableDictionary dictionary];
        
        if (self.mentions.count > 0) {
            [self.outputDictionary setObject:self.mentions forKey:@"mentions"];
        }
        
        if (self.emoticons.count > 0) {
            [self.outputDictionary setObject:self.emoticons forKey:@"emoticons"];
        }
        
        if (self.links.count > 0) {
            [self.outputDictionary setObject:self.links forKey:@"links"];
        }
    }
    
    return self;
}

- (NSString *)prettyPrintedJSONString {
    NSError *error;
    NSString *jsonString = nil;
    NSDictionary *outputDictionary = self.outputDictionary;
    
    @synchronized (self) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:outputDictionary
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (!jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        }
    }
    
    return jsonString;
}


@end
