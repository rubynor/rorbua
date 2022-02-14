let btn_toggle_audio = document.querySelector('#button_toggle');
let btn_next = document.querySelector('#button_next');
let btn_prev = document.querySelector('#button_prev');

let playing = false;

let audio = document.createElement('audio')
let audio_index = 0;
let Stories = [
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"
]
load_track(audio_index);
console.log("js funker");
function load_track(index){
  audio.src = Stories[index];
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

function prev_btn() {
  prev_slide();
}
function next_btn() {
  next_slide();
}

function prev() {
  if(audio_index > 0){
    load_track(--audio_index);
  }
  else {
    audio_index = Stories.length-1
    load_track(audio_index);
  }
  play_audio();
}

function next() {
  if( audio_index < Stories.length - 1){
    load_track(++audio_index);
  }
  else{
    audio_index = 0;
    load_track(audio_index);
  }
  play_audio();
}
