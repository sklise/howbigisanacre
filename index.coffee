
window.geocoder = L.mapbox.geocoder('sklise.giaje9f5')
window.map = L.mapbox.map('map', 'sklise.giaje9f5').setView([40.7280, -73.9453], 20);

# Radius of earth in meters
R = 6378100
acre_m2 = 4046.86
window.side_of_acre = Math.sqrt(acre_m2)

to_rad = (deg) -> deg * Math.PI / 180
to_deg = (rad) -> rad * 180 / Math.PI

# Distance in meters
window.straight_line =  (starting_coords, distance, bearing) ->
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

square_acre = (north_west) ->
  north_east = straight_line(north_west, side_of_acre, 90)
  south_west = straight_line(north_west, side_of_acre, 180)
  south_east = L.latLng(south_west.lat, north_east.lng)

  L.rectangle([
    north_west,
    south_east
  ]).addTo(map)


# draw_box = (corners) ->
  # L.rectangle(corners).addTo(map)

map.setZoom 18
window.coords = square_acre(map.getCenter())