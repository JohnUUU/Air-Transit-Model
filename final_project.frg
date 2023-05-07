#lang forge "fp" "whbjcaydktq4qa5f@gmail.com"
option problem_type temporal
option min_tracelength 1
option max_tracelength 5

abstract sig FlyingStatus{}
one sig Flying extends FlyingStatus{}
one sig NotFlying extends FlyingStatus{}


sig Plane {
    var timeInFlight: lone Int, // Time that the plane has been in flight
    minFlightTime: set Airport -> Airport -> Int, // Minimum amount of time that the plane can be in flight, e.g. Travel distance 
    maxFlightTime: one Int, // Maximum amount of time that the plane can be in flight, e.g. due to fuel constraints
    inFlight: one FlyingStatus // Whether or not the plane is Flying 
}

sig Runway {
    airport : one Airport,
    var activeplanes: set Plane
 }

sig Airport {
    runways : set Runway,
    var airplanes: set Plane
}

pred wellFormed {
    all p : Plane | {

        all p: Plane {
            all a1, a2: Airport{
                some a1.(a2.(p.minFlightTime))
            }
        }
        
        all minft : Airport.(Airport.(p.minFlightTime)) {
            // Min and Max Flight Times should be greater than zero. 
            minft > 0

            // MinFlightTime of a Plane is always less than maxFlightTime 
            minft < p.maxFlightTime
        }

        // If Planes are not currently in flight, time in Flight is None
        (p.inFlight = NotFlying) iff {
            no p.timeInFlight
        }

        // The Runways and Airports must coincide 
        all r : Runway | {
            r in r.airport.runways
        }

        // If a Plane is in a Runway it must be in the runway's Airport 
        all p : Plane | {
            p in Runway.activeplanes => p in Runway.airport.airplanes
        }

        all f : FlyingStatus {
            f = Flying or f = NotFlying
        }
    }
}

pred stationary[p : Plane] {
    // Plane is not currently in Flight 
    p.inFlight = NotFlying

    // Plane is not currently in the runway 
    p not in Runway.activeplanes

    // timeInFlight is None 
    no p.timeInFlight 
}


pred init {
    // Wellformedness 
    wellFormed

    // Runways start with no planes 
    no Runway.activeplanes

    // Airports have at least 1 runway and no planes in flight
    all a : Airport {
        some a.runways
    }
    Plane.inFlight = NotFlying

    // All Planes start in an airport 
    all p : Plane | {
        p in Airport.airplanes
    }

    // Planes are in stationary mode
    all p: Plane {
        stationary[p]
    }
}


run { init } for exactly 4 Plane, exactly 2 Runway, exactly 1 Airport

// pred someRunwayAvailable {
//     // TODO: FIll out 
    
// }

// pred stationaryToTakeoff[p : Plane, r : Runway] {
//     stationary[p] 
//     available[r]

//     // Plane is still not in Flight 
//     Airport.planesInFlight' =  Airport.planesInFlight
    
//     // Plane is ready in the runway 
//     p.runway' = r 
//     r.planes' = r.planes + p 

//     // timeinFlight is still None 
//     no p.timeInFlight'
// }