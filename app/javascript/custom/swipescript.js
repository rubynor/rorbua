const btn_toggle_audio = document.querySelector('#button_toggle');
const btn_next = document.querySelector('#button_next');
const btn_prev = document.querySelector('#button_prev');

let playing = false;
const audio = document.createElement('audio');
let audio_index = 0;

var stories = document.querySelectorAll(".story_link");

load_track(audio_index);

function load_track(index){
  audio.src = stories[index].innerHTML;
  audio.load();
}

const swiper = new Swiper('.swiper', {
  // Optional parameters

  // If we need pagination
  pagination: {
  el: '.swiper-pagination',
  },
  
  loop: true

});

function next_slide() {
  swiper.slideNext();
}

function prev_slide() {
  swiper.slidePrev();
}

swiper.on('realIndexChange', slide);

function slide() {
  var current = swiper.activeIndex;
  var previous = swiper.previousIndex;
  if (current > previous) {
    next();
  }
  else {
    prev();
  }
}

function toggle_audio() {
  if (playing) {
    pause_audio();
  }
  else {
    play_audio();
  }
}

function play_audio() {
  playing = true;
  audio.play();
  btn_toggle_audio.innerHTML = '<span class="material-icons">pause</span>'
}

function pause_audio() {
  playing = false;
  audio.pause();
  btn_toggle_audio.innerHTML = '<span class="material-icons">play_arrow</span>';
}

function prev() {
  if(audio_index > 0){
    load_track(--audio_index);
  }
  else {
    audio_index = stories.length-1
    load_track(audio_index);
  }
  play_audio();
}

function next() {
  if( audio_index < stories.length - 1){
    load_track(++audio_index);
  }
  else{
    audio_index = 0;
    load_track(audio_index);
  }
  play_audio();
}

// Events
btn_toggle_audio.addEventListener("click", toggle_audio);
btn_next.addEventListener("click", next_slide);
btn_prev.addEventListener("click", prev_slide);