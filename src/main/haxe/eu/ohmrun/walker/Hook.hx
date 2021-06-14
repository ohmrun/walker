package eu.ohmrun.walker;

import tink.core.Signal;

class Hook{
  @:isVar private static var sink(get,null)  : SignalTrigger<Stamp<Block>>;
  private static function get_sink(){
    return __.option(sink).def(
      () -> sink = Signal.trigger()
    );
  }
  @:isVar public static var signal(get,null)  : Signal<Stamp<Block>>;
  private static function get_signal(){
    return __.option(signal).def(
      () -> signal = sink.asSignal()
    );
  }

  static public function raise(stamp:Stamp<Block>){
    sink.trigger(stamp);
  }
}