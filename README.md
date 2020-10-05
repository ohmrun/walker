# State Machine


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