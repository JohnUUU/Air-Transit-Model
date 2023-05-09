#lang forge "fp" "whbjcaydktq4qa5f@gmail.com"
option problem_type temporal
option min_tracelength 1
option max_tracelength 20

sig Plane {
    var timeInFlight: lone Int, // Time that the plane has been in flight
    maxFlightTime: one Int, // Maximum amount of time that the plane can be in flight, e.g. due to fuel constraints
    flying: lone Airport -> Airport, // Whether or not the plane is Flying and if so from what SRC to DEST
    location: lone Airport // Which Airport the Plane is currently at 
}

sig Runway {
    airport : one Airport, // Airport of the runway 
    var activeplanes: set Plane // Active Planes on the Runway 
 }

sig Airport {
    minFlightTime: set Airport -> Int // Minimum amount of time to fly to Destination Airport, e.g. Travel distance 
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
        all p : Plane {
             minft < p.maxFlightTime
        }
    }
    
    // If a Plane is in a Runway it must be in the runway's Airport 
    all p : Plane | {
        all r : Runway | {
            p in r.activeplanes => p.location = r.airport
        }
        some p.flying iff some p.timeInFlight
    }

    // A plane cannot be in multiple runways 
    all p: Plane | {
        lone activeplanes.p
    }

}

pred stationary[p : Plane] {
    // Plane is not currently in Flight 
    p not in flying.Airport.Airport

    // Plane is not currently in the runway 
    p not in Runway.activeplanes

    // timeInFlight is None 
    no p.timeInFlight 

    // Plane is in an Airport 
    one p.location
}


pred init {
    // Wellformedness 
    wellFormed

    // Runways start with no planes 
    no Runway.activeplanes
    no flying

    // Planes are in stationary mode
    all p: Plane {
        stationary[p]
    }
}

pred someRunwayAvailable[p : Plane] {
    some r : airport.(p.location) | {
        no r.activeplanes
    }
}

pred stationaryToTakeoff[p : Plane] {

    -- Guard 
    // wellFormed
    stationary[p] 
    someRunwayAvailable[p]

    -- Transition 
    // Plane is still not in Flight 
    p not in flying.Airport.Airport
    
    // Plane is ready in the runway 
    Runway.activeplanes' = Runway.activeplanes + p 

    // timeinFlight is still None 
    no p.timeInFlight 

    // Plane is in an Airport 
    one p.location
}

pred traces{
    init
    always wellFormed
}

run { 
    traces
    some p : Plane {
        next_state stationaryToTakeoff[p]
    }
} for exactly 6 Plane, exactly 4 Runway, exactly 2 Airport
