import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "audio", "progressbar", "current_time", "total_time" ]

    connect(){
        var audio = this.audioTarget;
        var current_time = this.current_timeTarget;
        var total_time = this.total_timeTarget;
        var progressbar = this.progressbarTarget;
        var autoplay = document.getElementById("autoplay");

        var self = this

        audio.addEventListener("loadedmetadata", function () {

            current_time.innerHTML = display_time(audio.currentTime);
            total_time.innerHTML = display_time(audio.duration);
            progressbar.value = this.currentTime/this.duration;

            audio.addEventListener('timeupdate', function(){
                current_time.innerHTML = display_time(audio.currentTime); // Display ny tid
                progressbar.value = audio.currentTime/audio.duration; // Oppdatere progressbar
            });

            // Når progressbaren blir trykket på for å velge hvor i storyen
            progressbar.addEventListener("click", function (event) {
                var x = event.x;
                var offset = progressbar.offsetLeft+ progressbar.offsetParent.offsetLeft;
                offset += progressbar.offsetParent.offsetParent.offsetLeft
                x -= offset;
                var time = x / progressbar.offsetWidth * audio.duration;
                audio.currentTime = time;
            });

            // Når story er ferdig blir du enten sendt videre eller så blir det displaya at ingenting blir spilt
            audio.onended = function (){
                if(autoplay.checked)
                    setTimeout(function (){
                        document.getElementById("btn-next").click();
                    }, 1000);
                else
                    document.getElementById("button_toggle").innerHTML = "play_arrow";
            }

            self.play();

        })


        // Metode for å displaye tid, men i et fint format, f.eks (0:38 / 2:35)
        function display_time(time){
            var parsedTime = parseInt(time);
            var minutes = parseInt(parsedTime/60)
            var seconds = parsedTime%60;
            if (seconds < 10)
                seconds = "0"+seconds;
            return minutes + ":" + seconds;
        }
    }

    toggle(){
        var player = this.audioTarget;
        if (player.paused) {
            this.play();
        }
        else {
            player.pause()
            document.getElementById("button_toggle").innerHTML = "play_arrow";
        }
    }

    toggle_autoplay(){
        var autoplay = document.getElementById("autoplay");
        document.cookie = "autoplay="+autoplay.checked;
    }

    play(){
        console.log("starting play");
        document.getElementById("button_toggle").innerHTML = "pause";
        console.log("playing");
        console.log(document.getElementById("button_toggle").innerHTML);
        this.audioTarget.play()
    }

}