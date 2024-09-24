<!DOCTYPE html>
<html>
<head>
  <title>Factory Status</title>
  <script src="https://unpkg.com/vue@3.4.18/dist/vue.global.js"></script>
</head>
<body>
  <div id="app">
    <factory-status />
  </div>
  <script>
    const FactoryStatusComponent = {
      template: `<div>
        <h3>Control Panel</h3>
        <div> 
          <input type="checkbox" id="sheets-status" v-model="stations.sheets.isWorking" />
          <span id="sheets-station" :style="getBackgroundColor('sheets')">SHEETS</span>
        </div>
        <div> 
          <input type="checkbox" id="beams-status" v-model="stations.beams.isWorking" /> 
        <span id="beams-station" :style="getBackgroundColor('beams')">BEAMS</span>
        </div>
        <div> 
          <input type="checkbox" id="bolts-status" v-model="stations.bolts.isWorking" />
          <span id="bolts-station" :style="getBackgroundColor('bolts')">BOLTS</span>
        </div>
        <div> 
          <input type="checkbox" id="frames-status" v-model="stations.frames.isWorking" />
          <span id="frames-station" :style="getBackgroundColor('frames')">FRAMES</span>
        </div>
      </div>`,
      methods: {
        function getBackgroundColor(station){
          if(!isAvailable(station)){
            return 'background-color: red' 
          }
          return ''
        },
        function isAvailable(station){
          const stationObject = stations[station]
          if(!stationObject.isWorking){
            return false
          }
          const available = true
          stationObject.dependsOn.forEach((parent) => {
            if(!isAvailable(parent)){
              available = false
            }
          }))
          return available
        }
      } ,
      data: {
        stations: {
          sheets: { isWorking: true, dependsOn: []},
          beams: {isWorking: true, dependsOn: ['sheets']},
          bolts: {isWorking: true, dependsOn: []},
          frames: {isWorking: true, dependsOn: ['bolts', 'beams']},
        }
      }
    };

    const app = Vue.createApp({});
    app.component('factory-status', FactoryStatusComponent);
    app.mount('#app'); 
  </script>
</body>
</html>