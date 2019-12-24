import { Controller } from "stimulus"

export default class extends Controller {

    showMap() {
        fetch(this.data.get("map-url"))   
        .then(response => response.text())
        .then(html => {        
            document.getElementById("output").innerHTML = '<div class="subtitle">透過GoogleMap定位</div><p> <div id="map" class="Google_map">透過GoogleMap定位</div></p>'          
            let mapLat = document.getElementById("mapLat").innerHTML
            let mapLng = document.getElementById("mapLng").innerHTML
            initMap(mapLat , mapLng )
            
            function initMap(lat, lng) {   
              var myCoords = new google.maps.LatLng(lat, lng);
              var mapOptions = {
              center: myCoords,
              zoom: 14
              }; 
              var map = new google.maps.Map(document.getElementById('map'), mapOptions);
              var marker = new google.maps.Marker({
              position: myCoords,
              map: map
              });
            }
        })    
      }

}    
