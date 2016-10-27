//
//  ATChatMessage.h
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/27/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import <Foundation/Foundation.h>

/// This is a model class that holds chat message and identifies the special content in it.
@interface ATChatMessage : NSObject

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSMutableArray *mentions;
@property (nonatomic, strong, readonly) NSMutableArray *emoticons;
@property (nonatomic, strong, readonly) NSMutableArray *links;

/// This property represents the tokenised special content found in the chat message
@property (nonatomic, strong, readonly) NSMutableDictionary *outputDictionary;

- (id)initWithMessage:(NSString *)message;

/// This method formats the outputDictionary(tokenised special content) as a JSON String in a better readable format.
- (NSString *)prettyPrintedJSONString;

@end
