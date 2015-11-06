//
//  MyLayoutManager.m
//  ChatStrings
//
//  Created by Shalini Kurian on 11/5/15.
//  Copyright © 2015 twitch. All rights reserved.
//

#import "MyLayoutManager.h"

@implementation MyLayoutManager
- (CGPoint)locationForGlyphAtIndex:(NSUInteger)glyphIndex
{
	CGPoint location = [super locationForGlyphAtIndex:glyphIndex];
	NSUInteger charIdx = [self characterIndexForGlyphAtIndex:glyphIndex];
	if ([_emoteIndices containsObject:@(charIdx)])
	{
		CGRect rect = [self lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:nil];
		CGFloat glyphHeight = 27;
		location = CGPointMake(location.x, rect.size.height + floorf(fabs(glyphHeight - rect.size.height)/2));
	}
	return location;
}

@end
