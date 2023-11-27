import { Controller } from "@hotwired/stimulus"

import { get, post, put, patch, destroy } from '@rails/request.js'

// Connects to data-controller="voice-input"
export default class extends Controller {
  static targets = ["input", "startButton"];  

  connect() {
    console.log("VoiceInputController connected");
    this.speechRecognition = this.getSpeechRecognition();
    this.speaking = false;
    // let list = document.getElementById("post_voice_language");
    // list = list[list.selectedIndex].value;
    // console.log("list = ", list);
    // id="post_voice_language"
    //console.log(this.voiceLanguageTarget.selectedOptions[0].value);
    // let lang = "en-US";
    // console.log('lang = ', lang);
  }

  change(event) {
    //console.log("Hello");
    console.log(event.target.selectedOptions[0].value);
    let voice_language = event.target.selectedOptions[0].value;
    //let target = this.stateSelectTarget.id

    let post_id = window.location.pathname.replace('/posts/','').replace('/edit', '');
    console.log('post_id=', post_id);

    patch(`/posts/${post_id}/voice_languages?post_id=${post_id}&voice_language=${voice_language}`,{
      responseKind: "turbo-stream"
      //responseKind: "html"
    });

    // this.speechRecognition = this.getSpeechRecognition();
    // this.speechRecognition.continuous = true;

    // let list = document.getElementById("post_voice_language");
    // list = list[list.selectedIndex].value;
    // console.log("list = ", list);
    // speechRecognition.lang = list;
  }

  // Get the SpeechRecognition object
  getSpeechRecognition(){
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition){
      console.error("Speech recognition is not supported in this browser.");
      return null; 
    }

    const speechRecognition = new SpeechRecognition();
    this.setupSpeechRecognitionProperties(speechRecognition);
    this.setupSpeechRecognitionCallbacks(speechRecognition);
    return speechRecognition;
  };

  // Set up properties for the SpeechRecognition object
  setupSpeechRecognitionProperties(speechRecognition){
    speechRecognition.continuous = true;
    speechRecognition.interimResults = true;

    let list = document.getElementById("post_voice_language");
    list = list[list.selectedIndex].value;
    console.log("listt = ", list);
    speechRecognition.lang = list;
    //speechRecognition.lang = "en-US";
    //speechRecognition.lang = v_lang;

    //speechRecognition.lang = this.voiceLanguageTarget.selectedOptions[0].value;
    //console.log(this.voiceLanguageTarget.selectedOptions[0].value);
  };

  // Set up eventcallbacks for the SpeechRecognition object
  setupSpeechRecognitionCallbacks(speechRecognition){
    speechRecognition.onstart = () => console.log("Recording started ...");
    speechRecognition.onerror = (event) => this.handleSpeechRecognitionError(event);
    speechRecognition.onend = () => console.log("Recording stopped.");
    speechRecognition.onresult = (event) => this.handleSpeechRecognitionResult(event);
  };

  // Handle errors that occir during speech recognition
  handleSpeechRecognitionError(event){
    console.error("Speech recognition error:", event.error);
    this.stopRecording();
  }

  //Handle the speech recognition result
  handleSpeechRecognitionResult(event){
    console.log("fired");
    const { finalTranscript, interimTranscript } = this.extractTranscripts(event);
    this.updateInputValue(finalTranscript, interimTranscript);
  }


  //Extract the final & interimTranscripts from the speech recognition result 
  extractTranscripts(event){
    let final_transcript = "";
    let interim_transcript = "";

    for(let i = event.resultIndex; i < event.results.length; ++i) {
      if(event.results[i].isFinal){
        final_transcript += event.results[i][0].transcript;
      } else {
        interim_transcript += event.results[i][0].transcript;
      }
    }
    
    return {
      finalTranscript: final_transcript,
      interimTranscript: interim_transcript
    }    
  }

  // Update the input value with the final and interim transcripts
  updateInputValue(finalTranscript, interimTranscript) {
    const input = this.inputTarget;
    const selectionStart = input.selectionStart;
    const selectionEnd = input.selectionEnd;    

    const currentValue = input.value;
    const beforeSelection = currentValue.substring(0, selectionStart);
    const afterSelection = currentValue.substring(selectionEnd);

    const updatedValue = beforeSelection + finalTranscript + afterSelection;
    input.value = updatedValue;

    input.selectionStart = input.selectionEnd = selectionStart + finalTranscript.length;

    // Clear the interim transcript
    const updatedSelectionStart = selectionStart + finalTranscript.length;
    const updatedSelectionEnd = updatedSelectionStart + interimTranscript.length;
    input.setSelectionRange(updatedSelectionStart, updatedSelectionEnd);

  }

  //Handle the click on the start button
  record(event){
    // event.preventDefault();
    // event.stopPropagation();

    // get(`/posts/${post_id}/voice_languages?post_id=${post_id}&voice_language=${voice_language}`,{
    //   responseKind: "turbo-stream"
    // });

    if(!this.speechRecognition){
      console.error("Speech recognition is not available");
      return;
    }

     const startButton = this.startButtonTarget;
     if (this.speaking){
       this.stopRecording();
       startButton.textContent = "Start Voice Input";
     } else {
       this.startRecording();
       startButton.textContent = "Stop Voice Input";
     }
  }
     

  //Start recording
  startRecording(){
    this.speechRecognition.start();
    this.speaking = true;
    console.log("Recording...");
  }
  
  //Stop recording
  stopRecording(){
    this.speechRecognition.stop();
    this.speaking = false;
    console.log("Stopped recording.");
  }




}
