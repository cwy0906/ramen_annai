import { Controller } from "stimulus"

export default class extends Controller {

    showMap() {
        fetch(this.data.get("map-url"))   
        .then(response => response.text())
        .then(html => {        
            document.getElementById("output").innerHTML = html          
            let mapLat = document.getElementById("mapLat").innerHTML
            let mapLng = document.getElementById("mapLng").innerHTML

            TriggerClassNnmeReset()
            document.getElementById("gmap_trigger").className = "card-footer-item card-footer-item-chose"
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

            function TriggerClassNnmeReset() {
              document.getElementById("comment_trigger").className = "card-footer-item"
              document.getElementById("menu_trigger").className    = "card-footer-item"
              document.getElementById("album_trigger").className   = "card-footer-item"
              document.getElementById("gmap_trigger").className    = "card-footer-item"
            }
        })    
    }

}    
