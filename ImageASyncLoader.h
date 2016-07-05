//
//  ImageASyncLoader.h
//  SocialSpace
//
//  Created by Bharti Sharma on 14/09/1935 SAKA.
//  Copyright (c) 1935 SAKA Bharti Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AsyncImageDelegate;


@interface ImageASyncLoader : UIImageView <NSURLConnectionDataDelegate>
{
    NSMutableData *appendData;
    
    UIActivityIndicatorView *spinner;
}

@property BOOL downloading;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id<AsyncImageDelegate> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (void) downloadFromUrl: (NSURL *) url;
- (void) cancelDownload;


@end

@protocol AsyncImageDelegate <NSObject>

- (void) imageLoaded: (ImageASyncLoader *) sender;

@optional

- (void) imageFailed: (ImageASyncLoader *) sender;

@end
