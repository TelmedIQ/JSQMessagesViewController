//
//  JSQMultiPDFMediaItem.h
//  JSQMessages
//
//  Created by Sid McLaughlin on 2016-07-04.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMediaItem.h"

@interface JSQMultiPDFMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

@property (copy, nonatomic) NSArray *pdfs;

- (instancetype)initWithPdfs:(NSArray *)pdfs;

@end
