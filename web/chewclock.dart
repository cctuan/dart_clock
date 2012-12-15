library chewclock;


import 'dart:html';
import 'dart:math';


const CLOCK_COLOR ="yellow";
const CLOCK_HOURTICK_COLOR ="red";
const CLOCK_MINTICK_COLOR ="blue";
const CLOCK_SECTICK_COLOR ="black";

const CLOCK_SIZE = 120.0;
const CLOCK_RADIUS = 40.0;

const CLOCK_HOUR_RADIUS = CLOCK_RADIUS*0.5;
const CLOCK_MINUTE_RADIUS = CLOCK_RADIUS*0.8;
const CLOCK_SECOND_RADIUS = CLOCK_RADIUS;

const TAU = PI * 2;

num centerX,centerY;

void main() {
  new ChewClock();
}

class ChewClock {

  int displayedHour = 0;
  int displayedMinute = 0;
  int displayedSecond = 0;
  var context;
  var frameState;
  
  ChewClock() {
    CanvasElement canvas = query("#chewclock");
    
    centerX = centerY = CLOCK_SIZE/2;
    
    context = canvas.context2d;
    
    context.translate(centerX, centerY);
    
    window.requestAnimationFrame(timetick);
  }
  void updateTime(Date now) {
    if (now.hour != displayedHour) {
      displayedHour = now.hour;
    }

    if (now.minute != displayedMinute) {
      displayedMinute = now.minute;
    }

    if (now.second != displayedSecond) {
      displayedSecond = now.second;
    }
  }
  
  void drawChewClock() {
    context.clearRect(-centerX, -centerY, CLOCK_SIZE, CLOCK_SIZE);
    
    context.beginPath();
    context.lineWidth = 2;
    context.strokeStyle = CLOCK_COLOR;
    context.arc(0, 0, CLOCK_RADIUS, 0, TAU,false);
    context.closePath();
    
    context.stroke();
  }
  void drawNum(){
    context.translate(-2,2);
    for(int i = 1;i<13;i++){
      context.strokeStyle = 'black';
      context.lineWidth = 1;
      num ang = hourTick(i);
      double x = (CLOCK_RADIUS+7)*sin(-ang);
      double y = (CLOCK_RADIUS+7)*cos(-ang);
      context.strokeText("${i}",x,y);      
    }
    context.translate(2,-2);
  }
  void timetick(num time){
    
    drawChewClock();
    drawNum();
    updateTime(new Date.now());
    drawTick(displayedHour,displayedMinute,displayedSecond);
    
    window.requestAnimationFrame(timetick);
  }
  void drawTick(num hour,num min,num sec){
    
    
    context.beginPath();
    context.lineWidth = 2;
    context.strokeStyle = CLOCK_COLOR;
    context.arc(0, 0, CLOCK_RADIUS, 0, TAU,false);
    context.closePath();
    context.stroke();
    
    
    double ang = convertHM(hour,min);
    num hourx = CLOCK_HOUR_RADIUS*sin(-ang);
    num houry = CLOCK_HOUR_RADIUS*cos(-ang);
   
    context.beginPath();
    context.moveTo(0,0);
    context.lineTo(-hourx, -houry);
    context.strokeStyle = CLOCK_HOURTICK_COLOR;
    context.closePath();
    context.stroke();
    
    
    num minx = CLOCK_MINUTE_RADIUS*sin(-min/60*2*PI);
    num miny = CLOCK_MINUTE_RADIUS*cos(-min/60*2*PI);
    
    context.beginPath();
    context.moveTo(0,0);
    context.lineTo(-minx, -miny);
    context.strokeStyle = CLOCK_MINTICK_COLOR;
    context.closePath();
    context.stroke();
    
    num secx = CLOCK_SECOND_RADIUS*sin(-sec/60*2*PI);
    num secy = CLOCK_SECOND_RADIUS*cos(-sec/60*2*PI);
    
    context.beginPath();
    context.moveTo(0,0);
    context.lineTo(-secx, -secy);
    context.strokeStyle = CLOCK_SECTICK_COLOR;
    context.closePath();
    context.stroke();

    
    
  }
  String pad2(int number) {
    if (number < 10) {
      return "0${number}";
    }
    return "${number}";
  }
}
double hourTick(int h){
  return (h/12)*2*PI + PI;
  
}
double convertHM(int h,int m){
  if(h>=12) {
    h = h-12;
  }
  return (h*60+m)/(12*60)*2*PI;
}

num minpercent(int min) {
  return min/60;
}