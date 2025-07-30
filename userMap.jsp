<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="application/json;charset=UTF-8" %>
<%
    String api = request.getParameter("api");
    if ("list".equals(api)) {
       
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/charge_ev", "root", "Admin@123A");

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM markers");
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        while (rs.next()) {
            if (!first) json.append(",");
            json.append("{\"name\":\"").append(rs.getString("name"))
                .append("\",\"lat\":").append(rs.getDouble("lat"))
                .append(",\"lng\":").append(rs.getDouble("lng")).append("}");
            first = false;
        }
        json.append("]");
        out.print(json.toString());
        conn.close();
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Map View</title>
    <style>
        #map { height: 500px; width: 100%; }
    </style>
</head>
<body>
    <h2>User View: Marked Locations</h2>
    <div id="map"></div>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAIjEvgNfeTQfrZdTyAJaJfMovpVYg6fkQ&callback=initMap" async defer></script>
    <script>
        let map;

        function initMap() {
            map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 23.2599, lng: 77.4126 },
                zoom: 6
            });

            fetch("userMap.jsp?api=list")
                .then(res => res.json())
                .then(data => {
                    data.forEach(marker => {
                        new google.maps.Marker({
                            position: { lat: marker.lat, lng: marker.lng },
                            map: map,
                            title: marker.name
                        });
                    });
                });
        }
    </script>
</body>
</html>
