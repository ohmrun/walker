package eu.ohmrun.walker;

import stx.coroutine.core.Coroutine;

typedef WalkingDef<T,G,K,E> = CoroutineSum<Walker<T,G,K,E>,Walker<T,G,K,E>,Walker<T,G,K,E>,WalkerFailure>;

//@:using(e)
abstract Walking<T,G,K,E>(WalkingDef<T,G,K,E>) from WalkingDef<T,G,K,E> to WalkingDef<T,G,K,E>{
  public function new(self) this = self;
  static public function lift<T,G,K,E>(self:WalkingDef<T,G,K,E>):Walking<T,G,K,E> return new Walking(self);

  public function prj():WalkingDef<T,G,K,E> return this;
  private var self(get,never):Walking<T,G,K,E>;
  private function get_self():Walking<T,G,K,E> return lift(this);
}