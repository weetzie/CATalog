// DGReleaseInstance+Mapping.m
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

#import "DGReleaseInstance+Mapping.h"

@implementation DGReleaseInstance (Mapping)

+ (RKMapping *) mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[DGReleaseInstance class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"instance_id"                : @"ID",
                                                  @"rating"                     : @"rating",
                                                  @"basic_information.thumb"    : @"thumb",
                                                  @"basic_information.title"    : @"title",
                                                  @"basic_information.year"     : @"year",
                                                  @"basic_information.id"       : @"releaseID",
                                                  @"basic_information.artists"  : @"artists",
                                                  @"basic_information.labels"   : @"labels"
                                                  }];
    
    return mapping;
}

@end

@implementation DGReleaseInstanceRequest (Mapping)

- (NSDictionary*) parameters {
    return nil;
}

@end

@implementation DGEditFieldsInstanceRequest (Mapping)

+ (RKRequestDescriptor*) requestDescriptor {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{@"value" : @"value"}];
    
    return [RKRequestDescriptor requestDescriptorWithMapping:mapping objectClass:[DGEditFieldsInstanceRequest class] rootKeyPath:nil method:RKRequestMethodPOST];
}

- (NSDictionary*) parameters {
    return @{@"value" : self.value};
}

@end

@implementation DGChangeRatingOfReleaseRequest (Mapping)

- (NSDictionary*) parameters {
    /* // Probleme with new restkit 0.24.0 : Empty property are added in parameters
     NSError *error;
     NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:[RKObjectParameterization parametersWithObject:self requestDescriptor:[DGSearchRequest requestDescriptor] error:&error]];
     */
    
    // Q&D workaround :
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    if( self.rating ) {
        [parameters setObject:self.rating forKey:@"rating"];
    }
    
    return parameters;
}

@end