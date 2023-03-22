package eu.ohmrun.walker;

using Lambda;

using stx.Test;

import eu.ohmrun.walker.Spec;
import eu.ohmrun.Walker.*;
import eu.ohmrun.walker.test.*;

using eu.ohmrun.walker.Test;

class Test{
  static public function log(wildcard:Wildcard):Log{
    return new stx.Log().tag("eu.ohmrun.walker.test");
  }
  static public function main(){
    #if !macro
      __.unit([
        new HistoryTest()
      ],[]);
    #end
  }
}
class WalkerTest extends TestCase{
  public function test_one(){
    
  }
}
