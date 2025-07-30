<!DOCTYPE html>
<html>
<head>
  <title>Google Maps - All Features</title>
  <style>
    #map {
      height: 500px;
      width: 100%;
    }
    #info {
      margin-top: 10px;
      font-family: Arial, sans-serif;
    }
    button {
      margin: 5px;
      padding: 8px 16px;
      font-size: 16px;
    }
    input {
      margin: 5px;
      padding: 8px;
      font-size: 14px;
      width: 300px;
    }
  </style>
</head>
<body>
  <h2>Google Maps: User Location, Route & Nearest Marker</h2>

  <button id="findMe">Find My Location & Nearest Place</button><br>
  <input type="text" id="source" placeholder="Enter Source Location">
  <input type="text" id="dest" placeholder="Enter Destination Location">
  <button onclick="calculateRoute()">Get Directions & Nearest Marker</button>

  <div id="map"></div>
 						 <!-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< for showing km >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-->
   <!-- <div id="info"></div>  -->

  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAIjEvgNfeTQfrZdTyAJaJfMovpVYg6fkQ&libraries=places&callback=initMap" async></script>
  <script>
    let map, userMarker, infoWindow, directionsService, directionsRenderer;
    let markers = [];

    const markerData = [
      { title: "Place A (Delhi)", position: { lat: 28.6139, lng: 77.2090 } },
      { title: "Place B (Ranchi)", position: { lat: 23.34316, lng: 85.3094 } },
      { title: "Place C (Dhanbad)", position: { lat: 23.80199, lng: 86.44324 } },
      { title: "Place D (Chennai)", position: { lat: 13.0827, lng: 80.2707 } },
      { title: "Place E (Bokaro)", position: { lat: 23.669296, lng: 86.151112 } },
      { title: "Place Namkum (Namkum)", position: { lat: 23.33235, lng: 85.380791 } },
      { title: "Place katatoli (katatoli)", position: { lat: 23.364593519621, lng:  85.3503915079629 } },
      { title: "Place hazaribag (hazaribag)", position: { lat:23.99241000, lng: 85.36162000 } },
      { title: "Place patratu(patratu)", position: { lat:23.6366954, lng: 85.2724544 } },
      { title: "Place gaya(Gaya)", position: { lat:24.7969, lng: 85.0039 } }
    ];

    function initMap() {
      map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: 23.2599, lng: 77.4126 },
        zoom: 6,
        scrollwheel: true,
      });

      infoWindow = new google.maps.InfoWindow();
      directionsService = new google.maps.DirectionsService();
      directionsRenderer = new google.maps.DirectionsRenderer({ map });

      markerData.forEach((data, i) => {
        const marker = new google.maps.Marker({
          position: data.position,
          map: map,
          title: data.title,
          label: String.fromCharCode(65 + i),
        });

        marker.addListener("click", () => {
          infoWindow.setContent(`<b>${data.title}</b><br>Lat: ${data.position.lat}<br>Lng: ${data.position.lng}`);
          infoWindow.open(map, marker);
        });

        markers.push(marker);
      });

      new google.maps.places.Autocomplete(document.getElementById("source"));
      new google.maps.places.Autocomplete(document.getElementById("dest"));
      document.getElementById("findMe").onclick = getUserLocation;
    }

    function getUserLocation() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position) => {
          const userPos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          if (userMarker) userMarker.setMap(null);

          userMarker = new google.maps.Marker({
            position: userPos,
            map: map,
            title: "Your Location",
            icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
          });

          map.setCenter(userPos);
          findNearestMarker(userPos);

        }, () => {
          alert("Geolocation failed.");
        });
      } else {
        alert("Geolocation not supported.");
      }
    }

    function haversineDistance(pos1, pos2) {
      function toRad(x) { return x * Math.PI / 180; }
      const R = 6371;
      const dLat = toRad(pos2.lat - pos1.lat);
      const dLng = toRad(pos2.lng - pos1.lng);
      const a = Math.sin(dLat/2)**2 + Math.cos(toRad(pos1.lat)) * Math.cos(toRad(pos2.lat)) * Math.sin(dLng/2)**2;
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c;
    }

    function findNearestMarker(pos) {
      let nearest = null;
      let minDist = Infinity;
      let distancesHtml = "<b>Distances:</b><ul>";

      markers.forEach((marker) => {
        const markerPos = marker.getPosition().toJSON();
        const dist = haversineDistance(pos, markerPos);
        distancesHtml += `<li>${marker.getTitle()}: ${dist.toFixed(2)} km</li>`;
        if (dist < minDist) {
          minDist = dist;
          nearest = marker;
        }
        marker.setIcon(null);
      });

      distancesHtml += "</ul>";

      if (nearest) {
        nearest.setIcon("http://maps.google.com/mapfiles/ms/icons/green-dot.png");
        distancesHtml += `<b>Nearest place:</b> ${nearest.getTitle()} (${minDist.toFixed(2)} km)`;
        drawRoute(pos, nearest.getPosition().toJSON());
      }

      document.getElementById("info").innerHTML = distancesHtml;
    }

    function drawRoute(from, to) {
      directionsService.route(
        {
          origin: from,
          destination: to,
          travelMode: google.maps.TravelMode.DRIVING,
        },
        (response, status) => {
          if (status === "OK") {
            directionsRenderer.setDirections(response);
          } else {
            alert("Directions request failed: " + status);
          }
        }
      );
    }

    function calculateRoute() {
      const source = document.getElementById("source").value;
      const dest = document.getElementById("dest").value;

      if (!source || !dest) {
        alert("Please enter both source and destination.");
        return;
      }

      directionsService.route({
        origin: source,
        destination: dest,
        travelMode: 'DRIVING'
      }, (result, status) => {
        if (status === 'OK') {
          directionsRenderer.setDirections(result);

          const route = result.routes[0].overview_path;
          let nearest = null;
          let minDist = Infinity;

          markers.forEach((marker) => {
            marker.setIcon(null); // reset icons
            const markerPos = marker.getPosition().toJSON();

            route.forEach(routePoint => {
              const dist = haversineDistance(markerPos, { lat: routePoint.lat(), lng: routePoint.lng() });
              if (dist < minDist) {
                minDist = dist;
                nearest = marker;
              }
            });
          });

          if (nearest) {
            nearest.setIcon("http://maps.google.com/mapfiles/ms/icons/green-dot.png");
            document.getElementById("info").innerHTML = `<b>Nearest marker to route:</b> ${nearest.getTitle()} (${minDist.toFixed(2)} km)`;
          }
        } else {
          alert("Route calculation failed: " + status);
        }
      });
    }
  </script>
</body>
</html>
