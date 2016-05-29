//
//  TFQMagicCubeChangeEngine.h
//  MagicCube
//
//  Created by user on 13-3-20.
//  Copyright (c) 2013年 Richard Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface TFQMagicCubeEngine : NSObject
@property (assign,nonatomic)GLKMatrix4 projectionModelviewMatrix;
@property (assign,nonatomic)GLKMatrix4 rotateMatrix;
-(void)touchDownAtX:(GLfloat)x AtY:(GLfloat)y;
-(void)draw;
-(GLKMatrix4)touchMoveAtX:(GLfloat)x AtY:(GLfloat)y;
@end
