#lang forge/bsl "cm" "whbjcaydktq4qa5f@gmail.com"


sig Plane {
    var runway: lone Runway, // Runway that the plane is currently at
    var timeInFlight: lone Integer, // Time that the plane has been in flight
    var minFlightTime: one Integer, // Minimum amount of time that the plane can be in flight, e.g. Travel distance 
    maxFlightTime: one Integer // Maximum amount of time that the plane can be in flight, e.g. due to fuel constraints
}

sig Runway {
    var planes : set Plane
}

sig Airport {
    runways : set Runway
    var planesInFlight: set Plane
}

pred wellFormed {
    all p : Plane | {
        // MinFlightTime of a Plane is always less than maxFlightTime 
        p.minFlightTime < p.maxFlightTime

        // Min and Max Flight Times should be greater than zero. 
        p.minFlightTime > 0 
        p.maxFlightTime > 0

        // If Planes are not currently in flight, time in Flight is None
        (p in Airport.planesInFlight) iff {
            no p.timeInFlight
        }
    }
}

pred init {
    // Wellformedness 
    wellFormed

    // Runways start with no planes 
    all r : Runway {
        some r.planes
    }

    // Airports have at least 1 runway and no planes in flight
    all a : Airport {
        some a.runways
        no a.planesInFlight
    }

    // Planes are in stationary mode
    all p: Plane {
        stationary[p]
    }
}

pred stationary[p : Plane] {
    // Plane is not currently in Flight 
    p.inFlight = NotFlying 

    // Plane is not currently in the runway 
    no p.runway 

    // timeInFlight is None 
    no p.timeInFlight 
}

pred available[r : Runway] {
    // TODO: FIll out 
}

pred stationaryToTakeoff[p : Plane, r : Runway] {
    stationary[p] 
    available[r]

    // Plane is still not in Flight 
    Airport.planesInFlight' =  Airport.planesInFlight
    
    // Plane is ready in the runway 
    p.runway' = r 
    r.planes' = r.planes + p 

    // timeinFlight is still None 
    no p.timeInFlight'
}







