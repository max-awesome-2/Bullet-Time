/**
 This class represents a tween object.
 It is updated each frame in the main script, and lambda function can be attached if something is to occur on update and/or on completion.
 */

// remove when incorporating w / other scripts - references current time in seconds since start of game

class Tween implements Updateable {

  // length of the timer
  float totalLength;

  // time at which this timer is to trigger
  float triggerTime;

  // values to which 0 (timer start) and 1 (timer completion) are mapped and returned to the onUpdate lambda.
  float from = 0, to = 1;

  LambdaEmpty onComplete = null;
  LambdaFloat onUpdate = null;
  
  EaseStyle easeMode;

  /**
   Timer constructor. Needs totallength only. Goes from 0 to 1 and calls
   */
  public Tween(float len) {

    // set totalLength and triggerTime
    totalLength = len;
    reset();

    // add to list of updatables
    updateables.add(this);
  }
  
  /**
    Basic tween constructor - parameters for from value, to value, time
  */
  public Tween(float fromVal, float toVal, float t) {
   totalLength = t;
   from = fromVal;
   to = toVal;
   
   reset();
   
   // add to list of updatables
    updateables.add(this);
  }
  
  /**
   Stores a no-parameter lambda function to be called when the timer completes.
   Returns the tween itself for easy function chaining.
   */
  public Tween setOnComplete(LambdaEmpty l) {
    onComplete = l;

    return this;
  }

  /**
   Stores a no-parameter lambda function to be called when the timer completes.
   Returns the tween itself for easy function chaining.
   */
  public Tween setOnUpdate(LambdaFloat l) {
    onUpdate = l;

    return this;
  }

  /**
   Resets this timer using its stored totalLength value
   */
  public void reset() {
    triggerTime = time + totalLength;
  }

  /**
   Resets this timer, assigning a new totalLength value
   */
  public void reset(float newLength) {
    totalLength = newLength;
    reset();
  }

  /**
   Called every frame. 
   If this tween has an assigned onUpdate function, call it with the progress value mapped between assigned from & to values.
   If this tween is complete, calls the assigned onComplete function if it exists, and then removes this object from the main updateables list.
   */
  public void update() {
    // progress value of 0 to 1, where 0 is start of timer and 1 is completion of timer
    // constrain to 1 so that the update function is called with the full, final value just before completion
    // (so that it doesn't call a final time at like 0.9998571 or something)
    float progress = 1 - constrain((triggerTime - time) / totalLength, 0, 1);
    
    // apply easing function
    if (easeMode == EaseStyle.EaseOutElastic) {
     progress = easeOutElastic(progress); 
    }

    // if we have an onUpdate function, map progress value using given from / to values and call the onUpdate function with it
    if (onUpdate != null) {
      float mappedValue = map(progress, 0, 1, from, to);
      onUpdate.run(mappedValue);
    }
    
    // on timer complete
    if (time >= triggerTime) {
      
       // if we have an onComplete lambda, call it
       if (onComplete != null) onComplete.run();
       
       updateables.remove(this);
    }
  }
  
  public Tween setEaseMode(EaseStyle e) {
    
    easeMode = e;
    
    return this;
  }
}

enum EaseStyle {
 
  None, EaseOutElastic
  
}
