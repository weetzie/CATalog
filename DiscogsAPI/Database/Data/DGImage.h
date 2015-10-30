// DGImage.h
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

#import "DGObject.h"

/**
 Image desciption class.
 */
@interface DGImage : DGObject

/**
 Image width.
 */
@property (nonatomic, strong) NSNumber * width;

/**
 Image height.
 */
@property (nonatomic, strong) NSNumber * height;

/**
 Image type.
 */
@property (nonatomic, strong) NSString * type;

/**
 Resource URL of the 150x150 image version on Discogs API.
 */
@property (nonatomic, strong) NSString * uri150;

/**
 Creates and initializes a `DGImage` object.
 
 @return The newly-initialized image object.
 */
+ (DGImage*) image;

@end