# This is One Acre

A simple website that overlays a box the size of an acre on a map. An experiment with [Pure CSS](http://purecss.io/), [Leaflet.js](http://leafletjs.com/) and [Mapbox](https://www.mapbox.com/).

## Setup

Requirements:

- Node.js & NPM
- Ruby

1. Install the required packages:
  ```
  npm install
  gem install foreman
  ```
2. Build the CSS
  ```
  npm run buildcss
  ```
3. Start the server and watch for changes in the Javascript:
  ```
  foreman start
  ```
4. Visit the site at http://localhost:8000