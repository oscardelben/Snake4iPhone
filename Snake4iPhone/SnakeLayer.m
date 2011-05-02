//
//  SnakeLayer.m
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "SnakeLayer.h"
#import "GameConfig.h"
#import "SnakeCell.h"

@interface SnakeLayer (PrivateMethods)

- (void)resetGame;
- (void)removeAllCells;
- (void)advance:(ccTime)dt;
- (void)drawSnake;
- (void)updateCurrentPosition:(int)x andY:(int)y;

@end

@implementation SnakeLayer

@synthesize snake;
@synthesize drawnCells;
@synthesize nextMovement;
@synthesize currentPosition;

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
        
        self.drawnCells = [NSMutableArray array];
        
        // currentPosition is an array that contains the current cell head position: [x, y]
        self.currentPosition = [NSMutableArray array];
        
        [self resetGame];

        [self schedule:@selector(advance:) interval:1];
    }
    
    return self;
}

- (void)dealloc
{
    [snake release];
    [drawnCells release];
    [nextMovement release];
    [currentPosition release];
    [super dealloc];
}

#pragma mark -

- (void)removeAllCells
{
    for (int i = 0; i < [self.drawnCells count]; i++) 
    {
        CCNode *node = (CCNode *)[self.drawnCells objectAtIndex:i];
        [self removeChild:node cleanup:YES];
    }
}

- (void)resetGame
{    
    self.snake = [NSMutableArray array];
    
    // Reset the snake array
    for (int i = 0; i < kColumns; i++) 
    {
        // Add an array that represents rows
        [self.snake insertObject:[NSMutableArray array] atIndex:i];
        
        for (int j = 0; j < kRows; j++) 
        {
            NSMutableArray *row = [self.snake objectAtIndex:i];
            [row insertObject:[NSNumber numberWithBool:NO] atIndex:j];
        }
    }
        
    // Add the first point
    NSMutableArray *column = [self.snake objectAtIndex:10];
    [column insertObject:[NSNumber numberWithBool:YES] atIndex:15];
    
    [self updateCurrentPosition:10 andY:15];
    
    [self drawSnake];
}

- (void)drawSnake
{
    // TODO: check that nextMovement doesn't conflict with the snake or that it raises an error.
    
    [self removeAllCells];
    
    SnakeCell *lastCell = nil; // should be the current head
    
    for (int i = 0; i < kColumns; i++) 
    {
        for (int j = 0; j < kRows; j++) 
        {
            NSMutableArray *row = [self.snake objectAtIndex:i];
            
            BOOL visible = [[row objectAtIndex:j] boolValue];
            
            if (visible)
            {
                SnakeCell *cell = [[SnakeCell alloc] init];
                cell.column = i;
                cell.row = j;

                if (lastCell) {
                    cell.parentCell = lastCell;
                }
                
                [self.drawnCells addObject:cell];
                
                lastCell = cell;
                
                // Draw cell
                
                CCSprite *sprite = [cell spriteRepresentation];
           
                [self addChild:sprite];
            }
        }
    }    
}

- (void)updateCurrentPosition:(int)x andY:(int)y
{
    [currentPosition insertObject:[NSNumber numberWithInt:x] atIndex:0];
    [currentPosition insertObject:[NSNumber numberWithInt:y] atIndex:1];
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
    CCNode *headCell = (CCNode *)[drawnCells objectAtIndex:0];
    
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
                self.nextMovement = [NSNumber numberWithInt:kMoveUp];
            }
            else
            {
                NSLog(@"right");
                self.nextMovement = [NSNumber numberWithInt:kMoveRight];
            }
        
        } else
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"top");
                self.nextMovement = [NSNumber numberWithInt:kMoveUp];
            }
            else
            {
                NSLog(@"left");
                self.nextMovement = [NSNumber numberWithInt:kMoveLeft];
            }
        }
    } else
    {
        if (right)
        {

            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"down");
                self.nextMovement = [NSNumber numberWithInt:kMoveDown];
            }
            else
            {
                NSLog(@"right");
                self.nextMovement = [NSNumber numberWithInt:kMoveRight];
            }
            
        } else
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                NSLog(@"down");
                self.nextMovement = [NSNumber numberWithInt:kMoveDown];
            }
            else
            {
                NSLog(@"left");
                self.nextMovement = [NSNumber numberWithInt:kMoveLeft];
            }
        }
    }
    
}


@end
