//
//  ATChatViewModel.h
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/27/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATChatMessage.h"

@protocol ATChatViewModelDelegate <NSObject>

- (void)refreshJSONOutput;

@end

/// This is a View Model, which manages ATChatMessage model object, and provides options to manage the view related activities.
@interface ATChatViewModel : NSObject

@property (nonatomic, strong) ATChatMessage *chatMessage;
@property (nonatomic, assign) id <ATChatViewModelDelegate> chatViewModelDelegate;

/// Designated initialiser
- (id)initWithModel:(ATChatMessage *)chatMessageModel;

/// Calculates and returns the size a perticular text considering the font and the width its given to render.
- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

/// Asynchronously loads the page titles of URLs found in the chat message, and notifies the delegate each time a perticular URL is loaded and the title is determined.
- (void)lazilyDeterminePageTitles;

@end
