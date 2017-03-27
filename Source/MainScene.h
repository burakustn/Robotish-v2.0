

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainScene : CCScene
{
    CCButton * okButton;
    CCButton * infoButton;
    CCNode   * infoMenu;
}

+(MainScene*)scene;
-(id)init;

@end
