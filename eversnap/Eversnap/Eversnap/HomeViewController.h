//
//  HomeViewController.h
//  Eversnap
//
//  Created by Thiago Rahal on 10/21/16.
//  Copyright © 2016 Thiago Rahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gallery.h"

@interface HomeViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property Gallery *gallery;
@property NSMutableDictionary *cache;           // Dictionary that will be used as our cache memory
@end

