//
//  JSQMultiPhotoMediaItem.h
//  JSQMessages
//
//  Created by Sid McLaughlin on 2016-07-04.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMediaItem.h"

@interface JSQMultiPhotoMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

/**
 *  The preview image for the multi photo media item. The default value is `nil`.
 */
@property (copy, nonatomic) NSArray *images;

- (instancetype)initWithImages:(NSArray *)images;

@end