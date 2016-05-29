//
//  BaseCube.m
//  MagicCube
//
//  Created by user on 13-3-7.
//  Copyright (c) 2013年 Richard Tan. All rights reserved.
//

#import "TFQBaseCube.h"
#import <GLKit/GLKit.h>

void print(int m,int n,float vertices[m][n]){
    NSMutableString*str=[[NSMutableString alloc] init];
    for (int i=0; i<m*n; i++) {
        if (i%n==0) {
            [str appendString:@"\n"];
        }
        [str appendFormat:@"%2.1f,\t",vertices[i/n][i%n]];
        
    }
    NSLog(@"%@",str);
}
void print2(int m,int n,GLubyte vertices[m][n]){
    NSMutableString*str=[[NSMutableString alloc] init];
    for (int i=0; i<m*n; i++) {
        if (i%n==0) {
            [str appendString:@"\n"];
        }
        [str appendFormat:@"%u,\t",vertices[i/n][i%n]];
        
    }
    NSLog(@"%@",str);
}

GLint Colors[7];


@interface TFQBaseCube ()
{
    GLuint _buffer;
    GLuint _IndexBuffers[6];
}
@end
@implementation TFQBaseCube


+(GLuint)color:(int)i{
    if (!Colors[0]) {
        [TFQBaseCube ColorInit];
    }
    return Colors[i];
}
-(id)initWithIndex:(GLint)index{
    _index=index;
    return [self initWithX:index/9-1 withY:index/3%3-1 withZ:
            index%3-1];
}
+(void)ColorInit{
    Colors[0]=[GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"red" ofType:@"png"] options:nil error:nil ].name;
    Colors[1]=[GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"orange" ofType:@"png"] options:nil error:nil ].name;
    Colors[2]=[GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"yellow" ofType:@"png"] options:nil error:nil ].name;
    Colors[3]=[GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green" ofType:@"png"] options:nil error:nil ].name;
    Colors[4]=[GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"blue" ofType:@"png"] options:nil error:nil ].name;
    Colors[5]=[GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"purple" ofType:@"png"] options:nil error:nil ].name;
}

- (id)initWithX:(GLint) x withY:(GLint)y withZ:(GLint)z{
    if ([self init]) {
        GLfloat Vertices[24][8];
        for (int i=0; i<6; i++) {
            for (int j=0; j<4; j++) {
                Vertices[i*4+j][i%3]=j/2-0.5;
                Vertices[i*4+j][(i+1)%3]=j%2-0.5;
                Vertices[i*4+j][(i+2)%3]=0.5-i/3;
                
                Vertices[i*4+j][i%3+3]=Vertices[i*4+j][i%3];
                Vertices[i*4+j][(i+1)%3+3]=0;
                Vertices[i*4+j][(i+2)%3+3]=0;
                
                Vertices[i*4+j][0]+=x;
                Vertices[i*4+j][1]+=y;
                Vertices[i*4+j][2]+=z;
                
                Vertices[i*4+j][6]=j%2;
                Vertices[i*4+j][7]=j/2;
            }
        }
        
        GLuint buffer;
        glGenBuffers(1, &buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
        _buffer=buffer;
        GLubyte Indeces[6]={0,1,2,2,1,3};
        GLubyte temp[6][6];
        for (int i=0; i<6; i++) {
            for(int j=0;j<6;j++){
                temp[i][j]=Indeces[j]+4*i;
            }
            glGenBuffers(1, &buffer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,  buffer);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(temp[i]), temp[i], GL_STATIC_DRAW);
            _IndexBuffers[i]=buffer;
           
        }
//        print2(6, 6, temp);
//        print(24,8,Vertices);
        
    }
    return self;
  
}

-(void) drawCube{
    glBindBuffer(GL_ARRAY_BUFFER, _buffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 4*8, (char*)NULL+0);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4*8, (char*)NULL+12);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*8, (char*)NULL+24);
    for (int i=0; i<6; i++) {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IndexBuffers[i]);
        GLuint color=[TFQBaseCube color:i];
        glBindTexture(GL_TEXTURE_2D, color);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
    }
       

}

@end
