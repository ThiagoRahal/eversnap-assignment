//
//  DetailViewController.m
//  Eversnap
//
//  Created by Thiago Rahal on 10/22/16.
//  Copyright © 2016 Thiago Rahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photos Detail";
    
    [self.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier:@"detail"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated { // Make collection view scroll to the selected Photo
    [super viewWillAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/1.2, collectionView.frame.size.height/1.2);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gallery.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detail" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    cell.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self getImage:[self.gallery.photos[indexPath.row] imageUrl] forImageView:imageView];
    
    for (UIView *v in [cell subviews]) {
        [v removeFromSuperview];
    }
    
    [cell addSubview:imageView];
    return cell;
}

// Same method from our HomeViewController
- (void) getImage:(NSURL *) url forImageView: (UIImageView *) imageView {
    
    UIImage *image = _cache[url.absoluteString];
    if (!image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL: url];
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = [[UIImage alloc] initWithData:data];
                [_cache setValue:imageView.image forKey:url.absoluteString];
            });
        });
    } else {
        imageView.image = image;
    }
}

@end