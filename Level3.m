//Sakarya University 2016 Graduation Project

#pragma mark - ActionTags

/*
 1:Run
 2:Idle(----)
 3:Jump
 4:Shoot
 5:Dead
 6:JumpShoot
 7:
 8:
 9:
 10:
 11:Ease Jump
 12:Dusme Animasyon
 13:Fall
 20:Barrel 1 Explosion
 21:Barrel 2 Explosion
 */


#import "Level3.h"
@implementation Level3

+ (Level3 *)scene
{
    return [[self alloc] init];
}
- (id)init
{
    self = [super init];
    if (!self) return(nil);
    self.userInteractionEnabled = TRUE;
    [self setMultipleTouchEnabled:YES];
    return self;
}
-(void)onEnter //Sahne Yüklenirken
{
    [super onEnter];
    sayac =0;
    can=3;
    skor=0;
    canoteleme=0;
    timersure=0;
    _hizsayaci=0;
    _hizcarpani=0.7; //Oyunun ana hız çarpanı başlangıç değeri
    _animasyoncarpani=1;
    denemesayac=0;
    [_physicsNode setGravity:ccp(0.0, -700)]; // Yer çekimi
    
    //--------------------Kontrol Değişkenleri-----------------------
    T1_J1Kontrol=false;
    T1_J2Kontrol=false;
    T1_J3Kontrol=false;
    T1_J4Kontrol=false;
    T2_J1Kontrol=false;
    T2_J2Kontrol=false;
    T2_J3Kontrol=false;
    T2_J4Kontrol=false;
    bullet.visible=false;
    bulletReady=true;
    ziplamaHazir=true;
    ilkbasamakdami = false;
    ikincibasamakdami=false;
    ucuncubasamakdami=false;
    //----------------------------------------------------------------
    //-----------Sounds Effects---------------------------------------
    OALSimpleAudio *backgroundeffect = [OALSimpleAudio sharedInstance];
    Sounds = [OALSimpleAudio sharedInstance];
    // play background sound
    [backgroundeffect playBg:@"ccbResources/sounds/GameBackGround.mp3" volume:(0.5) pan:0 loop:YES];
    [Sounds preloadEffect:@"ccbResources/sounds/GameOver.wav"];
    [Sounds preloadEffect:@"ccbResources/sounds/FemaleScream.wav"];
    [Sounds preloadEffect:@"ccbResources/sounds/Shoot.mp3"];
    [Sounds preloadEffect:@"ccbResources/sounds/Explosion.mp3"];
    //----------------------------------------------------------------
    //-------------Timerlar-------------
    scoretimer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addPoint) userInfo:nil repeats:YES];
    _hizTimeri =[NSTimer scheduledTimerWithTimeInterval:1*_hizcarpani target:self selector:@selector(hizcarpani) userInfo:nil repeats:YES];

    //----------------------------------
    CCActionRotateBy* actionSpin1 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T1_J1 runAction:[CCActionRepeatForever actionWithAction:actionSpin1]];
    CCActionRotateBy* actionSpin2 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T1_J2 runAction:[CCActionRepeatForever actionWithAction:actionSpin2]];
    CCActionRotateBy* actionSpin3 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T1_J3 runAction:[CCActionRepeatForever actionWithAction:actionSpin3]];
    CCActionRotateBy* actionSpin4 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T1_J4 runAction:[CCActionRepeatForever actionWithAction:actionSpin4]];
    CCActionRotateBy* actionSpin5 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T2_J1 runAction:[CCActionRepeatForever actionWithAction:actionSpin5]];
    CCActionRotateBy* actionSpin6 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T2_J2 runAction:[CCActionRepeatForever actionWithAction:actionSpin6]];
    CCActionRotateBy* actionSpin7 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T2_J3 runAction:[CCActionRepeatForever actionWithAction:actionSpin7]];
    CCActionRotateBy* actionSpin8 = [CCActionRotateBy actionWithDuration:2.5f angle:-360];
    [T2_J4 runAction:[CCActionRepeatForever actionWithAction:actionSpin8]];

    
    backGroundMove  = [CCActionMoveTo actionWithDuration:50.0*_hizcarpani position:ccp(-569.4,Background.position.y)];
    [Background runAction:backGroundMove];
    backGroundMove = [CCActionMoveTo actionWithDuration:6.0*_hizcarpani position:ccp(zemin.position.x-600, zemin.position.y)];
    [zemin runAction:backGroundMove];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ccbResources/Robot.plist"];
    [self Animasyonlar];
    //[Robot runAction:runAnimation];
}
-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if(!isGamePaused) //Oyun bittikten sonra ateş etmemesi için
    {
        CGPoint touchLocation = [touch locationInNode:self];
        CGSize s = [CCDirector sharedDirector].viewSize;
        if(CGRectContainsPoint(_btnJump2.boundingBox, touchLocation))
        {
            _btnZipla.highlighted = true;
            NSLog(@"btnZipla");
           
        }
        #pragma mark - BulletSettings
         if ((s.width/3<touchLocation.x)&& bulletReady )
        {

                bullet.physicsBody.type = CCPhysicsBodyTypeDynamic;
                [bullet setPosition:ccp(Robot.position.x +30, Robot.position.y+30)];
                bullet.visible =true;
                bulletReady=false;
                if([Robot getActionByTag:1]!=nil)
                {
                    [Robot stopAction:runAnimation];
                    if([Robot getActionByTag:5]==nil)
                    {
                        [Robot runAction:shootAnimation];
                        //NSLog(@"Shoot");
                    }
                }
                else if([Robot getActionByTag:3]!=nil)
                {
                    [Robot stopAction:jumpAnimation];
                    //if([Robot getActionByTag:6]==nil)
                    {
                        [Robot runAction:JumpShootAnimation];
                        //NSLog(@"JumpShoot");
                    }
                }
                [Sounds playEffect:@"ccbResources/sounds/Shoot.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                CGPoint impulse = ccpMult(touchLocation, 4.3f);
                impulse.y*=1.2f;
                [bullet.physicsBody applyImpulse:impulse];
        }
    }
}
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //if([Robot getActionByTag:1]==nil)
    _btnZipla.highlighted= false;
}
-(void)update:(CCTime)delta
{
#pragma mark - ZeminKontrolleri
    
    if(!isGamePaused)
    {
        if(CGRectContainsPoint(zemin.boundingBox, Robot.position)) //Zemindeyse zıplamayı aktif hale getir.
        {
            
            [Robot setPosition:ccp(Robot.position.x,48.9)];
            //NSLog(@"Pozisyon = %f",Robot.position.y);
            ilkbasamakdami=[self ziplama];
        }
        if((CGRectContainsPoint(T1_S1.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T1_S2.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T1_S3.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S1.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S2.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S3.boundingBox, Robot.position)))
            //Birinci basamak(şekil-1,2)deyse zıplamayı aktif hale getir.
        {
            if (!ilkbasamakdami) {
               // NSLog(@"1. Basamak Kontrolü");
                [Robot stopAllActions];
            }
                ilkbasamakdami = true;
            
            ikincibasamakdami=[self ziplama]; //false döndürür
        }
        if((CGRectContainsPoint(T1_S4.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T1_S5.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S4.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S5.boundingBox, Robot.position))) //İkinci basamak(şekil-3)deyse zıplamayı aktif hale getir.
        {

            if (!ikincibasamakdami)
            {
                [Robot stopAllActions];
                    //NSLog(@"2. Basamak Kontrolü");
            }
            ikincibasamakdami = true;
            ucuncubasamakdami= [self ziplama]; //false döndürür
        }
        if((CGRectContainsPoint(T1_S6.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T1_S7.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T1_S8.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S6.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S7.boundingBox, Robot.position)) ||
           (CGRectContainsPoint(T2_S8.boundingBox, Robot.position))) //Üçüncü basamak(şekil-4)teyse zıplamayı aktif hale getir.
        {
            
            if (!ucuncubasamakdami)
            {
                [Robot stopAllActions];
               // NSLog(@"3. Basamak Kontrolü");
            }
            ucuncubasamakdami = true;
            [self ziplama];
        }
        //if([Robot getActionByTag:13] ==nil)
        if([Robot getActionByTag:1]==nil)
        {
            if([Robot getActionByTag:3]==nil && [Robot getActionByTag:12]==nil)
            {
                ziplamaHazir=true;
                if(![Robot getActionByTag:4])  //Ateş ederken koşma bugını çözdü!
                {
                    if((CGRectContainsPoint(T1_S1.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S2.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S3.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S1.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S2.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S3.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S4.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S5.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S4.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S5.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S6.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S7.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T1_S8.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S6.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S7.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(T2_S8.boundingBox, Robot.position)) ||
                       (CGRectContainsPoint(zemin.boundingBox, Robot.position)))
                        [Robot runAction:runAnimation];
                }
            }
        }
    //}
#pragma mark - Cagirilanfonksiyonlar
    [self mermiayarlari];
    [self zeminyoksaasagidus];
    [self zemingelirsedur];
    [self VarillerVuruldumu];
    [self Can];
    [self EngelKontrol];
    [self zemingerisar];
    [self CarpismaKontrol];
    [self arkaplan];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self PauseMenu];
}
//Functions Starts
#pragma mark - Functions
-(void)ziplamaaksiyonu
{
    if([Robot getActionByTag:1]!=nil)
        [Robot stopAction:runAnimation];
    [Robot runAction:jumpAnimation];
    CCActionMoveTo* ziplama = [CCActionMoveTo actionWithDuration:0.5*_animasyoncarpani position:ccp(Robot.position.x, Robot.position.y+80.0)];
    CCActionMoveTo * inme = [CCActionMoveTo actionWithDuration:0.5*_animasyoncarpani position:ccp(Robot.position.x, Robot.position.y)];
    CCActionEaseIn *easin = [CCActionEaseIn actionWithAction:inme rate:3];
    CCActionEaseOut * easout = [CCActionEaseOut actionWithAction:ziplama rate:2];
    NSMutableArray *actionList =[NSMutableArray array];
    [actionList addObject:easout];
    [actionList addObject:easin];
    CCActionSequence * s =[CCActionSequence actionWithArray:actionList ];
    [s setTag:11];
    [Robot runAction:s];
}
-(BOOL)ziplama
{
    if (_btnZipla.highlighted && ziplamaHazir)
    {
        //if([Robot getActionByTag:1]!=nil)
          //"  [Robot stopAction:runAnimation];
        
        //if ([Robot getActionByTag:3]==nil && [Robot getActionByTag:4]==nil && [Robot getActionByTag:12]==nil)
          //  [Robot runAction:runAnimation];
        ziplamaHazir = false;
        if([Robot getActionByTag:3]==nil)
        {
            [self ziplamaaksiyonu];
            return false;
        }
    }
}
-(void)zeminyoksaasagidus
{

    if((ilkbasamakdami || ikincibasamakdami || ucuncubasamakdami) && ([Robot getActionByTag:11]==nil) && [Robot getActionByTag:13]==nil)
    {
        if(   !CGRectContainsPoint(T1_S1.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S2.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S3.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S4.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S5.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S6.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S7.boundingBox, Robot.position)
           && !CGRectContainsPoint(T1_S8.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S1.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S2.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S3.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S4.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S5.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S6.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S7.boundingBox, Robot.position)
           && !CGRectContainsPoint(T2_S8.boundingBox, Robot.position))
        {
            if ([Robot getActionByTag:12]==nil)
                [Robot runAction:dusmeAnimation];
            CCActionMoveTo* asagidus =[CCActionMoveTo actionWithDuration:0.3*_animasyoncarpani position:ccp(Robot.position.x, Robot.position.y -80)];
            asagidus.tag =13;
            [Robot runAction:asagidus];
        }

    }
    [self basamakgelirsesedur];
    [self zemingelirsedur];
}
-(void)zemingelirsedur
{
    if(CGRectContainsPoint(zemin.boundingBox, Robot.position))
    {
        if([Robot getActionByTag:13]!=nil)
        {
            [Robot stopActionByTag:13];
            ilkbasamakdami=false;
            ikincibasamakdami=false;
            ucuncubasamakdami=false;
        }
        
    }
}
-(void)basamakgelirsesedur
{
    if((CGRectContainsPoint(T1_S4.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T1_S5.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T2_S4.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T2_S5.boundingBox, Robot.position)))
        //ikinci seviye basamak eklenirse kontrol buraya
    {
        if([Robot getActionByTag:13]!=nil)
        {
            [Robot stopActionByTag:13];
            ucuncubasamakdami=false;
        }
    }
    if((CGRectContainsPoint(T1_S1.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T1_S2.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T1_S3.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T2_S1.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T2_S2.boundingBox, Robot.position)) ||
       (CGRectContainsPoint(T2_S3.boundingBox, Robot.position)))
        //birinci seviye basamak eklenirse kontrol buraya
    {
        if([Robot getActionByTag:13]!=nil)
        {
            [Robot stopActionByTag:13];
            ilkbasamakdami=false;
        }
        
    }
}
-(void)EngelKontrol
{
    if(!T1_J1Kontrol)
        if(CGRectContainsPoint(T1_J1.boundingBox, Robot.position))
        {
            //NSLog(@"T1_J1");
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            T1_J1Kontrol=true;
            can--;
        }
    if(!T1_J2Kontrol)
        if(CGRectContainsPoint(T1_J2.boundingBox, Robot.position))
        {
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            //NSLog(@"T1_J2");
            T1_J2Kontrol=true;
            can--;
        }
    if(!T1_J3Kontrol)
        if(CGRectContainsPoint(T1_J3.boundingBox, Robot.position))
        {
           [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            //NSLog(@"T1_J3");
            T1_J3Kontrol=true;
            can--;
        }
    if(!T1_J4Kontrol)
        if(CGRectContainsPoint(T1_J4.boundingBox, Robot.position))
        {
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            //NSLog(@"T1_J4");
            T1_J4Kontrol=true;
            can--;
        }
    if(!T2_J1Kontrol)
        if(CGRectContainsPoint(T2_J1.boundingBox, Robot.position))
        {
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            T2_J1Kontrol=true;
            can--;
        }
    if(!T2_J2Kontrol)
        if(CGRectContainsPoint(T2_J2.boundingBox, Robot.position))
        {
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            T2_J2Kontrol=true;
            can--;
        }
    if(!T2_J3Kontrol)
        if(CGRectContainsPoint(T2_J3.boundingBox, Robot.position))
        {
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            T2_J3Kontrol=true;
            can--;
        }
    if(!T2_J4Kontrol)
        if(CGRectContainsPoint(T2_J4.boundingBox, Robot.position))
        {
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            T2_J4Kontrol=true;
            can--;
        }
}
-(void)mermiayarlari
{
    CGSize s = [CCDirector sharedDirector].viewSize;
    if( (CGRectIntersectsRect(bullet.boundingBox,zemin.boundingBox))|| bullet.position.x>s.width || bullet.position.y>s.height)
    {
        bullet.visible=false;
        bulletReady=true;
        bullet.physicsBody.type = CCPhysicsBodyTypeStatic;
        bullet.position=ccp(s.height, s.width-10.0);
    }

}
-(void)VarillerVuruldumu
{
    
    //----------Mermi Kontrolleri----------
    if(CGRectIntersectsRect(bullet.boundingBox , _T1_B1.boundingBox))
    {
        if([T1_B1 getActionByTag:20]==nil)
            if(!T1_B1kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [T1_B1 runAction:(BarrelExplosion1)];
                skor=skor+10;
                T1_B1kontrol=true;
            }
    }
    if(CGRectIntersectsRect(bullet.boundingBox , _T1_B2.boundingBox))
    {
        if([T1_B2 getActionByTag:20]==nil)
            if(!T1_B2kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [T1_B2 runAction:(BarrelExplosion2)];
                skor=skor+10;
                T1_B2kontrol=true;
            }
    }
    if(CGRectIntersectsRect(bullet.boundingBox, _T2_B1.boundingBox))
    {
        if([T2_B1 getActionByTag:20]==nil)
            if(!T2_B1kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [T2_B1 runAction:(BarrelExplosion1)];
                skor=skor+10;
                T2_B1kontrol=true;
            }
    }
    if(CGRectIntersectsRect(bullet.boundingBox, _T2_B2.boundingBox))
    {
        if([T2_B2 getActionByTag:21]==nil)
            if(!T2_B2kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [T2_B2 runAction:(BarrelExplosion2)];
                skor=skor+10;
                T2_B2kontrol=true;
            }
    }
    
    //-------------------------------------
    
    //--------Çarpışma Kontrolleri----------
    if(CGRectIntersectsRect(Robot.boundingBox , _T1_B1.boundingBox))
    {
        if([T1_B1 getActionByTag:21]==nil)
        {
            if(!T1_B1kontrol)
            {
            [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
            [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
            [T1_B1 runAction:(BarrelExplosion1)];
            can--;
            T1_B1kontrol=true;
            
            }
        }
    }
    if(CGRectIntersectsRect(Robot.boundingBox, _T1_B2.boundingBox))
    {
        if([T1_B2 getActionByTag:20]==nil)
            if(!T1_B2kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
                [T1_B2 runAction:(BarrelExplosion2)];
                can--;
                T1_B2kontrol=true;
            }
    }
    if(CGRectIntersectsRect(Robot.boundingBox , _T2_B1.boundingBox))
    {
        if([T2_B1 getActionByTag:21]==nil)
        {
            if(!T2_B1kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
                [T2_B1 runAction:(BarrelExplosion1)];
                can--;
                T2_B1kontrol=true;
                
            }
        }
    }
    if(CGRectIntersectsRect(Robot.boundingBox, _T2_B2.boundingBox))
    {
        if([T2_B2 getActionByTag:20]==nil)
            if(!T2_B2kontrol)
            {
                [Sounds playEffect:@"ccbResources/sounds/Explosion.mp3" volume:(1) pitch:(1) pan:(0) loop:(false)];
                [Sounds playEffect:@"ccbResources/sounds/FemaleScream.wav" volume:(1) pitch:(1.5) pan:(0) loop:(false)];
                [T2_B2 runAction:(BarrelExplosion2)];
                can--;
                T2_B2kontrol=true;
            }
    }
    //---------------------------------------
  
}
-(void)zemingerisar
{
    if(!isGamePaused)
    {
    CGPoint p =[zemin convertToWorldSpace:yer6.position];
    if (p.x<=0)
    {
        
        [zemin stopAllActions];
        [zemin setPosition:ccp(-3.77, zemin.position.y)];
        CCActionMoveTo * ilerle  = [CCActionMoveTo actionWithDuration:6.0*_hizcarpani position:ccp(zemin.position.x-600, zemin.position.y)];
        [zemin runAction:ilerle];
    }
    }
}
-(void)CarpismaKontrol
{
    if(CGRectIntersectsRect(_CarpismaKontrol.boundingBox , T1_S1.boundingBox) ||
       (CGRectIntersectsRect(_CarpismaKontrol.boundingBox , T1_S3.boundingBox)) ||
       (CGRectIntersectsRect(_CarpismaKontrol.boundingBox , T1_S5.boundingBox)) ||
       (CGRectIntersectsRect(_CarpismaKontrol.boundingBox , T1_S6.boundingBox)))
        [self setPaused:false]; //Erken Kontrol Ediyor!!
}
-(void)addPoint
{
    if(!isGamePaused)
        skor=skor+1.2-_hizcarpani;
    [scoreLabel setString:[NSString stringWithFormat:@"%0.2f", skor]];
}
-(void)Can
{
    if(can==3)
    {
    }
    if(can==2)
    {
        [can3 setVisible:false];
    }
    if(can==1)
    {
        [can3 setVisible:false];
        [can2 setVisible:false];
    }
    if(can<=0)
    {
        [can3 setVisible:false];
        [can2 setVisible:false];
        [can1 setVisible:false];
     //   if([T1_B1 getActionByTag:20]==nil)
        //[self setPaused:true];
    }
}
-(CCActionAnimate*)AnimasyonEkle:(NSMutableArray*)AnimasyonDizi :(NSString*)PngListesi :(int)baslangic :(int)son :(CCAnimation*)Animasyon :(float)gecikme
{
    AnimasyonDizi = [NSMutableArray array];
    for (int i=baslangic; i<=son; i++)
        [AnimasyonDizi addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                  spriteFrameByName:[NSString stringWithFormat:PngListesi,i]]];
    Animasyon =[CCAnimation animationWithSpriteFrames:AnimasyonDizi delay:gecikme* _animasyoncarpani];
    return [CCActionAnimate actionWithAnimation:Animasyon];
}
-(void)zaman
{
#pragma mark - Sekilhareketleri
    CCActionMoveTo * ilerle;
    do
    {
        sayac = rand()%6;
    }
    while (sayac<=0);
    
    switch(sayac) {
        case 1:
        {
            //NSLog(@"Timer 1 Şekil 1");
            [T1_S1 setPosition:ccp(550, T1_S1.position.y)];
            [T1_S2 setPosition:ccp(900, T1_S2.position.y)];
            [T1_S5 setPosition:ccp(650, T1_S5.position.y)];
            [T1_S6 setPosition:ccp(900, T1_S6.position.y)];
            [_T1_B2 setPosition:ccp(900, 107)];
            
            
            [T1_S1 setVisible:true];
            [T1_S2 setVisible:true];
            [T1_S3 setVisible:false];
            [T1_S4 setVisible:false];
            [T1_S5 setVisible:true];
            [T1_S6 setVisible:true];
            [T1_S7 setVisible:false];
            [T1_S8 setVisible:false];
            [T1_B1 setVisible:false];
            [T1_B2 setVisible:true];
            [T1_J1 setVisible:false];
            [T1_J2 setVisible:false];
            [T1_J3 setVisible:false];
            [T1_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:7.5*_hizcarpani position:ccp(-200, T1_S1.position.y)];
            [T1_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.5*_hizcarpani position:ccp(-200, T1_S2.position.y)];
            [T1_S2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:8.5*_hizcarpani position:ccp(-200, T1_S5.position.y)];
            [T1_S5 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.0*_hizcarpani position:ccp(-200, T1_S6.position.y)];
            [T1_S6 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.5*_hizcarpani position:ccp(-200, 107)];
            [_T1_B2 runAction:ilerle];
        }
            break;
        case 2:
        {
            //NSLog(@"Timer 1 Şekil 2");
            [T1_S1 setPosition:ccp(600, T1_S1.position.y)];
            [T1_S2 setPosition:ccp(1000, T1_S2.position.y)];
            [T1_S5 setPosition:ccp(750, T1_S5.position.y)];
            [_T1_B1 setPosition:ccp(750, 155)];
            [_T1_B2 setPosition:ccp(1000, 107)];
            [T1_J1 setPosition:ccp(700, T1_J1.position.y)];
            [T1_J2 setPosition:ccp(750, T1_J2.position.y)];
            [T1_J3 setPosition:ccp(800, T1_J3.position.y)];
            [T1_J4 setPosition:ccp(850, T1_J4.position.y)];
            
            [T1_S1 setVisible:true];
            [T1_S2 setVisible:true];
            [T1_S3 setVisible:false];
            [T1_S4 setVisible:false];
            [T1_S5 setVisible:true];
            [T1_S6 setVisible:false];
            [T1_S7 setVisible:false];
            [T1_S8 setVisible:false];
            [T1_B1 setVisible:true];
            [T1_B2 setVisible:true];
            [T1_J1 setVisible:true];
            [T1_J2 setVisible:true];
            [T1_J3 setVisible:true];
            [T1_J4 setVisible:true];
            
            ilerle  = [CCActionMoveTo actionWithDuration:8.0*_hizcarpani position:ccp(-200, T1_S1.position.y)];
            [T1_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-200, T1_S2.position.y)];
            [T1_S2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T1_S5.position.y)];
            [T1_S5 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, 155)];
            [_T1_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-200, 107)];
            [_T1_B2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.0*_hizcarpani position:ccp(-200, T1_J1.position.y)];
            [T1_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T1_J2.position.y)];
            [T1_J2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_J3.position.y)];
            [T1_J3 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.5*_hizcarpani position:ccp(-200, T1_J4.position.y)];
            [T1_J4 runAction:ilerle];
            

        }
            break;
            case 3:
        {
            //NSLog(@"Timer 1 Şekil 3");
            [T1_S3 setPosition:ccp(800, T1_S3.position.y)];
            [T1_S5 setPosition:ccp(550, T1_S5.position.y)];
            [T1_S6 setPosition:ccp(850, T1_S6.position.y)];
            [_T1_B1 setPosition:ccp(1000, 52)];
            [T1_J1 setPosition:ccp(650, T1_J1.position.y)];
            
            [T1_S1 setVisible:false];
            [T1_S2 setVisible:false];
            [T1_S3 setVisible:true];
            [T1_S4 setVisible:false];
            [T1_S5 setVisible:true];
            [T1_S6 setVisible:true];
            [T1_S7 setVisible:false];
            [T1_S8 setVisible:false];
            [T1_B1 setVisible:true];
            [T1_B2 setVisible:false];
            [T1_J1 setVisible:true];
            [T1_J2 setVisible:false];
            [T1_J3 setVisible:false];
            [T1_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_S3.position.y)];
            [T1_S3 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:7.5*_hizcarpani position:ccp(-200, T1_S5.position.y)];
            [T1_S5 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_S6.position.y)];
            [T1_S6 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-200, 52)];
            [_T1_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:8.5*_hizcarpani position:ccp(-200, T1_J1.position.y)];
            [T1_J1 runAction:ilerle];
        }
            break;
            case 4:
        {
            //NSLog(@"Timer 1 Şekil 4");
            [T1_S1 setPosition:ccp(600, T1_S1.position.y)];
            [T1_S3 setPosition:ccp(800, T1_S3.position.y)];
            [_T1_B1 setPosition:ccp(900, 105)];
            [T1_J1 setPosition:ccp(750, T1_J1.position.y)];
            [T1_J2 setPosition:ccp(800, T1_J2.position.y)];
            [T1_J3 setPosition:ccp(850, T1_J3.position.y)];
            
            [T1_S1 setVisible:true];
            [T1_S2 setVisible:false];
            [T1_S3 setVisible:true];
            [T1_S4 setVisible:false];
            [T1_S5 setVisible:false];
            [T1_S6 setVisible:false];
            [T1_S7 setVisible:false];
            [T1_S8 setVisible:false];
            [T1_B1 setVisible:true];
            [T1_B2 setVisible:false];
            [T1_J1 setVisible:true];
            [T1_J2 setVisible:true];
            [T1_J3 setVisible:true];
            [T1_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:8.0*_hizcarpani position:ccp(-200, T1_S3.position.y)];
            [T1_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_S3.position.y)];
            [T1_S3 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.0*_hizcarpani position:ccp(-200, 105)];
            [_T1_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T1_J1.position.y)];
            [T1_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_J2.position.y)];
            [T1_J2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.5*_hizcarpani position:ccp(-200, T1_J3.position.y)];
            [T1_J3 runAction:ilerle];

        }
            break;
            case 5:
        {
            [T1_S1 setPosition:ccp(800, T1_S1.position.y)];
            [T1_S6 setPosition:ccp(550, T1_S6.position.y)];
            [T1_S7 setPosition:ccp(800, T1_S7.position.y)];
            [_T1_B1 setPosition:ccp(650, 50)];
            [_T1_B2 setPosition:ccp(900, 207)];
            [T1_J1 setPosition:ccp(750, T1_J1.position.y)];
            [T1_J2 setPosition:ccp(800, T1_J2.position.y)];
            [T1_J3 setPosition:ccp(850, T1_J3.position.y)];
            
            [T1_S1 setVisible:true];
            [T1_S2 setVisible:false];
            [T1_S3 setVisible:false];
            [T1_S4 setVisible:false];
            [T1_S5 setVisible:false];
            [T1_S6 setVisible:true];
            [T1_S7 setVisible:true];
            [T1_S8 setVisible:false];
            [T1_B1 setVisible:true];
            [T1_B2 setVisible:true];
            [T1_J1 setVisible:true];
            [T1_J2 setVisible:true];
            [T1_J3 setVisible:true];
            [T1_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_S1.position.y)];
            [T1_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:7.0*_hizcarpani position:ccp(-200, T1_S6.position.y)];
            [T1_S6 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_S7.position.y)];
            [T1_S7 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:8.5*_hizcarpani position:ccp(-200, 50)];
            [_T1_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.0*_hizcarpani position:ccp(-200, 207)];
            [_T1_B2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T1_J1.position.y)];
            [T1_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T1_J2.position.y)];
            [T1_J2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.5*_hizcarpani position:ccp(-200, T1_J3.position.y)];
            [T1_J3 runAction:ilerle];

        }
    }
    denemesayac++;
       //NSLog(@"Timer 1 Aktif");
        CCSpriteFrame * frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ccbResources/Robot/Barrel2 (0).png" ];
        [T1_B2 setSpriteFrame:frame1];
        frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ccbResources/Robot/Barrel1 (0).png" ];
        [T1_B1 setSpriteFrame:frame1];
    T1_B2kontrol=false;
    T1_B1kontrol=false;
    T1_J1Kontrol=false;
    T1_J2Kontrol=false;
    T1_J3Kontrol=false;
    T1_J4Kontrol=false;
    
}
-(void)zaman2
{
    CCActionMoveTo * ilerle;
    
    do
    {
        sayac = rand()%6;
    }
    while (sayac<=0);
    
    switch(sayac) {
        case 1:
        {
            //NSLog(@"Timer 2 Şekil 1");
            [T2_S1 setPosition:ccp(550, T2_S1.position.y)];
            [T2_S2 setPosition:ccp(900, T2_S2.position.y)];
            [T2_S5 setPosition:ccp(650, T2_S5.position.y)];
            [T2_S6 setPosition:ccp(900, T2_S6.position.y)];
            [_T2_B2 setPosition:ccp(900, 107)];
            
            
            [T2_S1 setVisible:true];
            [T2_S2 setVisible:true];
            [T2_S3 setVisible:false];
            [T2_S4 setVisible:false];
            [T2_S5 setVisible:true];
            [T2_S6 setVisible:true];
            [T2_S7 setVisible:false];
            [T2_S8 setVisible:false];
            [T2_B1 setVisible:false];
            [T2_B2 setVisible:true];
            [T2_J1 setVisible:false];
            [T2_J2 setVisible:false];
            [T2_J3 setVisible:false];
            [T2_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:7.5*_hizcarpani position:ccp(-200, T2_S1.position.y)];
            [T2_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.5*_hizcarpani position:ccp(-200, T2_S2.position.y)];
            [T2_S2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:8.5*_hizcarpani position:ccp(-200, T2_S5.position.y)];
            [T2_S5 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.0*_hizcarpani position:ccp(-200, T2_S6.position.y)];
            [T2_S6 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.5*_hizcarpani position:ccp(-200, 107)];
            [_T2_B2 runAction:ilerle];
        }
            break;
        case 2:
        {
            //NSLog(@"Timer 2 Şekil 2");
            [T2_S1 setPosition:ccp(600, T2_S1.position.y)];
            [T2_S2 setPosition:ccp(1000, T2_S2.position.y)];
            [T2_S5 setPosition:ccp(750, T2_S5.position.y)];
            [_T2_B1 setPosition:ccp(750, 155)];
            [_T2_B2 setPosition:ccp(1000, 107)];
            [T2_J1 setPosition:ccp(700, T2_J1.position.y)];
            [T2_J2 setPosition:ccp(750, T2_J2.position.y)];
            [T2_J3 setPosition:ccp(800, T2_J3.position.y)];
            [T2_J4 setPosition:ccp(850, T2_J4.position.y)];
            
            [T2_S1 setVisible:true];
            [T2_S2 setVisible:true];
            [T2_S3 setVisible:false];
            [T2_S4 setVisible:false];
            [T2_S5 setVisible:true];
            [T2_S6 setVisible:false];
            [T2_S7 setVisible:false];
            [T2_S8 setVisible:false];
            [T2_B1 setVisible:true];
            [T2_B2 setVisible:true];
            [T2_J1 setVisible:true];
            [T2_J2 setVisible:true];
            [T2_J3 setVisible:true];
            [T2_J4 setVisible:true];
            
            ilerle  = [CCActionMoveTo actionWithDuration:8.0*_hizcarpani position:ccp(-200, T2_S1.position.y)];
            [T2_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-200, T2_S2.position.y)];
            [T2_S2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T2_S5.position.y)];
            [T2_S5 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, 155)];
            [_T2_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-200, 107)];
            [_T2_B2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.0*_hizcarpani position:ccp(-200, T2_J1.position.y)];
            [T2_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T2_J2.position.y)];
            [T2_J2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_J3.position.y)];
            [T2_J3 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.5*_hizcarpani position:ccp(-200, T2_J4.position.y)];
            [T2_J4 runAction:ilerle];



        }
            break;
        case 3:
        {
            //NSLog(@"Timer 2 Şekil 3");
            [T2_S3 setPosition:ccp(800, T2_S3.position.y)];
            [T2_S5 setPosition:ccp(550, T2_S5.position.y)];
            [T2_S6 setPosition:ccp(850, T2_S6.position.y)];
            [_T2_B1 setPosition:ccp(1000, 52)];
            [T2_J1 setPosition:ccp(650, T2_J1.position.y)];
            [T2_J2 setPosition:ccp(1150, T2_J2.position.y)];
            
            [T2_S1 setVisible:false];
            [T2_S2 setVisible:false];
            [T2_S3 setVisible:true];
            [T2_S4 setVisible:false];
            [T2_S5 setVisible:true];
            [T2_S6 setVisible:true];
            [T2_S7 setVisible:false];
            [T2_S8 setVisible:false];
            [T2_B1 setVisible:true];
            [T2_B2 setVisible:false];
            [T2_J1 setVisible:true];
            [T2_J2 setVisible:true];
            [T2_J3 setVisible:false];
            [T2_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_S3.position.y)];
            [T2_S3 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:7.5*_hizcarpani position:ccp(-200, T2_S5.position.y)];
            [T2_S5 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_S6.position.y)];
            [T2_S6 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-200, 52)];
            [_T2_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:8.5*_hizcarpani position:ccp(-200, T2_J1.position.y)];
            [T2_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:12.0*_hizcarpani position:ccp(-50, T2_J2.position.y)];
            [T2_J2 runAction:ilerle];

        }
            break;
        case 4:
        {
            //NSLog(@"Timer 1 Şekil 4");
            [T2_S1 setPosition:ccp(600, T2_S1.position.y)];
            [T2_S3 setPosition:ccp(800, T2_S3.position.y)];
            [_T2_B1 setPosition:ccp(900, 105)];
            [T2_J1 setPosition:ccp(750, T2_J1.position.y)];
            [T2_J2 setPosition:ccp(800, T2_J2.position.y)];
            [T2_J3 setPosition:ccp(850, T2_J3.position.y)];
            
            [T2_S1 setVisible:true];
            [T2_S2 setVisible:false];
            [T2_S3 setVisible:true];
            [T2_S4 setVisible:false];
            [T2_S5 setVisible:false];
            [T2_S6 setVisible:false];
            [T2_S7 setVisible:false];
            [T2_S8 setVisible:false];
            [T2_B1 setVisible:true];
            [T2_B2 setVisible:false];
            [T2_J1 setVisible:true];
            [T2_J2 setVisible:true];
            [T2_J3 setVisible:true];
            [T2_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:8.0*_hizcarpani position:ccp(-200, T2_S3.position.y)];
            [T2_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_S3.position.y)];
            [T2_S3 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.0*_hizcarpani position:ccp(-200, 105)];
            [_T2_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T2_J1.position.y)];
            [T2_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_J2.position.y)];
            [T2_J2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.5*_hizcarpani position:ccp(-200, T2_J3.position.y)];
            [T2_J3 runAction:ilerle];
        }
            break;
        case 5:
        {
            //NSLog(@"Timer 1 Şekil 4");
            [T2_S1 setPosition:ccp(800, T2_S1.position.y)];
            [T2_S6 setPosition:ccp(550, T2_S6.position.y)];
            [T2_S7 setPosition:ccp(800, T2_S7.position.y)];
            [_T2_B1 setPosition:ccp(650, 50)];
            [_T2_B2 setPosition:ccp(900, 207)];
            [T2_J1 setPosition:ccp(750, T2_J1.position.y)];
            [T2_J2 setPosition:ccp(800, T2_J2.position.y)];
            [T2_J3 setPosition:ccp(850, T2_J3.position.y)];
            
            [T2_S1 setVisible:true];
            [T2_S2 setVisible:false];
            [T2_S3 setVisible:false];
            [T2_S4 setVisible:false];
            [T2_S5 setVisible:false];
            [T2_S6 setVisible:true];
            [T2_S7 setVisible:true];
            [T2_S8 setVisible:false];
            [T2_B1 setVisible:true];
            [T2_B2 setVisible:true];
            [T2_J1 setVisible:true];
            [T2_J2 setVisible:true];
            [T2_J3 setVisible:true];
            [T2_J4 setVisible:false];
            
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_S1.position.y)];
            [T2_S1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:7.0*_hizcarpani position:ccp(-200, T2_S6.position.y)];
            [T2_S6 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_S7.position.y)];
            [T2_S7 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:8.5*_hizcarpani position:ccp(-200, 50)];
            [_T2_B1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:11.0*_hizcarpani position:ccp(-200, 207)];
            [_T2_B2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:9.5*_hizcarpani position:ccp(-200, T2_J1.position.y)];
            [T2_J1 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.0*_hizcarpani position:ccp(-200, T2_J2.position.y)];
            [T2_J2 runAction:ilerle];
            ilerle  = [CCActionMoveTo actionWithDuration:10.5*_hizcarpani position:ccp(-200, T2_J3.position.y)];
            [T2_J3 runAction:ilerle];
        }
            break;
    }
    denemesayac++;
    //NSLog(@"Timer 2 Aktif");
    
    //if([T2_B1 getActionByTag:20]==nil)
    //{
        CCSpriteFrame * frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ccbResources/Robot/Barrel1 (0).png" ];
        [T2_B1 setSpriteFrame:frame1];
    //}
    //if([T2_B2 getActionByTag:21]==nil)
    //{
        frame1= [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ccbResources/Robot/Barrel2 (0).png" ];
        [T2_B2 setSpriteFrame:frame1];
    //}
    T2_B2kontrol=false;
    T2_B1kontrol=false;
    T2_J1Kontrol=false;
    T2_J2Kontrol=false;
    T2_J4Kontrol=false;
    T2_J4Kontrol=false;
}
-(void)hizcarpani
{
    if(!isGamePaused)
    {
        if(can<=0)
            canoteleme=1;
        if(timersure==0)
            [self zaman];
        else if(timersure==5)
            [self zaman2];
        timersure++;
        if(timersure==12)
        {
            _hizsayaci++; //baska timera atılıp timer süresi de carpanla carpılacak.
            timersure=0;
            [_hizTimeri invalidate];
            _hizTimeri=nil;
            _hizTimeri =[NSTimer scheduledTimerWithTimeInterval:1.0*_hizcarpani target:self selector:@selector(hizcarpani) userInfo:nil repeats:YES];
            if(_hizsayaci%2==0 && _hizcarpani>0.3)
            {
                _animasyoncarpani=_animasyoncarpani-0.025f;
                _hizcarpani=_hizcarpani-0.025f;
                [_hizGosterge setPosition:ccp(_hizGosterge.position.x+33.352, _hizGosterge.position.y)];
                [self Animasyonlar];
                
            }
        }
     }
    [self gameover];
}
-(void)arkaplan
{
    if(!isGamePaused)
    {
    if (Background.position.x<=-569.4)
    {
        [Background stopAllActions];
        [Background setPosition:ccp(-2.0, Background.position.y)];
    
    CCActionMoveTo * arkaplan  = [CCActionMoveTo actionWithDuration:50.0*_hizcarpani position:ccp(-569.4,Background.position.y)];
    [Background runAction:arkaplan];
    }
    }
}
-(void)PauseMenu
{

    [pauseMenu setPosition:ccp(0,0)];
    [scoreLabel setVisible:false];
    [_btnPause setVisible:false];
    [self setPaused:true];
    [pauseMenu setVisible:true];
    [scoreLabelpause setString:[NSString stringWithFormat:@"Your Score is : %0.2f", skor]];
    isGamePaused=true;
    
}
-(void)gameover
{
    if(canoteleme==1)
    {
        {
        [T1_S1 stopAllActions];
        [T1_S2 stopAllActions];
        [T1_S3 stopAllActions];
        [T1_S4 stopAllActions];
        [T1_S5 stopAllActions];
        [T1_S6 stopAllActions];
        [T1_S7 stopAllActions];
        [T1_S8 stopAllActions];
        [T1_B1 stopAllActions];
        [_T1_B1 stopAllActions];
        [T1_B2 stopAllActions];
        [_T1_B2 stopAllActions];
        [T1_J1 stopAllActions];
        [T1_J2 stopAllActions];
        [T1_J3 stopAllActions];
        [T1_J4 stopAllActions];
        [T2_S1 stopAllActions];
        [T2_S2 stopAllActions];
        [T2_S3 stopAllActions];
        [T2_S4 stopAllActions];
        [T2_S5 stopAllActions];
        [T2_S6 stopAllActions];
        [T2_S7 stopAllActions];
        [T2_S8 stopAllActions];
        [T2_B1 stopAllActions];
        [_T2_B1 stopAllActions];
        [T2_B2 stopAllActions];
        [_T2_B2 stopAllActions];
        [T2_J1 stopAllActions];
        [T2_J2 stopAllActions];
        [T2_J3 stopAllActions];
        [T2_J4 stopAllActions];
        }
        
        if(!isGamePaused)
        {
            [Robot runAction:deadAnimation];
        }
        if(!isGamePaused)
            [Sounds playBg:@"ccbResources/sounds/GameOver.wav"];
        isGamePaused=1;
        [zemin stopAllActions];
        [Background stopAllActions];
        if([Robot getActionByTag:5]==nil)
        {
            [scoreLabelpause setString:[NSString stringWithFormat:@"Your Score is : %0.2f", skor]];
            [scoreLabel setVisible:false];
            [_btnPause setVisible:false];
            [gameOver setVisible:true];
            [gameOver setPosition:ccp(0,0)];
        }
        
    }
}
-(void)Animasyonlar
{
    runAnimation=     [self AnimasyonEkle :runningDizi   :@"ccbResources/Robot/Run (%d).png"      :1 :8 :running     :0.05f];
    runAnimation.tag=1;
    
    jumpAnimation=    [self AnimasyonEkle :jumpDizi      :@"ccbResources/Robot/Jump (%d).png"     :1 :9 :jump        :0.08f];
    jumpAnimation.tag=3;
    
    dusmeAnimation=   [self AnimasyonEkle :dusmeDizi     :@"ccbResources/Robot/Jump (%d).png"     :5 :9 :dusme       :0.05f];
    dusmeAnimation.tag=12;
    
    shootAnimation=   [self AnimasyonEkle :shootDizi     :@"ccbResources/Robot/RunShoot (%d).png" :1 :9 :shoot       :0.05f];
    [shootAnimation setTag:4];
    
    JumpShootAnimation=   [self AnimasyonEkle :JshootDizi     :@"ccbResources/Robot/JumpShoot (%d).png" :1 :5 :jumpshoot       :0.05f];
    [shootAnimation setTag:6];
    
    deadAnimation=    [self AnimasyonEkle :olmeDizi     :@"ccbResources/Robot/Dead (%d).png" :1 :10 :olme       :0.05f];
    [shootAnimation setTag:5];
    
    BarrelExplosion1= [self AnimasyonEkle :BarrelExp1Dizi :@"ccbResources/Robot/Barrel1 (%d).png"  :0 :5 :Barrel_Exp1 :0.09f];
    [BarrelExplosion1 setTag:20];
    
    BarrelExplosion2= [self AnimasyonEkle :BarrelExp2Dizi :@"ccbResources/Robot/Barrel2 (%d).png"  :0 :7 :Barrel_Exp2 :0.09f];
    [BarrelExplosion2 setTag:21];
}
-(void)_btnPause:(id)sender
{
    NSLog(@"btnPause");
    [self PauseMenu];
}
-(void)_btnResume:(id)sender
{
    [_btnPause setVisible:true];
    [scoreLabel setVisible:true];
    [pauseMenu setPosition:ccp(650,0)];
    [self setPaused:false];
    [pauseMenu setVisible:false];
    isGamePaused=false;
}
-(void)_btnRetry:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Level3"]];
}


@end 

