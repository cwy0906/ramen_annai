import { Controller } from "stimulus"
export default class extends Controller {
   
    dashBarReset(){
        document.getElementById("serch_dashBar_01").className = ""
        document.getElementById("serch_dashBar_02").className = ""  
    }

    showDashBar01(){
        this.dashBarReset()
        document.getElementById("serch_dashBar_01").className = "ribbon-bar-line"
    } 

    showDashBar02(){
        this.dashBarReset()
        document.getElementById("serch_dashBar_02").className = "ribbon-bar-line"
    }

}
