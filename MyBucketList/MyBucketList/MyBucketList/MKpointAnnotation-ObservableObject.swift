//
//  MKpointAnnotation-ObservableObject.swift
//  MyBucketList
//
//  Created by EO on 06/09/21.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        
        set{
            subtitle = newValue
        }
    
    }
    
}
