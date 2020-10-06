package eu.ohmrun;

class Hsm{
  static public function log(wildcard:Wildcard):Log{
    return new stx.Log().tag("eu.ohmrun.hsm");
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
typedef HsmFailure                    = eu.ohmrun.hsm.HsmFailure;
typedef Spec                          = eu.ohmrun.hsm.Spec;
typedef NodeSpec<T,G>                 = eu.ohmrun.hsm.Spec.NodeSpec<T,G>;
typedef ChildrenSpec<T,G>             = eu.ohmrun.hsm.Spec.ChildrenSpec<T,G>;

typedef IdDef                         = eu.ohmrun.hsm.Id.IdDef;
typedef Id                            = eu.ohmrun.hsm.Id;

typedef NodeCls<T,G>                  = eu.ohmrun.hsm.Node.NodeCls<T,G>;
typedef Node<T,G>                     = eu.ohmrun.hsm.Node<T,G>;

typedef TransitionData<T,G>           = eu.ohmrun.hsm.TransitionData<T,G>;

typedef PhaseSum                      = eu.ohmrun.hsm.Phase.PhaseSum;
typedef Phase                         = eu.ohmrun.hsm.Phase;

typedef Machine<T,G>                  = eu.ohmrun.hsm.Machine<T,G>;

typedef CallApi<T,G>                  = eu.ohmrun.hsm.Call.CallApi<T,G>;
typedef CallDef<T,G>                  = eu.ohmrun.hsm.Call.CallDef<T,G>;
typedef Call<T,G>                     = eu.ohmrun.hsm.Call<T,G>;

typedef Selector                      = eu.ohmrun.hsm.Selector;
typedef Transition<T,G>               = eu.ohmrun.hsm.Transition<T,G>;

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