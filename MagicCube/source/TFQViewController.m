//
//  TFQViewController.m
//  HelloGLKit
//
//  Created by user on 13-3-5.
//  Copyright (c) 2013年 Richard Tan. All rights reserved.
//

#import "TFQViewController.h"
#import "TFQViewController.h"
#import "TFQTrackBall.h"
#import "TFQMagicCubeEngine.h"

#define kScreenWidth 320
#define kScreenHeight 480
#define MaxZ 10
#define MinZ 0.1

@interface TFQViewController ()
{
    GLKMatrix4 _rotateMatrix4;

    int _tapCount;
}
@property (strong,nonatomic)EAGLContext * context;
@property (strong,nonatomic)GLKBaseEffect * effect;
@property (strong,nonatomic)TFQTrackBall*trackBall;
@property (strong,nonatomic)TFQMagicCubeEngine *magicCubeEngine;
@end

@implementation TFQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.context=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* view=(id) self.view;
    view.context=self.context;
    view.drawableColorFormat=GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat=GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_DEPTH_TEST);
    
    self.effect=[[GLKBaseEffect alloc]init];
    
    self.effect.texture2d0.enabled=GL_TRUE;
    

    


    _rotateMatrix4=GLKMatrix4Identity;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) drawCube{
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);

}

-(GLint) loadShaders:(NSString*)vert frag:(NSString*)frag{
    GLint verShader,fragShader;
    GLint pprogram=glCreateProgram();
    
    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    
    glAttachShader(pprogram, verShader);
    glAttachShader(pprogram, fragShader);
    
    glLinkProgram(pprogram);
    
    return pprogram;
}
- (void)compileShader:(GLint *)shader type:(GLenum) type file:(NSString*)file{

    NSString *content =[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    const GLchar *source=(GLchar*)[content UTF8String];
    
    *shader=glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
}


#pragma mark -
#pragma mark 绘图刷新
-(void)update{
    
    CGSize size=self.view.bounds.size;
    float aspect=fabsf(size.width/size.height);
   
    GLKMatrix4 projectionMatrix=GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65), aspect, 0.1, 10);
    
    GLKMatrix4 modelviewMatricx=GLKMatrix4Translate(GLKMatrix4Identity, 0,0, -7);
   
    modelviewMatricx=GLKMatrix4Multiply(modelviewMatricx,_rotateMatrix4);
    self.effect.transform.modelviewMatrix=modelviewMatricx;
    self.effect.transform.projectionMatrix=projectionMatrix;

}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0.3, 0.6, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

    
    [self.effect prepareToDraw];
    [self.magicCubeEngine draw];
    
}


#pragma mark -
#pragma mark 触屏处理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint touchPoint=[touch locationInView:self.view];
    _tapCount=[touch tapCount];
    if (_tapCount==2) {
       [self.magicCubeEngine touchDownAtX:touchPoint.x AtY:touchPoint.y];
    }else if (_tapCount==1){
    [self.trackBall touchDownAtX:touchPoint.x AtY:touchPoint.y];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.view];
 if (_tapCount==1){
        [self.trackBall touchUpAtX:point.x AtY:point.y];
        self.magicCubeEngine.projectionModelviewMatrix=GLKMatrix4Multiply(self.effect.transform.projectionMatrix, self.effect.transform.modelviewMatrix);
        self.magicCubeEngine.rotateMatrix=_rotateMatrix4;
 }

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch=[touches anyObject];
    
    CGPoint point=[touch locationInView:self.view];
    if (_tapCount==2) {
        [self.magicCubeEngine touchMoveAtX:point.x AtY:point.y];
    }else if (_tapCount==1){
    _rotateMatrix4=[self.trackBall touchMoveAtX:point.x AtY:point.y];
    }
}



#pragma mark -
#pragma mark getter方法初始化数据

-(TFQTrackBall *)trackBall{
    if (!_trackBall) {
        self.trackBall=[[TFQTrackBall alloc]init];
    }
    return _trackBall;
}
-(TFQMagicCubeEngine*)magicCubeEngine{
    if (!_magicCubeEngine) {
        GLKMatrix4 viewPortMatrix=GLKMatrix4Make(
                                                 kScreenWidth/2,0,0,0,
                                                 0,-kScreenHeight/2,0,0,
                                                 0,0,MaxZ-MinZ,0,
                                                 kScreenWidth/2,kScreenHeight/2,MinZ,1
                                                                         );
        self.magicCubeEngine=[[TFQMagicCubeEngine alloc]init];
        [self update];
        self.magicCubeEngine.projectionModelviewMatrix=GLKMatrix4Multiply(self.effect.transform.projectionMatrix, self.effect.transform.modelviewMatrix);
        self.magicCubeEngine.projectionModelviewMatrix=GLKMatrix4Multiply(viewPortMatrix, self.magicCubeEngine.projectionModelviewMatrix);
        self.magicCubeEngine.rotateMatrix=_rotateMatrix4;
    }
    return _magicCubeEngine;
}
@end
