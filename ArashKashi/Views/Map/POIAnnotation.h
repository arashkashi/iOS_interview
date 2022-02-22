//
//  POIAnnotation.h
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface POIAnnotation : NSObject <MKAnnotation>

// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSInteger annotationId;

+ (instancetype) new:(CLLocationCoordinate2D)coordinate annotationId:(NSInteger)identification;

@end


NS_ASSUME_NONNULL_END
