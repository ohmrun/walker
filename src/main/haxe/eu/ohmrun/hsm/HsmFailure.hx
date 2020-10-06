package eu.ohmrun.hsm;

@:using(eu.ohmrun.hsm.HsmFailure.HsmFailureLift)
enum HsmFailure{
  E_Hsm_CannotFindName(path:Array<Id>,id:Id);
  E_Hsm_AreDifferentNodes;
}
class HsmFailureLift{
  static public function fold<Z>(self:HsmFailure,cannot_find_name:Array<Id> -> Id -> Z,are_different_nodes):Z{
    return switch(self){
      case E_Hsm_CannotFindName(path,id)  : cannot_find_name(path,id);
      case E_Hsm_AreDifferentNodes        : are_different_nodes();
    }
  }
  static public function toString(self:HsmFailure){
    return fold(
      self,
      (path:Path,id) -> 'cannot find $id in $path',
      () -> 'are different nodes'
    );
  }
}