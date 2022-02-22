//
//  POIAnnotation.m
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

#import "POIAnnotation.h"

@interface POIAnnotation ()

@property (nonatomic, readwrite) NSInteger annotationId;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation POIAnnotation


@synthesize annotationId;

+ (instancetype) new:(CLLocationCoordinate2D)coordinate annotationId:(NSInteger)identification
{
	POIAnnotation* annotation = [[self alloc] init];
	annotation.coordinate = coordinate;
	annotation.annotationId = identification;
	return annotation;
}
@end
