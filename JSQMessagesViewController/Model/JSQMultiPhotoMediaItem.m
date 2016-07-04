//
//  JSQMultiPhotoMediaItem.m
//  JSQMessages
//
//  Created by Sid McLaughlin on 2016-07-04.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMultiPhotoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"


@interface JSQMultiPhotoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedImageView;

@end


@implementation JSQMultiPhotoMediaItem

#pragma mark - Initialization

- (instancetype)initWithImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        _images = [images copy];
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

- (void)setImages:(NSArray *)images
{
    _images = [_images copy];
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
    if (self.images == nil || [self.images count] == 0) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.images objectAtIndex:0]];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        if ([self.images count] > 1) {
            UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - 25, size.width, 25)];
            [labelView setBackgroundColor:[UIColor whiteColor]];
            [labelView setAlpha:0.8];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 25)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor orangeColor]];
            [label setText:[NSString stringWithFormat:@"+ %ld more...", [self.images count] - 1]];
            [labelView addSubview:label];
            
            [imageView addSubview:labelView];
        }
        
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
    return super.hash ^ self.images.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.images, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _images = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(images))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.images forKey:NSStringFromSelector(@selector(images))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQMultiPhotoMediaItem *copy = [[JSQMultiPhotoMediaItem allocWithZone:zone] initWithImages:self.images];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end