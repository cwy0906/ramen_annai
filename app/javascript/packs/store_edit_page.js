$(function(){
    $("#avatar_input").on("change", function(e){
      const file = this.files[0];
      const fr = new FileReader();    
      fr.onload = function (e) {
        $(".preview_region .user-avatar").attr("src",e.target.result);
      };
      fr.readAsDataURL(file);
      $(".preview_region .user-avatar").attr({width:"250", height:"250"});
    })
  }); 