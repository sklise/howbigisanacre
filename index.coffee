window.$ = require('./jquery');
window.leaflet_draw = require('leaflet-draw')

window.geocoder = L.mapbox.geocoder('sklise.giaje9f5')
window.map = L.mapbox.map('map', 'sklise.giaje9f5').setView([40.7280, -73.9453], 20);

show_map = (err, data) ->

  map.fitBounds(data.lbounds)

  map.locate()

  map.setZoom 18

geocoder.query('New York, NY', show_map)
featureGroup = L.featureGroup().addTo(map);

map.on "locationfound", (event) ->
  map.fitBounds(event.bounds)
  map.setZoom 18
  window.coords = set_box()

set_box = ->
  bounds = map.getBounds()
  padded = bounds.pad(-1.4)
  draw_box(padded)

draw_box = (bounds) ->
  corners = [bounds.getNorthWest(),
    bounds.getNorthEast(),
    bounds.getSouthEast(),
    bounds.getSouthWest(),
    bounds.getNorthWest()
  ]

  center = bounds.getCenter()
  offcenter = bounds.getCenter()
  center.lng = bounds.getCenter().lng+0.003
  offcenter.lng = bounds.getCenter().lng-0.003
  straight_line = [center, offcenter]

  L.polyline(straight_line).addTo(featureGroup)
  polyline = L.polyline(corners).addTo(featureGroup)

  map.on 'draw:control', (e) ->
    featureGroup.addLayer(e.layer)