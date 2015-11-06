//
//  ViewController.m
//  ChatStrings
//
//  Created by Shalini Kurian on 10/30/15.
//  Copyright © 2015 twitch. All rights reserved.
//

#import "ViewController.h"
#import "MyLayoutManager.h"
#import "MyTextAttachment.h"
@interface ViewController ()

@end

@implementation ViewController
{
	UITextView *_textView;
	NSTextStorage *_textStorage;
	MyLayoutManager *_layoutManager;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	[style setMinimumLineHeight:20.f];
	[style setMaximumLineHeight:20.f];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
					NSParagraphStyleAttributeName:style,
					NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.f]
					};
	
	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."];
	
	NSMutableAttributedString *urlString = [[NSMutableAttributedString alloc] initWithString:@"pokemon.com"];
	[urlString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://google.com"] range:NSMakeRange(0, urlString.length)];
	[attrStr appendAttributedString:urlString];
	
	_textStorage = [[NSTextStorage alloc] initWithAttributedString:attrStr];
	[_textStorage addAttributes:attributes range:NSMakeRange(0, attrStr.length)];

	_layoutManager = [[MyLayoutManager alloc] init];

	NSTextContainer *container= [[NSTextContainer alloc] initWithSize:CGSizeMake(self.view.frame.size.width - 50.f, CGFLOAT_MAX)];
	
	//NSTextContainer has default line fragment Padding = 5.f
	[container setLineFragmentPadding:0.f];

	[_textStorage addLayoutManager:_layoutManager];
	[_layoutManager addTextContainer:container];

	if (!_textView)
	{
		/*
		 * NSLayoutManager performs layout lazily. Force layout of the text for height calculation/
		 */
		
		[_layoutManager ensureLayoutForTextContainer:container];
		CGRect rect = CGRectIntegral([_layoutManager usedRectForTextContainer:container]);
		
		/*
		 * textContainerInset has a default Value of (8,0,8,0)
		 * Account for the bottom and top textcontainerinset for height calculation
		 */
		
		_textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:container];
		_textView.frame = CGRectMake(25, 50, rect.size.width, rect.size.height + _textView.textContainerInset.bottom + _textView.textContainerInset.top);
		_textView.backgroundColor = [UIColor grayColor];
		_textView.textColor = [UIColor whiteColor];
		
		/*
		 * selectable = YES for tappiong links
		 */
		_textView.selectable = YES;
		_textView.scrollEnabled = NO;
		_textView.editable = NO;
		_textView.dataDetectorTypes = UIDataDetectorTypeLink;
		
		[self.view addSubview:_textView];
	}
	
	_layoutManager.emoteIndices = @[@(5),@(60), @(30)];
	NSDictionary *emoteIdxToUrl = @{@(30):@"http://static-cdn.jtvnw.net/emoticons/v1/1900/1.0",
									@(5) : @"http://static-cdn.jtvnw.net/emoticons/v1/28/1.0",
									@(60): @"http://static-cdn.jtvnw.net/emoticons/v1/30259/1.0"};
	__weak ViewController *weakSelf = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		[emoteIdxToUrl enumerateKeysAndObjectsUsingBlock:^(NSNumber *idx, NSString *urlString, BOOL * _Nonnull stop) {
			NSURL *url = [NSURL URLWithString:urlString];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *image = [UIImage imageWithData:data];
			dispatch_async(dispatch_get_main_queue(), ^{
				ViewController *blockSelf = weakSelf;
				[blockSelf downloadedImage:image atIdx:[idx integerValue]];
			});
		}];

	});
}

- (void)downloadedImage:(UIImage *)image atIdx:(NSUInteger)index
{
	MyTextAttachment *imgAttachment = [[MyTextAttachment alloc] init];
	imgAttachment.image = image;
	imgAttachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	NSAttributedString *imgAttribute = [NSAttributedString attributedStringWithAttachment:imgAttachment];

	[_textStorage beginEditing];
	[_textStorage replaceCharactersInRange:NSMakeRange(index, 1) withAttributedString:imgAttribute];
	[_textStorage endEditing];
}

@end
