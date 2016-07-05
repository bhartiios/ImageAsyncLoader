//
//  ImageASyncLoader.m
//  SocialSpace
//
//  Created by Bharti Sharma on 14/09/1935 SAKA.
//  Copyright (c) 1935 SAKA Bharti Sharma. All rights reserved.
//

#import "ImageASyncLoader.h"

@implementation ImageASyncLoader


@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) downloadFromUrl: (NSURL *) url;
{
    if (_downloading)
        return;
    
    self.contentMode = UIViewContentModeScaleToFill;
    
    self.url = url;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.frame = self.bounds;

    [self addSubview:spinner];
    
    _downloading = YES;
    
    self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    
    [self.connection start];
    
    [spinner startAnimating];
    
    if (!appendData)
        appendData = [[NSMutableData alloc] init];
}


- (void) cancelDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.connection cancel];
        
        self.connection = nil;
        //self.url = nil;
        _downloading = NO;
        
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    });
}


#pragma mark - NSURLConnection Delegate


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [appendData appendData:data];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    @synchronized (self) {
         [spinner stopAnimating];
        [spinner removeFromSuperview];
        //spinner = nil;
        self.image = [UIImage imageWithData:appendData];
        appendData = nil;
        _downloading = NO;
        if ([self.delegate respondsToSelector:@selector(imageLoaded:)] && self.image != nil)
            [self.delegate imageLoaded:self];
    };
    
    self.connection = nil;
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    
    @synchronized (self) {
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        spinner = nil;
        _downloading = NO;
        if ([self.delegate respondsToSelector:@selector(imageFailed:)])
            [self.delegate imageFailed:self];
    };

    
    NSLog(@"image loading failed due to %@", [error description]);
}

@end
