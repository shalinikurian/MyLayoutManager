//
//  MyTextStorage.m
//  ChatStrings
//
//  Created by Shalini Kurian on 11/5/15.
//  Copyright © 2015 twitch. All rights reserved.
//

#import "MyTextStorage.h"
@interface MyTextStorage ()
@property (nonatomic, strong) NSMutableDictionary *attributes;
@end

@implementation MyTextStorage
{
	NSMutableAttributedString *_backingStore;
	NSMutableDictionary *_attributes;
}
- (id)init {
	if (self = [super init]) {
		_backingStore = [[NSMutableAttributedString alloc] initWithString: @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."];
		
		
		NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
		[style setLineSpacing:12.f];
		
		self.attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.f]}];
	}
	return self;
}

- (NSString *)string
{
	return [_backingStore string];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
	NSLog(@"replacing ---> %@", str);
	[self beginEditing];
	[_backingStore replaceCharactersInRange:range withString:str];
	[self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
	[self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
	NSLog(@"set attributes ----> %@", attrs);
	[self beginEditing];
	[_backingStore setAttributes:attrs range:range];
	[self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
	[self endEditing];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
	return [_backingStore attributesAtIndex:location effectiveRange:range];
}

@end


