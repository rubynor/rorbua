import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["desc_trunc", "desc_full", "show_more", "show_less"]

    connect() {
        console.log("connected")
    }

    toggleDesc(){
        console.log("toggle")
        console.log('Full desc: ' + this.desc_fullTarget.hidden)
        if (this.desc_truncTarget.hidden)
            this.hideDesc()
        else
            this.showDesc()
    }

    showDesc(){
        console.log("Showing desc")
        this.desc_fullTarget.hidden = false;
        this.desc_truncTarget.hidden = true;
        this.show_lessTarget.hidden = false;
        this.show_moreTarget.hidden = true;
    }

    hideDesc(){
        console.log("hiding desc")
        this.desc_fullTarget.hidden = true;
        this.desc_truncTarget.hidden = false;
        this.show_lessTarget.hidden = true;
        this.show_moreTarget.hidden = false;
    }

    log(){
        console.log("click");
    }

}
