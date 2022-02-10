import { Controller } from "@hotwired/stimulus"
import {Howl, Howler} from 'howler';

export default class extends Controller {
    connect() {
        var sound = new Howl({
            src: ["https://www.computerhope.com/jargon/m/example.mp3"]
        });
        sound.play()
    }
}