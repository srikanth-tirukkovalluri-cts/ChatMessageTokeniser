//
//  ATDeterminePageTitle.h
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/26/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDeterminePageTitle : NSObject

- (NSString *)getPageTitleFromURLPath:(NSString *)urlPath;

@end
