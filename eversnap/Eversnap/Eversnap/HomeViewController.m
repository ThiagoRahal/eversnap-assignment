//
//  HomeViewController.m
//  Eversnap
//
//  Created by Thiago Rahal on 10/21/16.
//  Copyright © 2016 Thiago Rahal. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking.h>
#import "Photo.h"
#import "Gallery.h"
#import "DetailViewController.h"


@interface HomeViewController ()

@property UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Birthday Gallery";
    
    _cache = [[NSMutableDictionary alloc] init];
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier:@"thumbnail"];
    [self.collectionView addSubview:_refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)pullToRefresh {
    [self getPhotosFromFlickr];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
    if (numberOfCells == 0) {           // In case there is no photo, get photos from Flickr
        [self getPhotosFromFlickr];
    }
}

- (void)getPhotosFromFlickr {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://api.flickr.com/services/rest/"];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"flickr.photos.search", @"method", @"birthday", @"tags",@"2c03432a962bfe4eb2d7ad4f606751ad", @"api_key", @"json", @"format", @"1", @"nojsoncallback", nil]; // Dictionary that will be passed as our GET request
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL.absoluteString parameters: dict error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *dict = (NSDictionary *) responseObject;
            NSArray *photos = dict[@"photos"][@"photo"];
            NSLog(@"%@", dict);
            _gallery = [[Gallery alloc] init];
            int i = 0;
            for (i = 0; i < photos.count; i++) {
                Photo *photo = [[Photo alloc] init];
                photo.farm = photos[i][@"farm"];
                photo.server = photos[i][@"server"];
                photo.title = photos[i][@"title"];
                photo.secret = photos[i][@"secret"];
                photo.photo_id = photos[i][@"id"];
                NSString *stringImage = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", photo.farm, photo.server, photo.photo_id, photo.secret];
                NSURL *url = [NSURL URLWithString:stringImage]; // Build URL according to Flickr API
                photo.imageUrl = url;
                [_gallery.photos addObject:photo];
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
                [_refreshControl endRefreshing];
            }];
        }
    }];
    [dataTask resume];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width/2-1, collectionView.bounds.size.height/5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gallery.photos.count;
}

- (void) getImage:(NSURL *) url forImageView: (UIImageView *) imageView {
    
    UIImage *image = _cache[url.absoluteString];
    if (!image) {           // Check to see if the image already exists in our Cache
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // Create a background thread to download images
            NSData *data = [NSData dataWithContentsOfURL: url];
            dispatch_sync(dispatch_get_main_queue(), ^{     // Right after the download, the image is set and added to our cache
                imageView.image = [[UIImage alloc] initWithData:data];
                [_cache setValue:imageView.image forKey:url.absoluteString];
            });
        });
    } else {
        imageView.image = image;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumbnail" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self getImage:[self.gallery.photos[indexPath.row] imageUrl] forImageView:imageView];
    
    for (UIView *v in [cell subviews]) {   // Cleaning cell subviews before adding an image
        [v removeFromSuperview];
    }
    
    [cell addSubview:imageView];
    return cell;
}

// If a thumbnail is selected, a new view controller is instantiated and presented
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *controller = [[DetailViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    controller.gallery = self.gallery;
    controller.cache = self.cache;
    controller.currentPhotoIndex = indexPath.row;
    controller.indexPath = indexPath;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Gallery" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    [self.navigationController pushViewController:controller animated:true];
}

@end