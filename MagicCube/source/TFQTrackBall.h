//
//  TFQTrackBall.h
//  MagicCube
//
//  Created by user on 13-3-19.
//  Copyright (c) 2013年 Richard Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
@interface TFQTrackBall : NSObject
-(void)touchDownAtX:(GLfloat)x AtY:(GLfloat)y;

-(GLKMatrix4)touchMoveAtX:(GLfloat)x AtY:(GLfloat)y;
-(void)touchUpAtX:(GLfloat)x AtY:(GLfloat)y;
@end
