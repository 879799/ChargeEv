<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Map - Manage Markers</title>
  <style>
    #map {
      height: 500px;
      width: 100%;
    }
    input, button {
      margin: 10px 0;
      padding: 8px;
      font-size: 16px;
    }
  </style>
</head>
<body>
<h2>Admin Panel - Add Markers</h2>
<input type="text" id="name" placeholder="Enter marker name">
<button onclick="saveMarker()">Save Marker</button>
<div id="map"></div>

<%
    String action = request.getParameter("action");
    if ("save".equals(action)) {
        String name = request.getParameter("name");
        String latStr = request.getParameter("lat");
        String lngStr = request.getParameter("lng");

        if (name != null && latStr != null && lngStr != null) {
            try {
                double lat = Double.parseDouble(latStr);
                double lng = Double.parseDouble(lngStr);

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/charge_ev", "root", "Admin@123A");

                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO markers (name, lat, lng) VALUES (?, ?, ?)");
                pstmt.setString(1, name);
                pstmt.setDouble(2, lat);
                pstmt.setDouble(3, lng);
                pstmt.executeUpdate();

                conn.close();
                out.print("Marker saved successfully!");
                return;
            } catch (Exception e) {
                out.print("Database Error: " + e.getMessage());
                return;
            }
        } else {
            out.print("Missing parameters.");
            return;
        }
    }
%>

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAIjEvgNfeTQfrZdTyAJaJfMovpVYg6fkQ&callback=initMap" async defer></script>
<script>
  let map, marker;

  function initMap() {
    map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 23.2599, lng: 77.4126 },
      zoom: 6
    });

    map.addListener("click", (e) => {
      if (marker) {
        marker.setMap(null);
      }
      marker = new google.maps.Marker({
        position: e.latLng,
        map: map
      });
      map.panTo(e.latLng);
      marker.lat = e.latLng.lat();
      marker.lng = e.latLng.lng();
    });
  }

  function saveMarker() {
    const name = document.getElementById("name").value;
    if (!marker || !name) {
      alert("Please select a location and enter a name.");
      return;
    }

    const lat = marker.lat;
    const lng = marker.lng;

    fetch(`adminMap.jsp?action=save&name={encodeURIComponent(name)}&lat=${lat}&lng=${lng}`)
      .then(res => res.text())
      .then(text => {
        alert(text);
      })
      .catch(err => {
        alert("Fetch error: " + err);
      });
  }
</script>
</body>
</html>
