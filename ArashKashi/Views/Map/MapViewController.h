//
//  MapViewController.h
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "POIAnnotation.h"

@protocol MapViewControllerDelegate <NSObject>
-(void)onAnnotationSelected:(nonnull POIAnnotation *)annotation;
-(void)onRegionChanged:(nonnull MKMapView *)mapView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;


-(void)addMapAnnotations:(NSArray<POIAnnotation*>*)annotations;

@end

NS_ASSUME_NONNULL_END
