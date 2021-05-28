# State Machine

## Usage
```haxe
using ohmrun.Hsm;//import package;
import ohmrun.Hsm.*;//constructors root(), all() and one() pulled into the global scope.
 class Main{
  static function main(){
  var state = {
 
  }
  var spec = all("root",
    (ctx:Context<Dynamic,Dynamic>) -> {
      return ctx.global;//This is an Arrowlet, so has all Async powers
    },
    [
    one(
      "switch",[
        all("off"),//default state in switch
        one(
          "on",
          [
            all("working"),//default substate of "on"
            all("intermittent")
          ]
        )
      ]
    )
    ]
  );
  var path0 : Path = ["switch","on"];//defaults to ["switch","on","working"]
  var path1 : Path = ["switch","on","intermittent"];

  var tree         = spec.toTree();
  var machine0     = new Machine(tree);
  var init         = machine0.activator();//The Call that activates all default States.

  //Res.value -> Option
  //Option.fudge -> Null<Transition>

  var transition0  = machine0.to(path0).value().fudge();//if it's a bad path, an error will be thrown on `fudge`
  
  var machine1     = transition0.next();//get the state of the Machine as it would be after transition0.

  //make sure you are using the right basis for a transition.
  //machine0.call(path1) is not the samee as machine1.call(path1)
  var transition1  = machine1.to(path1).value().fudge();
  

  //compose the calls
  var sequence : Call<Dynamic,Dynamic> = init.reply().seq(transition0.reply()).seq(transition1.reply());
  //provide the environment to the Arrowlet to produce a Fiber.
  var thread = sequence.environment(
    Context.make("hello",state),
    (x:Dynamic) -> {
      async.done();
      //x is the G (Global) Type
    },
    __.crack
  );
  //submit the thread to the scheduler
  thread.submit();
  }
 }
  ```
### Development
  It look to me like event mapping is a seperate concern, and I'll be working on that next.
  Something like `activator().reply().seq(reactor)` where `reactor` is under cogitation

### Context
  The `Context` available to a `Call` contains two generic parameters.
  `T` is the type of the event triggered, to deliver a payload of data to each Node. It's not recommended to edit this on the light path, and the type of `Call` reflects this
  `G` is the program state we're working with. It's not strictly enforced as immutable, but if you need history or replecatability use something like Deep State so you can compare your before and after states, or store them: etc.
### Call
  `Call` is an `Attempt` (see stx.Arw) taking a `Context` and returning a `Res` of the global (`G`) state as it passes through the `Call`s on the `Node`s.
### Design
  The `Tree` at the center of this library is an immutable datastructure, and the Api encourages effect free programming. 
  Use the `Machine` to hypothesise states and Transitions without causing changes to the environment, and once your
  set of `Transition`s is correct, run your `Context` through, validate your resulting `Context.global` state before applying it 
  to the environment.  
### Selectable
  In a Hierarchical State Machine, you can specify how the machine chooses which path to light up.
  `All` indicates that all the children of a Node are lit up
  `One` indicates that one of the children of a Node is lit up.

  `All` allows you to compose Machines by simply appending one the children of an `All` `Node`
  `One` is where the switching happens for `Transition`s as the paths go dark or are lit.
### Activation Path
  The Default activation path lies on the first node of each `Branch`
### 