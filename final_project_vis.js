
div.replaceChildren()
/// have two backgrounds one for each airport 
// have a flying section
/// at each airport have a section that is the runway and a not runway section 

// Defining Sigs and Fields 
const airports = instance.signature('Airport').atoms()


/// creating planes
const plane = "https://static.vecteezy.com/system/resources/previews/014/455/865/non_2x/plane-icon-icon-on-transparent-background-free-png.png"

function make_plane(url) {
    const img = document.createElement('img')
    img.src = url
    img.style.width = '100%'
    img.style.height = '15%'
    img.style.display = 'block'
    // img.style['margin-bottom'] = '10%'

    return img;
}

function make_airport(title) {
    var airportDiv = document.createElement('div')
    airportDiv.style.width = '60%'
    airportDiv.style.height = '15%'
    var titleDiv = document.createElement('div')
    titleDiv.textContent = title
    titleDiv.style.textAlign = 'center';
    titleDiv.style.fontWeight = 'bold';
    titleDiv.style.fontSize = '24px';
    airportDiv.appendChild(titleDiv);
    const img = make_plane('https://img.freepik.com/free-photo/white-texture_1160-786.jpg?w=1800&t=st=1683867094~exp=1683867694~hmac=75f16b025327b29462bfa9c028fa0d8416cba3dd6bff4b157479eed2e2256ec1')
    img.style.opacity = '100%'
    img.style.height = '75px'
    airportDiv.appendChild(img)
    return airportDiv;
}

function make_runway() {
    const div = make_plane('https://w0.peakpx.com/wallpaper/925/1021/HD-wallpaper-black-background-blue-colors-dark-gray-green-grey-plain-solid.jpg')
    div.style.opacity = '0%'
    return div;
}

function make_sky() {
    const div = make_plane('https://www.solidbackgrounds.com/images/950x350/950x350-sky-blue-solid-color-background.jpg')
    div.style.opacity = '0%'
    return div;
}

// // combine the airport and runway horizontally
// function make_airport_runway() {
//     const airport = make_airport()
//     const runway = make_runway()
//     const div = document.createElement('div')
//     div.style.display = 'flex'
//     div.style.flexDirection = 'row'
//     div.style.justifyContent = 'space-between'
//     div.appendChild(airport)
//     div.appendChild(runway)
//     return div;
// }

// // combine airport_runways, sky, and aiport runway vertically
// function make_airport_runway_sky() {
//     const airport_runway = make_airport_runway()
//     const sky = make_sky()
//     const div = document.createElement('div')
//     div.style.display = 'flex'
//     div.style.flexDirection = 'column'
//     div.style.justifyContent = 'space-between'
//     div.appendChild(airport_runway)
//     div.appendChild(sky)
//     return div;
// }



for (const idx in airports) {
    const title = airports[idx].toString()
    div.appendChild(make_airport(title))

}


// const mft = instance.field('minFlightTime')
// for (const idx1 in airports) {
//     for (const idx2 in airports) {
//         const minTime = airports[idx2].join(airports[idx1].join(mft)).toString()
//         if (minTime) {
//             console.log(minTime)
//         }
//     }
// }
