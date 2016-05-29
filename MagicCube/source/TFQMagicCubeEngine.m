//
//  TFQMagicCubeChangeEngine.m
//  MagicCube
//
//  Created by user on 13-3-20.
//  Copyright (c) 2013年 Richard Tan. All rights reserved.
//

#import "TFQMagicCubeEngine.h"
#import "TFQBaseCube.h"
typedef struct{
    int i;
    int k;
} Surface;

@interface TFQMagicCubeEngine(){
    NSArray *_cubes;
    Surface _start;
}
@end
@implementation TFQMagicCubeEngine

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *array=[[NSMutableArray alloc] init];
        for (int i=0; i<27; i++) {
            [array addObject: [[TFQBaseCube alloc]initWithIndex:i]];
        }
        _cubes=[[NSArray alloc]initWithArray:array];
    }
    return self;
}
-(void)touchDownAtX:(GLfloat)x AtY:(GLfloat)y{
    _start=[self switchCube:GLKVector2Make(x,y)];
}
-(GLKMatrix4)touchMoveAtX:(GLfloat)x AtY:(GLfloat)y{
    
    Surface temp=[self switchCube:GLKVector2Make(x,y)];
    if(temp.i!=_start.i||temp.k!=_start.k){
        NSLog(@"%d,%d:%d,%d",_start.i,_start.k,temp.i,temp.k);
    }
    return GLKMatrix4Identity;
}
-(Surface)switchCube:(GLKVector2)vector2{
    Surface s;
    for (int i=0; i<6; i++) {
        float array[3];
        array[i/2]=i%2-0.5;
        array[(i/2+1)%3]=0;
        array[(i/2+2)%3]=0;
        GLKVector3 normal=GLKVector3MakeWithArray(array);	
        {
            GLKVector4 v4=GLKMatrix4MultiplyVector4(self.rotateMatrix,GLKVector4MakeWithVector3(normal, 1) );
            normal=GLKVector3Make(v4.x/v4.w, v4.y/v4.w, v4.z/v4.w);

        }
        GLKMatrix4 matrix;
        if (normal.z>0) {
            for (int j=0; j<4; j++) {
                array[(i/2+1)%3]=j/2-0.5;
                array[(i/2+2)%3]=j%2-0.5;
                GLKVector4 v4=GLKVector4MakeWithVector3(GLKVector3MultiplyScalar(GLKVector3MakeWithArray(array), 3), 1);
                matrix=GLKMatrix4SetColumn(matrix, j, v4);
            }
            GLKMatrix4 matrix4=GLKMatrix4Multiply(self.projectionModelviewMatrix, matrix);

            if([TFQMagicCubeEngine isPoint:vector2 InSurface:matrix4])
            {
                NSLog(@"%d",i);
                array[i/2]=1;
                array[(i/2+1)%3]=1.0/3;
                array[(i/2+2)%3]=1.0/3;
                matrix= GLKMatrix4Multiply( GLKMatrix4MakeScale(array[0], array[1],array[2]), matrix);
                for (int k=0; k<9; k++) {
                    array[i/2]=0;
                    array[(i/2+1)%3]=k/3-1;
                    array[(i/2+2)%3]=k%3-1;
                    matrix4=GLKMatrix4Multiply(GLKMatrix4MakeTranslation(array[0], array[1],array[2]),matrix);
                    
                    matrix4=GLKMatrix4Multiply(self.projectionModelviewMatrix, matrix4);
                    if ([TFQMagicCubeEngine isPoint:vector2 InSurface:matrix4]) {
                        s.i=i;
                        s.k=k;
                        NSLog(@"%d:%d",i,k);
                        return s;
                    }
                };
            }
        }
    }
    s.i=-1;
    return s;
    
}
-(void)draw{
    for (TFQBaseCube *cube in _cubes) {
        [cube drawCube];
    }
}


+(BOOL)isPoint:(GLKVector2)point InSurface:(GLKMatrix4)surface{
 
    GLKVector2 vectors[4];
    for (int i=0; i<4; i++) {
        float w=surface.m[4*i+3];
        float x=surface.m[4*i]/w;
        float y=surface.m[4*i+1]/w;

        vectors[i]=GLKVector2Make(x,y);
        
    }
    return ([TFQMagicCubeEngine isPoint:point anticlockwiseP1:vectors[0] andP2:vectors[1] ]
            ^[TFQMagicCubeEngine isPoint:point anticlockwiseP1:vectors[2]  andP2:vectors[3]])
    &&
    ([TFQMagicCubeEngine isPoint:point anticlockwiseP1:vectors[0] andP2:vectors[2]]
     ^[TFQMagicCubeEngine isPoint:point anticlockwiseP1:vectors[1]  andP2:vectors[3]]);
}
+(Byte)isPoint :(GLKVector2)point anticlockwiseP1:(GLKVector2)p1 andP2:(GLKVector2)p2{
    BOOL flag;
    if(p1.x!=p2.x){
        float k=(p2.y-p1.y)/(p2.x-p1.x);
        float y;
        if(k>0){
            y=k*(point.x-p1.x)+p1.y;
        }else{
            y=-k*(point.x-p2.x)+p2.y;
        }
        flag=point.y<y;
        
    }else{
        flag=  point.x<p1.x;
    }
    return flag;
}
@end
