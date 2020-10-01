package ohmrun.hsm;

using Lambda;

import ohmrun.hsm.Spec;

import ohmrun.Hsm.*;

import haxe.unit.TestCase;

class Test{
  static public function main(){
    __.test([
      new HsmTest()
    ]);
  }
}
class HsmTest extends TestCase{
  public function _test_build_tree_0(){
    var node  = Hsm.root();
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
  public function test_declare_node(){
    var node  = one('0_0_1',
      (phase) -> phase,
      []
    );
    var spec : NodeSpec<Dynamic> = all(
      "0",[
        one("0_0",
          [
            all("0_0_0", 
              (phase) -> phase,
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
                  [
                    all("0_0_1_1_0"),
                    all("0_0_1_1_1")
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
    trace(spec);
    var tree = spec.toTree();
    trace(tree);

    /*
    trace(tree.toString());
    var next = tree.path(["0_0","0_0_1"]);
    trace(next.value().map(x -> x.toString()));

    var next = tree.path(["0_0","0_0_0"]);
    trace(next.value().map(x -> x.toString()));
    */
    var p : Path   =  ["0_0","0_0_1","0_0_1_1","0_0_1_1_1"];
    //var path =  tree.path(p);
    
    var transition = Tree.divergence(tree,p);
    trace(transition);
    
    for(t in transition.value()){
      var bfo = t.from.bf().array().reversed();
      for(v in bfo){
        trace(v);
      }
      var bfi = t.into.bf();
      for(v in bfi){
        trace(v);
      }
    }
  }
} 