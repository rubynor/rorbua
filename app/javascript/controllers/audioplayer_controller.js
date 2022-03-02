import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "audio", "progressbar", "current_time", "total_time" ]

    connect(){
        var audio = this.audioTarget;
        var current_time = this.current_timeTarget;
        var total_time = this.total_timeTarget;
        var progressbar = this.progressbarTarget;

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

            // Når story blir spilt av kjøres denne for å oppdatere displayen av tid
            audio.onended = function (){
                document.getElementById("button_toggle").innerHTML = "play_arrow";
            }
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
            player.play()
            document.getElementById("button_toggle").innerHTML = "pause";
        }
        else {
            player.pause()
            document.getElementById("button_toggle").innerHTML = "play_arrow";
        }
    }



}