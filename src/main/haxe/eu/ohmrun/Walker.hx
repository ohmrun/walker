package eu.ohmrun;

class Walker{
  static public function log(wildcard:Wildcard):Log{
    return new stx.Log().tag("eu.ohmrun.walker");
  }
  static public function id(wildcard:Wildcard,name:String,?uuid:String):Id{
    return Id.make(name,__.option(uuid));
  }
  static public function root<T,G>():Node<T,G>{
    return new NodeCls(Id.make("root"),One,Call.debug("root"));
  }
  static public function one<T,G>(id:Id,?call:Call<T,G>,?rest:ChildrenSpec<T,G>):NodeSpec<T,G>{
    return {
      id    : id,
      type  : One,
      call  : __.option(call).defv(Call.debug(id)),
      rest  : __.option(rest).defv([])
    };
  }
  static public function all<T,G>(id:Id,?call:Call<T,G>,?rest:ChildrenSpec<T,G>):NodeSpec<T,G>{
    return {
      id    : id,
      type  : All,
      call  : __.option(call).defv(Call.debug(id)),
      rest  : __.option(rest).defv([])
    }
  }
}
typedef WalkerFailure                    = eu.ohmrun.walker.WalkerFailure;
typedef Spec                          = eu.ohmrun.walker.Spec;
typedef NodeSpec<T,G>                 = eu.ohmrun.walker.Spec.NodeSpec<T,G>;
typedef ChildrenSpec<T,G>             = eu.ohmrun.walker.Spec.ChildrenSpec<T,G>;

typedef IdDef                         = eu.ohmrun.walker.Id.IdDef;
typedef Id                            = eu.ohmrun.walker.Id;

typedef NodeCls<T,G>                  = eu.ohmrun.walker.Node.NodeCls<T,G>;
typedef Node<T,G>                     = eu.ohmrun.walker.Node<T,G>;

typedef TransitionData<T,G>           = eu.ohmrun.walker.TransitionData<T,G>;

typedef PhaseSum                      = eu.ohmrun.walker.Phase.PhaseSum;
typedef Phase                         = eu.ohmrun.walker.Phase;

typedef Machine<T,G>                  = eu.ohmrun.walker.Machine<T,G>;

typedef CallDef<T,G>                  = eu.ohmrun.walker.Call.CallDef<T,G>;
typedef Call<T,G>                     = eu.ohmrun.walker.Call<T,G>;

typedef Selector                      = eu.ohmrun.walker.Selector;
typedef Transition<T,G>               = eu.ohmrun.walker.Transition<T,G>;

enum Selectable{
  One;
  All;
}
abstract ArrayOfNode<T,G>(Array<Node<T,G>>) from Array<Node<T,G>> to Array<Node<T,G>>{}
class StateDeclaration{

}
typedef CallsDef = stx.ds.RedBlackMap<String,Selector>;

@:forward abstract Calls(CallsDef) from CallsDef to CallsDef{
  static public function unit(){
    return new Calls();
  }
  public function new(){
    this = RedBlackMap.make(
      Comparable.String()
    );
  }
}


class NodeDeclarationResolution{
  public function new(){}  
}