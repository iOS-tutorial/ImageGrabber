//
//  ImageInfo.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageInfo.h"
#import "ASIHTTPRequest.h"

@implementation ImageInfo

@synthesize sourceURL;
@synthesize imageName;
@synthesize image;

- (void)getImage {
    
    NSLog(@"Getting %@...", sourceURL);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sourceURL];
    [request setCompletionBlock:^{
        NSLog(@"Image Downloaded");
        NSData *data = [request responseData];
        image = [[UIImage alloc] initWithData:data];
        
        //notify after the image is updated
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.bipin.imageUpdated" object:self];
    }];
    
    [request setFailedBlock:^{
        NSError * error = [request error];
        NSLog(@"Errro downloading image: %@", error.localizedDescription);
    }];
   
    [request startAsynchronous];
}

- (id)initWithSourceURL:(NSURL *)URL {
    if ((self = [super init])) {
        sourceURL = [URL retain];
        imageName = [[URL lastPathComponent] retain];
        [self getImage];
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i {
    if ((self = [super init])) {
        sourceURL = [URL retain];
        imageName = [name retain];
        image = [i retain];
    }
    return self;
}

- (void)dealloc {
    [sourceURL release];
    [imageName release];
    [image release];
    [super dealloc];
}

@end
