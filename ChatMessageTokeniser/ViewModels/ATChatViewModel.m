//
//  ATChatViewModel.m
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/27/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import "ATChatViewModel.h"
#import "ATDeterminePageTitle.h"

@interface ATChatViewModel ()

@end

@implementation ATChatViewModel

- (id)initWithModel:(ATChatMessage *)chatMessageModel {
    self = [super init];
    
    if (self) {
        self.chatMessage = chatMessageModel;
    }
    
    return self;
}

- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return size;
}

- (void)lazilyDeterminePageTitles {
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    NSArray *links = self.chatMessage.outputDictionary[@"links"];
    
    for (NSMutableDictionary *linkDetails in links) {
        NSString *urlPath = [linkDetails objectForKey:@"url"];
        NSLog(@"urlPath %@", urlPath);
        
        NSBlockOperation *operation = [[NSBlockOperation alloc] init];
        [operation addExecutionBlock:^{
            ATDeterminePageTitle *determinePageTitle = [ATDeterminePageTitle new];
            NSString *pageTitle = [determinePageTitle getPageTitleFromURLPath:urlPath];
            pageTitle = pageTitle ? pageTitle : @"N/A";
            
            [linkDetails setValue:pageTitle forKey:@"title"];
            NSLog(@"links %@", links);
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Main thread work (UI usually)
                if ([self.chatViewModelDelegate respondsToSelector:@selector(refreshJSONOutput)]) {
                    [self.chatViewModelDelegate refreshJSONOutput];
                }                
            }];
        }];
        
        [operationQueue addOperation:operation];
    }
}

@end
