//
//  GuideMaskTests.m
//  GuideMaskTests
//
//  Created by lifei on 03/18/2019.
//  Copyright (c) 2019 lifei. All rights reserved.
//

@import XCTest;
#import "GuideMask.h"

@interface Tests : XCTestCase

@property (nonatomic, strong) GuideMask *guideMask;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    self.guideMask = [GuideMask shareGuide];
}

- (void)tearDown
{
    self.guideMask = nil;
    [super tearDown];
}

-(void)testShareObj{
    GuideMask *newObj = [GuideMask shareGuide];
    XCTAssertNotNil(newObj, @"GuideMask 新实例创建成功");
    XCTAssertEqual(newObj, self.guideMask,@"GuideMask 为单例");
}

@end

