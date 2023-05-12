#lang forge "fp" "whbjcaydktq4qa5f@gmail.com"
option problem_type temporal
option min_tracelength 3
option max_tracelength 20

sig Plane {
    var timeInFlight: lone Int, // Time that the plane has been in flight
    maxFlightTime: one Int, // Maximum amount of time that the plane can be in flight, e.g. due to fuel constraints
    flying: lone Airport -> Airport, // Whether or not the plane is Flying and if so from what SRC to DEST
    var location: lone Airport // Which Airport the Plane is currently at 
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
    
    // A Plane should not fly to itself
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

    // An airport can only have 1 min flight time to all other airports 
    all a1, a2 : Airport {
        a1 != a2 => {
            one a2.(a1.minFlightTime)
        }
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

pred onRunway[p: Plane]{
    // Plane is not currently in Flight 
    p not in flying.Airport.Airport

    // Plane is currently in the runway 
    p in Runway.activeplanes

    // timeInFlight is None 
    no p.timeInFlight 

    // Plane is in an Airport 
    one p.location
}

pred inAir[p: Plane]{
    // Plane is flying from src to dest 
    some src, dest: Airport |  {
        p.flying = src -> dest
    }

    // timeInFlight is active
    some p.timeInFlight 

    // Plane is not in an Airport 
    no p.location

    // Plane is not in a runway 
    p not in Runway.activeplanes'
}


pred init {
    // Wellformedness 
    wellFormed

    // Runways start with no planes 
    no Runway.activeplanes

    // Planes are in stationary mode
    all p: Plane {
        // if is in the airport then it is stationary
        stationary[p]
    }
}

pred someRunwayAvailable[p : Plane, a : Airport] {
    some r : airport.a | {
        no r.activeplanes
    }
}

pred stationaryToOnRunway[p : Plane] {

    -- Guard 
    // wellFormed
    stationary[p] 
    someRunwayAvailable[p, p.location]

    -- Transition 
    // Plane is still not in Flight 
    p not in flying.Airport.Airport'
    
    // Plane is ready in the runway 
    some r : airport.(p.location) | {
        no r.activeplanes
        r.activeplanes' = r.activeplanes + p
    }

    // timeinFlight is still None 
    no p.timeInFlight'

    // Plane is in an Airport 
    one p.location'
}

pred onRunwayToInAir[p : Plane] {
    -- Guard
    onRunway[p]

    -- Transition 
    // Plane flies from current Airport to some destination
    some dest: Airport |  {
        p.flying' = p.location -> dest
    }
    p.timeInFlight' = 0

    // Plane leaves the runway
    p not in Runway.activeplanes'

    // Plane leaves the airport
    no p.location'
}

pred readyToLand[p: Plane] {
    some src, dest: Airport | {
        p.flying = src -> dest
        someRunwayAvailable[p, dest]
        p.timeInFlight >= dest.(src.minFlightTime)
    }
}

pred inAirToOnRunway[p : Plane] {
    -- Guard 
    inAir[p]
    readyToLand[p]

    -- Transition 
    

    // Plane enters the airport 
    some src, dest: Airport | {
        p.flying = src -> dest
        p.location' = dest

        // Plane enters the runway 
        some r : airport.dest | {
            no r.activeplanes
            r.activeplanes' = r.activeplanes + p
        }

    }

    // Plane stops flying 
    p not in flying.Airport.Airport'
    no p.timeInFlight'
}

pred onRunwayToStationary[p : Plane] {
    -- Guard 
    onRunway[p]

    -- Transition 
    
    // Plane is still not in Flight 
    p not in flying.Airport.Airport'
    
    // Plane leaves the runway
    p not in Runway.activeplanes'

    // timeinFlight is still None 
    no p.timeInFlight'

    // Plane is in an Airport 
    one p.location'
}

pred keepInAir[p: Plane] {
    // Plane stays in flight 
    p.flying' = p.flying 

    // Plane is still not in an airport
    no p.location' 

    // Plane does not enter a runway 
    p not in Runway.activeplanes'

    // Time in flight increments by 1
    p.timeInFlight' = add[p.timeInFlight, 1]
}

pred keepInRunway[p: Plane] {
    // Plane is not currently in Flight 
    p not in flying.Airport.Airport'

    // Plane stays in runway 
    (activeplanes.p -> p) in activeplanes'

    // timeInFlight is None 
    no p.timeInFlight'

    // Plane is in an Airport 
    one p.location'
}

pred doNothing[p: Plane]{
    inAir[p] => {
        keepInAir[p]
    }
    onRunway[p] => {
        keepInRunway[p]
    }
    stationary[p] => {
        next_state stationary[p]
    }
}

pred noCrashes{
    // at most one plane in a runway
    all r : Runway {
        lone r.activeplanes
    }
}

pred traces{
    init
    always wellFormed
    always noCrashes // Ideally try to replace this with some registration system maybe? 
    always {all p: Plane | stationaryToOnRunway[p] or onRunwayToInAir[p] or inAirToOnRunway[p] or onRunwayToStationary[p] or doNothing[p]}
    // eventually {some p: Plane | onRunway[p]}
    eventually {some p: Plane | stationaryToOnRunway[p]}
}

run { 
    traces
} for exactly 6 Plane, exactly 4 Runway, exactly 2 Airport, 5 Int