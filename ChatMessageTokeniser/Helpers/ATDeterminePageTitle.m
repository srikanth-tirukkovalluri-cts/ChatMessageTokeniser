//
//  ATDeterminePageTitle.m
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/26/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import "ATDeterminePageTitle.h"
#import "TFHpple.h"

@implementation ATDeterminePageTitle

- (NSString *)getPageTitleFromURLPath:(NSString *)urlPath {
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPath]];
    
    // 2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
    // 3
    NSString *documentTitleXpathQueryString = @"//title[1]";
    TFHppleElement *titleNode = [htmlParser peekAtSearchWithXPathQuery:documentTitleXpathQueryString];
    
    NSLog(@"titleNode %@", titleNode.text);
    
    return titleNode.text;
}

@end
