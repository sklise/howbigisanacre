window.geocoder = L.mapbox.geocoder('sklise.giaje9f5')
window.map = L.mapbox.map('map', 'sklise.giaje9f5').setView([40.7280, -73.9453], 20);

# Radius of earth in meters
R = 6378100
acre_m2 = 4046.86
window.side_of_acre = Math.sqrt(acre_m2)

to_rad = (deg) -> deg * Math.PI / 180
to_deg = (rad) -> rad * 180 / Math.PI
draw_box = (layer, corners) -> L.rectangle(corners).addTo(layer)

# Distance in meters
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

  L.latLng to_deg(lat2), to_deg(lng2)

square_box = (center, side_length) ->
  half_diagonal = Math.sqrt(2 * (side_length/2) * (side_length/2))
  north_west = straight_line(center, half_diagonal, 315)
  south_east = straight_line(center, half_diagonal, 135)

  [north_west, south_east]

map.setZoom 18

fg = L.featureGroup().addTo(map)

draw_acre = (map, layer, side_of_acre) ->
  layer.clearLayers()
  draw_box layer, square_box(map.getCenter(), side_of_acre)

draw_acre(map, fg, side_of_acre)
map.on "move", -> draw_acre(map, fg, side_of_acre)
map.on "zoom", -> draw_acre(map, fg, side_of_acre)
map.on "resize", -> draw_acre(map, fg, side_of_acre)
map.on "viewreset", -> draw_acre(map, fg, side_of_acre)