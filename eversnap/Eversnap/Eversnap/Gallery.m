//
//  Gallery.m
//  Eversnap
//
//  Created by Thiago Rahal on 10/22/16.
//  Copyright © 2016 Thiago Rahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gallery.h"

@interface Gallery()

@end

@implementation Gallery

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

@end