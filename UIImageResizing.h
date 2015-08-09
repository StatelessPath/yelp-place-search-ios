//
//  UIImageResizing.h
//  Inbtwn
//
//  Created by Corey Schaf on 5/28/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Resize)
- (UIImage*)scaleToSize:(CGSize)size;
@end