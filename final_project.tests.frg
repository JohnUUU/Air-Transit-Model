#lang forge
open "final_project.frg"

test expect {
    crashDueToFuel: {
        traces
        eventually {
            some p : Plane {
                inAir[p]
                p.timeInFlight > p.maxFlightTime
            }
        }
    } for exactly 4 Plane, exactly 3 Runway, exactly 3 Airport, 5 Int is sat 

    nonStarvation: {
        traces 
        all p: Plane {
            all a: Airport {
                eventually p.location = a
            }
        }
    } for exactly 4 Plane, exactly 3 Runway, exactly 3 Airport, 5 Int is sat 
}
