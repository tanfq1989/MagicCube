//
//  BaseCube.h
//  MagicCube
//
//  Created by user on 13-3-7.
//  Copyright (c) 2013年 Richard Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class GLKBaseEffect;
@interface TFQBaseCube : NSObject{

}
@property (readonly,nonatomic)int index;
+(GLuint)color:(int)i;
//- (id)initWithX:(GLint) x withY:(GLint)y withZ:(GLint)z;
- (id)initWithIndex:(GLint)index;
-(void) drawCube;
@end
