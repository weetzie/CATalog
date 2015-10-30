// DGCollection.m
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

#import "DGEndpoint+Configuration.h"
#import "DGCollection.h"
#import "DGReleaseInstance+Mapping.h"
#import "DGCollectionFolder+Mapping.h"
#import "DGCollectionField+Mapping.h"

@implementation DGCollection

+ (DGCollection*) collection {
    return [[DGCollection alloc] init];
}

- (void) configureManager:(RKObjectManager*)objectManager {
    
    //User collection folders
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGCollectionFoldersRequest class] pathPattern:@"users/:userName/collection/folders" method:RKRequestMethodAny]];
    
    //User collection folder request
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGCollectionFolderRequest class] pathPattern:@"users/:userName/collection/folders/:folderID" method:RKRequestMethodAny]];
    
    //Create collection folder request
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGCreateCollectionFolderRequest class] pathPattern:@"users/:userName/collection/folders" method:RKRequestMethodPOST]];
    
    //User collection releases request
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGCollectionReleasesRequest class] pathPattern:@"users/:userName/collection/folders/:folderID/releases" method:RKRequestMethodGET]];
    
    //Post release in Collection folder
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGAddToCollectionFolderRequest class] pathPattern:@"/users/:userName/collection/folders/:folderID/releases/:releaseID" method:RKRequestMethodPOST]];
    
    //Manage collection's release instance
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGReleaseInstanceRequest class] pathPattern:@"/users/:userName/collection/folders/:folderID/releases/:releaseID/instances/:instanceID" method:RKRequestMethodAny]];
    
    //Change release's rating
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGChangeRatingOfReleaseRequest class] pathPattern:@"/users/:userName/collection/folders/:folderID/releases/:releaseID/instances/:instanceID" method:RKRequestMethodPOST]];
    
    //Get release instance fields
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGCollectionFieldsRequest class] pathPattern:@"users/:userName/collection/fields" method:RKRequestMethodGET]];
    
    //Edit instance field request
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[DGEditFieldsInstanceRequest class] pathPattern:@"/users/:userName/collection/folders/:folderID/releases/:releaseID/instances/:instanceID/fields/:fieldID" method:RKRequestMethodPOST]];
    [objectManager addRequestDescriptor:[DGEditFieldsInstanceRequest requestDescriptor]];
}

- (void) getCollectionFolders:(NSString*)userName success:(void (^)(NSArray* folders))success failure:(void (^)(NSError* error))failure {
    
    DGCollectionFoldersRequest* collection = [DGCollectionFoldersRequest collection];
    collection.userName = userName;
    
    NSURLRequest *requestURL = [self.manager requestWithObject:collection
                                                        method:RKRequestMethodGET
                                                          path:nil
                                                    parameters:nil];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGCollectionFolder foldersResponseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        success(mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) getCollectionFolder:(DGCollectionFolderRequest*)request success:(void (^)(DGCollectionFolder* folder))success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodGET
                                                          path:nil
                                                    parameters:nil];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGCollectionFolder responseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
         NSArray* results = mappingResult.array;
         if ([[results firstObject] isKindOfClass:[DGCollectionFolder class]]) {
             success([results firstObject]);
         }
         else {
             failure([self errorWithCode:NSURLErrorCannotParseResponse info:@"Bad response from Discogs server"]);
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         RKLogError(@"Operation failed with error: %@", error);
         failure(error);
     }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) createCollectionFolder:(DGCreateCollectionFolderRequest*)request success:(void (^)(DGCollectionFolder* folder))success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodPOST
                                                          path:nil
                                                    parameters:request.parameters];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGCollectionFolder responseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSArray* results = mappingResult.array;
        if ([[results firstObject] isKindOfClass:[DGCollectionFolder class]]) {
            success([results firstObject]);
        }
        else {
            failure([self errorWithCode:NSURLErrorCannotParseResponse info:@"Bad response from Discogs server"]);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) editCollectionFolder:(DGCollectionFolderRequest*)request success:(void (^)(DGCollectionFolder* folder))success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodPOST
                                                          path:nil
                                                    parameters:request.parameters];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGCollectionFolder responseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSArray* results = mappingResult.array;
        if ([[results firstObject] isKindOfClass:[DGCollectionFolder class]]) {
            success([results firstObject]);
        }
        else {
            failure([self errorWithCode:NSURLErrorCannotParseResponse info:@"Bad response from Discogs server"]);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) deleteCollectionFolder:(DGCollectionFolderRequest*)request success:(void (^)())success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodDELETE
                                                          path:nil
                                                    parameters:nil];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:self.manager.responseDescriptors];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) getCollectionReleases:(DGCollectionReleasesRequest*)request success:(void (^)(DGCollectionReleasesResponse* response))success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodGET
                                                          path:nil
                                                    parameters:request.parameters];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGCollectionReleasesResponse responseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
         NSArray* results = mappingResult.array;
         if ([[results firstObject] isKindOfClass:[DGCollectionReleasesResponse class]]) {
             success([results firstObject]);
         }
         else {
             failure([self errorWithCode:NSURLErrorCannotParseResponse info:@"Bad response from Discogs server"]);
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error) {
         RKLogError(@"Operation failed with error: %@", error);
         failure(error);
     }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) addToCollectionFolder:(DGAddToCollectionFolderRequest*)request success:(void (^)(DGAddToCollectionFolderResponse* response))success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodPOST
                                                          path:nil
                                                    parameters:request.parameters];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGAddToCollectionFolderResponse responseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSArray* results = mappingResult.array;
        if ([[results firstObject] isKindOfClass:[DGAddToCollectionFolderResponse class]]) {
            success([results firstObject]);
        }
        else {
            failure([self errorWithCode:NSURLErrorCannotParseResponse info:@"Bad response from Discogs server"]);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) changeRatingOfRelease:(DGChangeRatingOfReleaseRequest*)request success:(void (^)())success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodPOST
                                                          path:nil
                                                    parameters:request.parameters];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:self.manager.responseDescriptors];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) deleteInstanceFromFolder:(DGReleaseInstanceRequest*)request success:(void (^)())success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodDELETE
                                                          path:nil
                                                    parameters:nil];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:self.manager.responseDescriptors];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) getCollectionFields:(NSString*)userName success:(void (^)(NSArray* fields))success failure:(void (^)(NSError* error))failure {
    
    DGCollectionFieldsRequest* request = [DGCollectionFieldsRequest request];
    request.userName = userName;
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodGET
                                                          path:nil
                                                    parameters:nil];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:@[ [DGCollectionField responseDescriptor] ]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success(mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

- (void) editFieldsInstance:(DGEditFieldsInstanceRequest*)request success:(void (^)())success failure:(void (^)(NSError* error))failure {
    
    NSURLRequest *requestURL = [self.manager requestWithObject:request
                                                        method:RKRequestMethodPOST
                                                          path:nil
                                                    parameters:request.parameters];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:requestURL
                                                                                     responseDescriptors:self.manager.responseDescriptors];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:objectRequestOperation];
}

@end
