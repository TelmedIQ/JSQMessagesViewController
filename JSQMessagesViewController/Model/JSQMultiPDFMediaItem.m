//
//  JSQMultiPDFMediaItem.m
//  JSQMessages
//
//  Created by Sid McLaughlin on 2016-07-04.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMultiPDFMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

@interface JSQMultiPDFMediaItem ()

@property (strong, nonatomic) UIImageView *cachedImageView;

@end

@implementation JSQMultiPDFMediaItem

#pragma mark - Initialization

- (instancetype)initWithPdfs:(NSArray *)pdfs
{
    self = [super init];
    if (self) {
        _pdfs = [pdfs copy];
        _cachedImageView = nil;
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}

#pragma mark - Setters

- (void)setPdfs:(NSArray *)pdfs
{
    _pdfs = [pdfs copy];
    _cachedImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.pdfs == nil || [self.pdfs count] == 0) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [view setBackgroundColor:[UIColor redColor]];
        
        [imageView addSubview:view];
        
        self.cachedImageView = imageView;
    }
    
    return self.cachedImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.pdfs.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: pdfs=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.pdfs, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _pdfs = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(pdfs))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.pdfs forKey:NSStringFromSelector(@selector(pdfs))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQMultiPDFMediaItem *copy = [[JSQMultiPDFMediaItem allocWithZone:zone] initWithPdfs:self.pdfs];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
    
}

@end
