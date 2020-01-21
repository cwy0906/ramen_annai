import { Controller } from "stimulus"
export default class extends Controller {

    initialize()  {
      this.showComments();  
    }
    
    showMap() {
        fetch(this.data.get("map-url"))   
        .then(response => response.text())
        .then(html => {        
            document.getElementById("output").innerHTML = html          
            let mapLat = document.getElementById("mapLat").innerHTML
            let mapLng = document.getElementById("mapLng").innerHTML
            this.triggerClassNameReset();
            document.getElementById("gmap_trigger").className = "card-footer-item card-footer-item-chose"
            initMap(mapLat , mapLng );
            
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

        });    
    }

    showComments() {
      fetch(this.data.get("comments-url"))
      .then(response => response.text())
      .then(html => {  
        document.getElementById("output").innerHTML = html 
        this.triggerClassNameReset()

        document.getElementById("comments_trigger").className = "card-footer-item card-footer-item-chose"
      })
    }

    showMenu() {
      fetch(this.data.get("menu-url"))
      .then(response => response.text())
      .then(html => {  
        document.getElementById("output").innerHTML = html 
        this.triggerClassNameReset()

        document.getElementById("menu_trigger").className = "card-footer-item card-footer-item-chose"
      })
    }

    showAlbum() {
      fetch(this.data.get("album-url"))
      .then(response => response.text())
      .then(html => {  
        document.getElementById("output").innerHTML = html 
        this.triggerClassNameReset()

        document.getElementById("album_trigger").className = "card-footer-item card-footer-item-chose"
      })
    }

    triggerClassNameReset() {
      document.getElementById("comments_trigger").className = "card-footer-item"
      document.getElementById("menu_trigger").className    = "card-footer-item"
      document.getElementById("album_trigger").className   = "card-footer-item"
      document.getElementById("gmap_trigger").className    = "card-footer-item"
    }

}    
