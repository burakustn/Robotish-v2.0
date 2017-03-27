#import "MainScene.h"

@implementation MainScene

+ (MainScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    return self;
}

-(void)onEnter
{
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    //[audio playBg:@"ccbResources/sounds/MainScene.mp3" loop:YES];
    NSLog(@"Girdi");
}

-(void)challenge:(id)sender{
        [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Level3"]];
}

-(void)okButton:(id)sender
{
    [infoMenu setPosition:ccp(628,0)];
    //[okButton setVisible:false];
    [infoMenu setVisible:false];
}

-(void)infoButton:(id)sender
{
    [infoMenu setPosition:ccp(0,0)];
    //[okButton setVisible:true];
    [infoMenu setVisible:true];
    NSLog(@"infoButton");
}


@end
