
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level3 : CCScene {
    
   // NSTimer* timer;
   // NSTimer* timer2;
        int timersure;
    NSTimer* scoretimer;
    NSTimer* _hizTimeri;
        int _hizsayaci;
        float _hizcarpani;
        float _animasyoncarpani;
    
    BOOL bulletReady;
    BOOL ziplamaHazir;
    BOOL ilkbasamakdami;
    BOOL ikincibasamakdami;
    BOOL ucuncubasamakdami;
    
    BOOL T1_B1kontrol;
    BOOL T1_B2kontrol;
    BOOL T2_B1kontrol;
    BOOL T2_B2kontrol;

    CCActionMoveTo *backGroundMove;
    CCActionMoveTo *backGroundMove2;
    
    CCLabelTTF *scoreLabel;
    float skor;
    int can;
    int canoteleme;
    
    CCSprite * Background;
    
    CCSprite * zemin;
    CCSprite * Robot;
    CCSprite * bullet;
    CCSprite * cali1;
    CCSprite * cali2;
    CCSprite * can1;
    CCSprite * can2;
    CCSprite * can3;
    CCSprite * yer6;
    
    
    CCSprite * T1_J1;
    CCSprite * T1_J2;
    CCSprite * T1_J3;
    CCSprite * T1_J4;
    
    CCSprite * T2_J1;
    CCSprite * T2_J2;
    CCSprite * T2_J3;
    CCSprite * T2_J4;
    
    CCSprite * T1_B1;
    CCSprite * T1_B2;
    CCSprite * T2_B1;
    CCSprite * T2_B2;
    
    //Timer-1 için şekiller
    CCNode * T1_S1;
    CCNode * T1_S2;
    CCNode * T1_S3;
    CCNode * T1_S4;
    CCNode * T1_S5;
    CCNode * T1_S6;
    CCNode * T1_S7;
    CCNode * T1_S8;
    
    CCNode * T2_S1;
    CCNode * T2_S2;
    CCNode * T2_S3;
    CCNode * T2_S4;
    CCNode * T2_S5;
    CCNode * T2_S6;
    CCNode * T2_S7;
    CCNode * T2_S8;
    
    
    CCNode * _T1_B1; //Çarpışma kontrolü için
    CCNode * _T1_B2;
    CCNode * _T2_B1; //Çarpışma kontrolü için
    CCNode * _T2_B2;
    
    BOOL T1_J1Kontrol;
    BOOL T1_J2Kontrol;
    BOOL T1_J3Kontrol;
    BOOL T1_J4Kontrol;
    
    BOOL T2_J1Kontrol;
    BOOL T2_J2Kontrol;
    BOOL T2_J3Kontrol;
    BOOL T2_J4Kontrol;
    
    OALSimpleAudio *Sounds;
    
    CCNode * _CarpismaKontrol;
    
    NSMutableArray * runningDizi;
    CCAnimation* running;
    
    NSMutableArray * dusmeDizi;
    CCAnimation* dusme;
    
    NSMutableArray * olmeDizi;
    CCAnimation* olme;
    
    NSMutableArray* jumpDizi;
    CCAnimation* jump;
    
    NSMutableArray* idlingDizi;
    CCAnimation* idling;
    
    NSMutableArray * shootDizi;
    CCAnimation* shoot;
    
    NSMutableArray *JshootDizi;
    CCAnimation* jumpshoot;
    
    NSMutableArray * BarrelExp1Dizi;
    CCAnimation* Barrel_Exp1;
    
    NSMutableArray * BarrelExp2Dizi;
    CCAnimation* Barrel_Exp2;
    
    NSInteger sayac;
    
    CCPhysicsNode * _physicsNode;
    
    int denemesayac;
    CCButton * _btnZipla;
    CCButton * _btnJump2;
    CCButton * _btnMeleeAttack;
    CCButton * _btnPause;
    
    CCScene *_layer;
    
    CCNode *_hizGosterge;
    
    CCActionAnimate * deadAnimation;
    CCActionAnimate * runAnimation;
    CCActionAnimate * idleAnimation;
    CCActionAnimate * jumpAnimation;
    CCActionAnimate * shootAnimation;
    CCActionAnimate * JumpShootAnimation;
    CCActionAnimate * dusmeAnimation;
    CCActionAnimate * BarrelExplosion1;
    CCActionAnimate * BarrelExplosion2;
    
    
    //PauseMenu
    BOOL isGamePaused;
    CCNode * pauseMenu;
    CCNode * gameOver;
    CCLabelTTF * scoreLabelpause;
}

+(Level3 *)scene;
-(id)init;


@end
