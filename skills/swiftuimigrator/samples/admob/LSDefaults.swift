import UIKit

class LSDefaults{
    class Keys{
        static let LaunchCount = "LaunchCount";
        static let AdsTrackingRequested = "AdsTrackingRequested";
        static let LastOpeningAdPrepared = "LastOpeningAdPrepared";
    }
    
    static func increaseLaunchCount(){
        self.LaunchCount = self.LaunchCount.advanced(by: 1);
    }
    
    static var LaunchCount : Int{
        get{
            //UIApplication.shared.version
            return Defaults.integer(forKey: Keys.LaunchCount);
        }
        
        set(value){
            Defaults.set(value, forKey: Keys.LaunchCount);
        }
    }
}

extension LSDefaults{
    static var AdsTrackingRequested : Bool{
        get{
            return Defaults.bool(forKey: Keys.AdsTrackingRequested);
        }
        
        set{
            Defaults.set(newValue, forKey: Keys.AdsTrackingRequested);
        }
    }
}

extension LSDefaults{
    static var LastOpeningAdPrepared : Date{
        get{
            return Defaults.object(forKey: Keys.LastOpeningAdPrepared) as? Date ?? Date.distantPast;
        }
        
        set{
            Defaults.set(newValue, forKey: Keys.LastOpeningAdPrepared);
        }
    }
}
