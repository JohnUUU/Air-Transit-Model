#lang forge "fp" "whbjcaydktq4qa5f@gmail.com"
option problem_type temporal
option min_tracelength 1
option max_tracelength 20

sig Plane {
    var timeInFlight: lone Int, // Time that the plane has been in flight
    maxFlightTime: one Int, // Maximum amount of time that the plane can be in flight, e.g. due to fuel constraints
    flying: lone Airport -> Airport // Whether or not the plane is Flying and if so from what SRC to DEST
}

sig Runway {
    airport : one Airport, // Airport of the runway 
    var activeplanes: set Plane // Active Planes on the Runway 
 }

sig Airport {
    runways : set Runway, // Runways in the Airport
    var airplanes: set Plane, // Planes currently in the Airport
    minFlightTime: set Airport -> Int, // Minimum amount of time to fly to Destination Airport, e.g. Travel distance 
}

pred wellFormed {

    // There exists a Minimum time to fly between all Airports except for from an Airport to Itself. 
    all a1, a2: Airport | {
        (a1 != a2) => {
            some a1.(a2.minFlightTime)
        } else {
            no a1.(a2.minFlightTime)
        }
    }
    
    // A Plane cannot fly to itself
    all a : Airport {
        (a -> a) not in Plane.flying
    }
    
    all minft : Airport.(Airport.minFlightTime) {
        // Min and Max Flight Times should be greater than zero. 
        minft > 0

        // MinFlightTime of a Plane is always less than maxFlightTime 
        minft < p.maxFlightTime
    }


    // The Runways and Airports must coincide 
    all r : Runway | {
        r in r.airport.runways
    }
    
    // If a Plane is in a Runway it must be in the runway's Airport 
    all p : Plane | {
        p in Runway.activeplanes => p in Runway.airport.airplanes
        some p.flying iff some p.timeInFlight
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


run { init } for exactly 6 Plane, exactly 4 Runway, exactly 2 Airport

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