//
//  MapViewController.m
//  ArashKashi
//
//  Created by Arash Kashi on 30.01.22.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "POIAnnotationView.h"
#import "POIAnnotation.h"

@class POI;

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_mapView.delegate = self;
	
	[_mapView registerClass:[POIAnnotationView class] forAnnotationViewWithReuseIdentifier:NSStringFromClass([POIAnnotationView class])];	
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	NSString* reuseIdentifier = NSStringFromClass([POIAnnotationView class]);
	
	// TODO: There seem to be a bug the car icon does not appear.
	UIImage *carImage = [UIImage systemImageNamed:@"car"];
	MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier forAnnotation:annotation];
	annotationView.image = carImage;

	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	POIAnnotation *annotation = (POIAnnotation *)view.annotation;
	[self.delegate onAnnotationSelected: annotation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	[self.delegate onRegionChanged: mapView];
}

// TODO: annotations to be added are in two groups: either exist already on map view, or they are new. The old ones needs to be removed and then updated with the latest ones, and the new ones are simply added.
-(void)addMapAnnotations:(NSArray<POIAnnotation*>*)annotations {
	NSArray<id<MKAnnotation>>* currentAnnotations = _mapView.annotations;
	[_mapView removeAnnotations:currentAnnotations];
	[_mapView addAnnotations:annotations];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
