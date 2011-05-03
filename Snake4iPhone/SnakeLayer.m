//
//  SnakeLayer.m
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "SnakeLayer.h"
#import "GameConfig.h"

#define kColumnIndex 0
#define kRowIndex    1
#define kSpriteIndex 2

@interface SnakeLayer (PrivateMethods)

- (void)resetGame;
- (void)advance:(ccTime)dt;
- (void)drawSnake;
- (CCSprite *)snakeCell:(int)column row:(int)row;

@end

// Snake is an ordered array of the form:
// [[column, row, cell], [column, row, cell]]
// where column and row are the x and y coordinates, and cell is a pointer to the CCSprite (so that we can remove it later)

@implementation SnakeLayer

@synthesize snake;
@synthesize direction;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SnakeLayer *layer = [SnakeLayer node];
	
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
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        
        self.isTouchEnabled = YES;
                
        [self resetGame];

        [self schedule:@selector(advance:) interval:1];
    }
    
    return self;
}

- (void)dealloc
{
    [snake release];
    [super dealloc];
}

#pragma mark -

- (CCSprite *)snakeCell:(int)column row:(int)row
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"snake-body.png"];
    
    float x = kCellWidth * column + kXOffset;
    float y = kCellWidth * row + kYOffset;
    
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = CGPointMake(x, y);
    
    return sprite;
}

- (void)resetGame
{    
    self.snake = [NSMutableArray array];
    
    self.direction = kMoveRight;
        
    [self drawSnake];
}

- (void)drawSnake
{
    // Add a new cell in the new direction
    int column;
    int row;
    
    if ([snake count] > 0) 
    {
        column = [[[snake objectAtIndex:0] objectAtIndex:kColumnIndex] intValue];
        row = [[[snake objectAtIndex:0] objectAtIndex:kRowIndex] intValue];
        
        // remove tail of snake
        CCSprite *cell = (CCSprite *)[[snake lastObject] objectAtIndex:kSpriteIndex];
        [cell removeFromParentAndCleanup:YES];
        
        int lastIndex = [snake count] - 1;
        [snake removeObjectAtIndex:lastIndex];
    }
    else // empty snake
    {
        column = 3; // put into a configuration
        row = 5; // put into a configuration
    }


    // Add a new cell in the direction
    switch (self.direction) {
        case kMoveUp:
            column = column;
            row = row + 1;
            break;
        
        case kMoveRight:
            column = column + 1;
            row = row;
            break;
            
        case kMoveDown:
            column = column;
            row = row - 1;
            break;
            
        case kMoveLeft:
            column = column - 1;
            row = row;
            break;
            
        default:
            NSLog(@"nextMovement unknown: %@", self.direction);
            break;
    }
    
    // TODO: check if the new position is valid
    
    // Draw a new cell
    CCSprite *cell = [self snakeCell:column row:row];
    
    // Add information to the snake
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:column], [NSNumber numberWithInt:row], cell, nil];
    [self.snake insertObject:array atIndex:0];
     
    // Draw the cell
    [self addChild:cell];
}


#pragma mark -

- (void)advance:(ccTime)dt
{
    [self drawSnake];    
}

#pragma mark -

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
        
    // TODO: this is incorrect of course
    CCSprite *headCell = (CCSprite *)[[snake objectAtIndex:0] objectAtIndex:kSpriteIndex];
    
    CGPoint cellCenter = CGPointMake(headCell.position.x + kCellWidth / 2, headCell.position.y + kCellWidth / 2);

    BOOL up = location.y > cellCenter.y;
    BOOL right = location.x > cellCenter.x;

    CGPoint normalizedLocation = CGPointMake(abs(location.x - cellCenter.x), abs(location.y - cellCenter.y));
    
    if (up) 
    {
        if (right)
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"top");
                self.direction = kMoveUp;
            }
            else
            {
                NSLog(@"right");
                self.direction = kMoveRight;
            }
        
        } else
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"top");
                self.direction = kMoveUp;
            }
            else
            {
                NSLog(@"left");
                self.direction = kMoveLeft;
            }
        }
    } else
    {
        if (right)
        {

            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"down");
                self.direction = kMoveDown;
            }
            else
            {
                NSLog(@"right");
                self.direction = kMoveRight;
            }
            
        } else
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"down");
                self.direction = kMoveDown;
            }
            else
            {
                NSLog(@"left");
                self.direction = kMoveLeft;
            }
        }
    }
    
}


@end
