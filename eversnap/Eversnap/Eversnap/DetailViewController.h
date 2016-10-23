//
//  DetailViewController.h
//  Eversnap
//
//  Created by Thiago Rahal on 10/22/16.
//  Copyright © 2016 Thiago Rahal. All rights reserved.
//
#import "Photo.h"
#import "Gallery.h"

@interface DetailViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property NSInteger currentPhotoIndex;
@property Gallery *gallery;
@property NSMutableDictionary *cache;
@property NSIndexPath *indexPath;

@end
