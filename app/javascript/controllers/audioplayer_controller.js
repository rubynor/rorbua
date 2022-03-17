import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "audio", "progressbar", "current_time", "total_time", "volume" ]

    connect(){
        var audio = this.audioTarget;
        var current_time = this.current_timeTarget;
        var total_time = this.total_timeTarget;
        var progressbar = this.progressbarTarget;
        var autoplay = document.getElementById("autoplay");
        var volume = this.volumeTarget;

        var self = this

        audio.addEventListener("loadedmetadata", function () {

            // Hvis info når data er lastet inn

            current_time.innerHTML = display_time(audio.currentTime);
            total_time.innerHTML = display_time(audio.duration);
            progressbar.value = this.currentTime/this.duration;
            audio.volume = volume.value / 100;
            // Spill av story når data er lastet inn
            self.play();


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

            // Endre volum og lagrer det som cookie, så når du går til en annen story så har du samme volum
            volume.addEventListener("change", function (e){
               audio.volume = e.currentTarget.value / 100;
               document.cookie = "volume="+audio.volume*100;
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

    // Toggle for å spille/pause storyen
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
    // Blir brukt av switchen i play.html.erb, så blir valget om autoplay eller ikke lagret som en cookie
    toggle_autoplay(){
        var autoplay = document.getElementById("autoplay");
        document.cookie = "autoplay="+autoplay.checked;
    }

    // Litt mer global play metode
    play(){
        document.getElementById("button_toggle").innerHTML = "pause";
        this.audioTarget.play()
    }

    disconnect() {
        this.audioTarget.pause()
    }

}