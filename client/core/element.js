var Element = function(attr) { 
  this.start = attr.start;
  this.end = attr.end;

  this.area = [];
  var isDone = false;

  var height = attr.end.y - attr.start.y;
  var width = attr.end.x - attr.start.x;

  this.size = width * height;

  for(var i = attr.start.y; i <= attr.end.y; i++) {
    for(var j = attr.start.x; j <= attr.end.x; j++) {
      if(!this.area[i]) {
        this.area[i] = [];
      }

      this.area[i][j] = null;
    }
  }

  this.touchCount = 0;

  this.touch = function(x, y, radius) {
    for(var i = y - radius; i <= y + radius; ++i) {
      var xx = 0;
      var halfReached = false;

      for(var j = x - radius; j <= x + radius; ++j) {
        if(typeof this.area[i] !== "undefined") {
          if(this.area[i][j] === null) {
            this.area[i][j] = true;
            this.touchCount++;
          }
        }
      }
    }
  }

  this.coverage = function() {
    return this.touchCount / this.size;
  }

  this.done = function(canvas) {
    if(!isDone) {
      isDone = true;

      var me = this;

      Session.set("score", Session.get("score") + 1000);

      var tick = new Tick(canvas, ".process");
      tick.show(me.start.y, me.start.x);
      
      //Meteor.call("finish_element", player(), score);
    }
  }

  this.isDone = function() {
    return isDone;
  }
}