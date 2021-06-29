package eu.ohmrun.walker;

@:using(eu.ohmrun.walker.WalkerFailure.WalkerFailureLift)
enum WalkerFailure<E>{
  E_Walker_CannotFindName(path:Cluster<String>,selector:Selector);
  E_Walker_NoTriggerFor(name:String);
  E_Walker_AreDifferentNodes;
  E_Walker_Subsystem(e:E);
}
class WalkerFailureLift{
  // static public function fold<E,Z>(self:WalkerFailure<E>,cannot_find_name:Array<String> -> Selector -> Z,are_different_nodes):Z{
  //   return switch(self){
  //     case E_Walker_CannotFindName(path,id)  : cannot_find_name(path,id);
  //     case E_Walker_AreDifferentNodes        : are_different_nodes();
  //   }
  // }
  // static public function toString(self:WalkerFailure){
  //   return fold(
  //     self,
  //     (path:Array<String>,id) -> 'cannot find $id in $path',
  //     () -> 'are different nodes'
  //   );
  // }
}