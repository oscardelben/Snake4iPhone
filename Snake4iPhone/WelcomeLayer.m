//
//  WelcomeLayer.m
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/24/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "WelcomeLayer.h"
#import "SnakeLayer.h"

@implementation WelcomeLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WelcomeLayer *layer = [WelcomeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    self = [super init];
    if (self) 
    {
        CCMenuItem *item = [CCMenuItemFont itemFromString: @"Start Game" target:self selector:@selector(startGame)];
        CCMenu *myMenu = [CCMenu menuWithItems:item, nil];

        [self addChild:myMenu];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)startGame
{
    [[CCDirector sharedDirector] replaceScene:[SnakeLayer scene]];
}


@end
