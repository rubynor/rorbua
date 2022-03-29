import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["desc_trunc", "desc_full", "show_more", "show_less"]

    toggleDesc(){
        if (this.desc_truncTarget.hidden)
            this.hideDesc()
        else
            this.showDesc()
    }

    showDesc(){
        this.desc_fullTarget.hidden = false;
        this.desc_truncTarget.hidden = true;
        this.show_lessTarget.hidden = false;
        this.show_moreTarget.hidden = true;
        window.scrollTo(0, document.body.scrollHeight);
    }

    hideDesc(){
        this.desc_fullTarget.hidden = true;
        this.desc_truncTarget.hidden = false;
        this.show_lessTarget.hidden = true;
        this.show_moreTarget.hidden = false;
        window.scrollTo(0, 0);
    }

}
