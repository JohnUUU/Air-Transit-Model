#lang forge "fp" "whbjcaydktq4qa5f@gmail.com"
option problem_type temporal
option min_tracelength 1
option max_tracelength 5


sig Plane {
    //var runway: lone Runway, // Runway that the plane is currently at
    var timeInFlight: lone Int, // Time that the plane has been in flight
    var minFlightTime: one Int, // Minimum amount of time that the plane can be in flight, e.g. Travel distance 
    maxFlightTime: one Int // Maximum amount of time that the plane can be in flight, e.g. due to fuel constraints
}

// sig Runway {
//     var planes : set Plane
// }

// sig Airport {
//     runways : set Runway
// }

sig Globe {
    var planesInFlight: set Int
    
}

// pred wellFormed {
//     all p : Plane | {
//         // MinFlightTime of a Plane is always less than maxFlightTime 
//         p.minFlightTime < p.maxFlightTime

//         // Min and Max Flight Times should be greater than zero. 
//         p.minFlightTime > 0 
//         p.maxFlightTime > 0

//         // If Planes are not currently in flight, time in Flight is None
//         (p in Globe.planesInFlight) iff {
//             no p.timeInFlight
//         }
//     }
// }

// pred init {
//     // Wellformedness 
//     wellFormed

//     // Runways start with no planes 
//     all r : Runway {
//         some r.planes
//     }

//     // Airports have at least 1 runway and no planes in flight
//     all a : Airport {
//         some a.runways
//     }
//     no Globe.planesInFlight

//     // Planes are in stationary mode
//     all p: Plane {
//         stationary[p]
//     }
// }

// run { init } for 4 Plane, 1 Runway, 1 Airport

// pred stationary[p : Plane] {
//     // Plane is not currently in Flight 
//     p not in Globe.planesInFlight

//     // Plane is not currently in the runway 
//     no p.runway 

//     // timeInFlight is None 
//     no p.timeInFlight 
// }

// pred available[r : Runway] {
//     // TODO: FIll out 
//     no r.planes
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