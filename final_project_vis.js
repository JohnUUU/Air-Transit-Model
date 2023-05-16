div.replaceChildren()
see_specific_state = -1

// Defining Sigs and Fields 
function make_state(instance, idx) {
    console.log("State " + idx)
    var stateDiv = document.createElement('div')
    var stateTitleDiv = document.createElement('div')
    stateTitleDiv.textContent = "State " + idx
    stateTitleDiv.style.textAlign = 'center';
    stateTitleDiv.style.fontWeight = 'bold';
    stateTitleDiv.style.fontSize = '40px';
    stateDiv.appendChild(stateTitleDiv);

    const airports = instance.signature('Airport').atoms()
    const planes = instance.signature('Plane').atoms()
    const runways = instance.signature('Runway').atoms()

    const timeInFlight_f = instance.field('timeInFlight')
    const minFlightTime_f = instance.field('minFlightTime')
    const maxFlightTime_f = instance.field('maxFlightTime')
    const flying_f = instance.field('flying')
    const location_f = instance.field('location')
    const airport_f = instance.field('airport')
    const activeplanes_f = instance.field('activeplanes')


    function make_airport(title) {
        // Overall Airport Div
        var airportDiv = document.createElement('div')

        // TITLE DIV 
        var titleDiv = document.createElement('div')
        titleDiv.textContent = title
        titleDiv.style.textAlign = 'center';
        titleDiv.style.fontWeight = 'bold';
        titleDiv.style.fontSize = '24px';
        airportDiv.appendChild(titleDiv);

        var bodyDiv = document.createElement('div')
        bodyDiv.style.display = 'flex';
        airportDiv.appendChild(bodyDiv);

        // PLYSICAL AIRPORT DIV 
        var physicalDiv = document.createElement('div')
        physicalDiv.style.width = '75%'
        physicalDiv.style.height = '15%'
        bodyDiv.appendChild(physicalDiv)

        // PLANE HANGAR DIV
        var planeHangarDiv = document.createElement('div');
        planeHangarDiv.style.backgroundImage = 'url(https://img.freepik.com/free-photo/white-texture_1160-786.jpg?w=1800&t=st=1683867094~exp=1683867694~hmac=75f16b025327b29462bfa9c028fa0d8416cba3dd6bff4b157479eed2e2256ec1)'
        planeHangarDiv.style.backgroundSize = 'cover';
        planeHangarDiv.style.width = '100%';
        planeHangarDiv.style.display = 'grid';
        planeHangarDiv.style.gridTemplateColumns = 'repeat(3, 1fr)';
        planeHangarDiv.style.gridAutoRows = 'auto';
        planeHangarDiv.style.gridGap = '10px';
        physicalDiv.appendChild(planeHangarDiv);

        // RUNWAY HANGAR DIV
        var runwayHangarDiv = document.createElement('div');
        // runwayHangarDiv.style.backgroundImage = 'url(https://img.freepik.com/free-photo/lines-traffic-paved-roads-background_1150-5989.jpg?w=2000&t=st=1684232203~exp=1684232803~hmac=9877ec9fa1846dc9928760786e3165c0fa83d8e3728196f1cc5fd325e456649f)'
        // runwayHangarDiv.style.backgroundSize = 'cover';
        runwayHangarDiv.style.backgroundColor = '#f2f2f2';
        runwayHangarDiv.style.width = '100%';
        runwayHangarDiv.style.display = 'grid';
        runwayHangarDiv.style.gridTemplateColumns = 'repeat(1, 1fr)';
        runwayHangarDiv.style.gridAutoRows = 'auto';
        runwayHangarDiv.style.gridGap = '10px';
        physicalDiv.appendChild(runwayHangarDiv);

        // SKY DIV (Grid of Planes)
        var skyDiv = document.createElement('div');
        skyDiv.style.background = 'linear-gradient(to bottom, #87CEEB, #B0E0E6)'
        skyDiv.style.width = '25%';
        skyDiv.style.height = '100%'; // Set height to 100%
        skyDiv.style.display = 'grid';
        skyDiv.style.gridTemplateColumns = 'repeat(1, 1fr)';
        skyDiv.style.gridAutoRows = 'auto';
        skyDiv.style.gridGap = '10px';
        bodyDiv.appendChild(skyDiv);

        return [airportDiv, planeHangarDiv, runwayHangarDiv, skyDiv];
    }

    function make_plane(title) {
        var planeDiv = document.createElement('div');
        planeDiv.textContent = title
        planeDiv.style.textAlign = 'center';
        planeDiv.style.fontWeight = 'bold';
        planeDiv.style.fontSize = '24px';
        return [planeDiv]
    }

    function make_runway(title) {
        var runwayDiv = document.createElement('div');
        runwayDiv.textContent = title
        runwayDiv.style.textAlign = 'center';
        runwayDiv.style.fontWeight = 'bold';

        var runwayPlanes = document.createElement('div');
        runwayPlanes.style.fontSize = '24px';
        runwayPlanes.style.display = 'grid';
        runwayPlanes.style.gridTemplateColumns = 'repeat(3, 1fr)';
        runwayPlanes.style.gridAutoRows = 'auto';
        runwayPlanes.style.gridGap = '10px';
        runwayDiv.appendChild(runwayPlanes)

        return [runwayDiv, runwayPlanes]
    }

    const airport_plane_divs = {};
    const airport_runway_divs = {};
    const airport_sky_divs = {};
    for (const idx in airports) {
        const airport = airports[idx]
        const [airport_div, plane_hangar_div, runwayHangarDiv, skyDiv] = make_airport(airport.toString())
        airport_plane_divs[airport.toString()] = plane_hangar_div
        airport_runway_divs[airport.toString()] = runwayHangarDiv
        airport_sky_divs[airport.toString()] = skyDiv
        stateDiv.appendChild(airport_div)
    }

    const runway_plane_divs = {}
    for (const idx in runways) {
        const runway = runways[idx]
        const airport_loc = runway.join(airport_f);
        const [runway_div, runway_planes] = make_runway(runway.toString())
        if (airport_runway_divs[airport_loc.toString()]) {

            airport_runway_divs[airport_loc.toString()].appendChild(runway_div)
        }
        const aplanes = runway.join(activeplanes_f)
        for (const idx in aplanes) {
            const aplane = aplanes[idx]

            if (aplane.toString()) {
                const [aplane_div] = make_plane(aplane.toString())
                runway_plane_divs[aplane.toString()] = aplane_div
                runway_planes.append(aplane_div)
            }

        }
    }
    console.log(runway_plane_divs)

    for (const idx in planes) {
        const plane = planes[idx]
        const airport_loc = plane.join(location_f);
        const [plane_div] = make_plane(plane.toString())
        if (airport_plane_divs[airport_loc.toString()] && !runway_plane_divs[plane.toString()]) {
            airport_plane_divs[airport_loc.toString()].appendChild(plane_div)
        }
        for (const idx in airports) {
            const airport = airports[idx]
            const dest_loc = airport.join(plane.join(flying_f)).toString()
            if (dest_loc) {
                const [sky_div] = make_plane(plane.toString())
                if (airport_sky_divs[dest_loc.toString()]) {
                    airport_sky_divs[dest_loc.toString()].appendChild(sky_div)
                }
            }
        }
    }

    return stateDiv
}

for (const idx in instances) {
    if (see_specific_state == -1 || idx == see_specific_state) {
        const my_instance = instances[idx]
        const state_div = make_state(my_instance, idx)
        div.appendChild(state_div)
    }
}