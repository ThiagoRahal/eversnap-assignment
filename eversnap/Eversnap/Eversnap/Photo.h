//
//  Photo.h
//  Eversnap
//
//  Created by Thiago Rahal on 10/21/16.
//  Copyright © 2016 Thiago Rahal. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface Photo: NSObject

@property (strong, nonatomic) NSString* photo_id;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* server;
@property (strong, nonatomic) NSString* farm;
@property (strong, nonatomic) NSString* secret;
@property (strong, nonatomic) NSURL* imageUrl;


@end
