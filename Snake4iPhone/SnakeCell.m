//
//  SnakeCell.m
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "SnakeCell.h"
#import "GameConfig.h"

@implementation SnakeCell

@synthesize parentCell;
@synthesize column;
@synthesize row;

- (id)init
{
    self = [super init];
    if (self) 
    {
        //
    }
    
    return self;
}

- (void)dealloc
{
    [parentCell release];
    [super dealloc];
}

- (CCSprite *)spriteRepresentation
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"snake-body.png"];
    
    float x = kCellWidth * column + kXOffset;
    float y = kCellWidth * row + kYOffset;
    
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = CGPointMake(x, y);
    
    return sprite;
}

@end
