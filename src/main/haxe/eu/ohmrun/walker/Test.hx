package eu.ohmrun.walker;

using Lambda;

using stx.unit.Test;

import eu.ohmrun.walker.Spec;
import eu.ohmrun.Walker.*;

using eu.ohmrun.walker.Test;

class Test{
  static public function log(wildcard:Wildcard):Log{
    return new stx.Log().tag("eu.ohmrun.walker.test");
  }
  static public function main(){
    __.unit([
      new WalkerTest()
    ],[]);
  }
}
class WalkerTest extends TestCase{
  public function test_one(){
    
  }
}
