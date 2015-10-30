// DiscogsAPI.h
//
// Copyright (c) 2015 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "DGAuthentication.h"
#import "DGDatabase.h"
#import "DGUser.h"
#import "DGResource.h"
#import "DGMarketplace.h"

/**
 Discogs API client class to manage client initialization and api endpoints.
 */
@interface DiscogsAPI : NSObject <DGEndpointDelegate>

/**
 Autentication endpoint.
 */
@property (nonatomic, readonly) DGAuthentication * authentication;

/**
 Database endpoint.
 */
@property (nonatomic, readonly) DGDatabase * database;

/**
 User endpoint.
 */
@property (nonatomic, readonly) DGUser * user;

/**
 Marketplace endpoint.
 */
@property (nonatomic, readonly) DGMarketplace * marketplace;

/**
 Resource endpoint.
 */
@property (nonatomic, readonly) DGResource * resource;

/**
 Media Type.
 */
@property (nonatomic,readwrite) DGMediaType mediaType;

/**
 Network reachability.
 */
@property (nonatomic, readonly, getter=isReachable) BOOL isReachable;

/**
 The shared discogs api client.
 
 @return The shared discogs api client.
 */
+ (DiscogsAPI *) client;

/**
 Cancell all queued and current operations with Discogs.
 */
- (void) cancelAllOperations;

- (void) isAuthenticated:(void (^)(BOOL success))success;

@end
