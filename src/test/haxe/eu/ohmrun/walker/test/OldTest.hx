package eu.ohmrun.walker.test;

class OldTest extends TestCase{
  public function _test_build_tree_0(){
    var node  = Walker._.root();
    var tree  = new KaryTree();
    var zip   = tree.zipper();
    var tp    = zip.add_child(node);
        zip   =  tp.snd();

    var zero      = new NodeCls(Id.make("0"),One);
    var zero_one  = new NodeCls(Id.make("0_1"),All);
    var zero_all  = KaryTree.pure(zero).zipper().add_child(zero_one);

    var tpI       = zip.add_child_node(zero_all.snd().toTree());

    var one   = new NodeCls(Id.make("1"),All);
    var tpII  = tpI.add_child(one);

    

    var tree  = tpII.snd().toTree();
  }
  @:timeout(2000)
  public function _test_declare_node(async:Async){
    var node  = one('0_0_1',
      (phase) -> {},
      []
    );
    var spec : NodeSpec<Any,Any,Any> = all(
      "0",
      [
        one("0_0",
          (ctx:Context<Any,Any,Any>) -> {
            __.log()('${ctx.phase} "0_0"');
          },
          [
            all("0_0_0", 
              (ctx:Context<Any,Any,Any>) ->{
                __.log()('${ctx.phase} "0_0_0"');
              },
              [
                one("0_0_0_0",
                  [
                    all("0_0_0_0_0"),
                    all("0_0_0_0_1")
                  ]
                ),
                one("0_0_0_1",
                  [
                    all("0_0_0_1_0"),
                    all("0_0_0_1_1")
                  ]
                )
              ]
            ),
            all("0_0_1",
              [
                one("0_0_1_0",
                  [
                    all("0_0_1_0_0"),
                    all("0_0_1_0_1")
                  ]
                ),
                one("0_0_1_1",
                  Call.lift(
                    Fletcher.Sync(
                      (x) -> {
                        __.log()('called');
                        return x;
                      }
                    ).then(
                      Fletcher.Delay(200).then(
                        Fletcher.Sync(
                          (ctx:Context<Any,Any,Any>) -> {
                            __.log()("here");
                            return __.accept(ctx.global);
                          }
                        )
                      )
                    )
                  ),
                  [
                    all("0_0_1_1_0"),
                    all("0_0_1_1_1",
                      (ctx) -> {
                        __.log()("FINISHED");
                        async.done();
                      }
                    )
                  ]
                )
              ]
            )
          ]
        ),
        one("0_1",
          [
            all("0_1_0"),
            all("0_1_1")
          ]
        )
      ]
    );
    //__.log()(spec);
    var tree = spec.toTree();
    __.log().debug(_ -> _.pure(tree));

    /*
    __.log()(tree.toString());
    var next = tree.path(["0_0","0_0_1"]);
    __.log()(next.value().map(x -> x.toString()));

    var next = tree.path(["0_0","0_0_0"]);
    __.log()(next.value().map(x -> x.toString()));
    */
    var p : Path    =  ["0_0","0_0_1","0_0_1_1","0_0_1_1_1"];
    var machine     = new Machine(tree).on("test",p);
    var transition  = machine.call(p);
        machine.activator().reply().seq(transition).environment(
          Context.make(new Message({ b : true },"Hello"),{ a : 1}),
          (x) -> trace(x),
          __.crack
        ).submit();
    //var next = transition.value().fudge().next();
    //__.log()(next.tree); 
  }
  function test_simple_two(async:Async){
    var state = {
 
    }
    var spec = all("root",
     (ctx:Context<Dynamic,Dynamic,Dynamic>) -> {
       return ctx.global;
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
    trace(tree.toString());
    var machine0     = new Machine(tree);
    var init         = machine0.activator();

    //Upshot.value -> Option
    //Option.fudge -> Null<Transition>

    var transition0  = machine0.to(path0).value().fudge();//if it's a bad path, an error will be thrown on `fudge`
    
    var machine1     = transition0.next();//get the state of the Machine as it would be after transition0.
 
    //make sure you are using the right basis for a transition.
    //machine0.call(path1) is not the samee as machine1.call(path1)
    var transition1  = machine1.to(path1).value().fudge();
    
    // //compose the calls
    var sequence : Call<Dynamic,Dynamic,Dynamic> = init.reply().seq(transition0.reply()).seq(transition1.reply());
    // //provide the environment to the Fletcher to produce a Thread.
    var fiber = sequence.environment(
      Context.make(new Message({},"hello"),state),
      (x:Dynamic) -> {
        trace("done");
        async.done();
        //x is the G (Global) Type
      },
      __.crack
    );
    // //submit the fiber to the scheduler
    fiber.crunch();
   }
}