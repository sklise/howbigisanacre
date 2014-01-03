leaflet_draw = require('leaflet-draw')

# Radius of earth in meters
R = 6378100
acre_m2 = 4046.86
window.side_of_acre = Math.sqrt(acre_m2)

to_rad = (deg) -> deg * Math.PI / 180
to_deg = (rad) -> rad * 180 / Math.PI
draw_box = (layer, corners) -> L.rectangle(corners, {color: "#138400", weight:4}).addTo(layer)

# starting_coords - a latLng object of the starting point for the line
# distance - numerical value of meters for the line
# bearing - angle in degrees for compas bearing of straight line
#
# returns an array of latLng objects of the form [starting_point, ending_point]
straight_line =  (starting_coords, distance, bearing) ->
  b = to_rad bearing
  lat1 = to_rad starting_coords.lat
  lng1 = to_rad starting_coords.lng
  dist = distance/R

  lat2 = Math.asin(Math.sin(lat1) * Math.cos(dist) +
          Math.cos(lat1)*Math.sin(dist)*Math.cos(b) )

  lng2 = lng1 + Math.atan2(Math.sin(b)*Math.sin(dist)*Math.cos(lat1),
         Math.cos(dist)-Math.sin(lat1)*Math.sin(lat2));

  lng2 = (lng2+3*Math.PI) % (2*Math.PI) - Math.PI;

  [starting_coords, L.latLng to_deg(lat2), to_deg(lng2)]

square_box = (center, side_length) ->
  half_diagonal = Math.sqrt(2 * (side_length/2) * (side_length/2))
  north_west = straight_line(center, half_diagonal, 315)[1]
  south_east = straight_line(center, half_diagonal, 135)[1]

  [north_west, south_east]

draw_acre = (m, layer, side_of_acre) ->
  layer.clearLayers()
  draw_box layer, square_box(m.getCenter(), side_of_acre)

# Setup
geocoder = L.mapbox.geocoder('sklise.giaje9f5')
window.map = L.mapbox.map('map', 'sklise.giaje9f5').addControl(L.mapbox.geocoderControl('sklise.giaje9f5')).setView([38.897683, -77.036560], 17);

fg = L.featureGroup().addTo(map)
draw_acre(map, fg, side_of_acre)
map.on "move", -> draw_acre(map, fg, side_of_acre)
map.on "zoomend", -> draw_acre(map, fg, side_of_acre)
map.on "resize", -> draw_acre(map, fg, side_of_acre)
map.on "viewreset", -> draw_acre(map, fg, side_of_acre)

locator = document.getElementById('locator')
if !navigator.geolocation
  locator.innerHTML = "This browser doesn't support geolocation"
else
  locator.onclick = (e) ->
    e.preventDefault()
    e.stopPropagation()
    map.locate()

map.on 'locationfound', (e) ->
  map.fitBounds(e.bounds)
map.on 'locationerror', (e) ->
  locator.innerHTML = "There was an error finding your location."