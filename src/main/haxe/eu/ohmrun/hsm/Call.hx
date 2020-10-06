package eu.ohmrun.hsm;

typedef CallApi<T,G> = ArrowletApi<Context<T,G>,Res<G,HsmFailure>,Noise>;
typedef CallDef<T,G> = ArrowletDef<Context<T,G>,Res<G,HsmFailure>,Noise>;

@:using(stx.arw.Attempt.AttemptLift)
@:using(eu.ohmrun.hsm.Call.CallLift)
@:forward abstract Call<T,G>(CallDef<T,G>) from CallDef<T,G> to CallDef<T,G>{
  public function new(self:CallDef<T,G>) this = self;
  @:noUsing static public function lift<T,G>(self:CallDef<T,G>):Call<T,G>{
    return new Call(self);
  }
  @:noUsing static public function debug<T,G>(id:Id){
    return lift(
      Arrowlet.Sync(
        (context:Context<T,G>) -> {
          __.log()('id: $id@${context.phase}');
          return __.accept(context.global);
        }
      )
    );
  }
  @:noUsing static public function unit<T,G>(){
    return lift(Arrowlet.Sync((context:Context<T,G>) -> __.accept(context.global)));
  }
  @:to public function toArrowlet():Arrowlet<Context<T,G>,Res<G,HsmFailure>,Noise>{
    return Arrowlet.lift(this);
  }
  @:from static public function fromFContextVoid<T,G>(fn:Context<T,G>->Void){
    return lift(Arrowlet.Sync(__.passthrough(fn).fn().then(_ -> _.global).then(__.accept)));
  }
  @:to public function toAttempt():Attempt<Context<T,G>,G,HsmFailure>{
    return this;
  }
  public function symmetric():Attempt<Context<T,G>,Context<T,G>,HsmFailure>{
    return Attempt.lift(
      Attempt.lift(this).broach().process(
        Arrowlet.Sync(
          (couple:Couple<Context<T,G>,G>) -> Context.make(couple.fst().event,couple.snd())
        )
      )
    );
  }
  public function seq(that:Call<T,G>):Call<T,G>{
    return lift(symmetric().attempt(that));
  }
}
class CallLift{
  static public function environment<T,G>(self:Call<T,G>,ctx:Context<T,G>,success:G->Void,failure:Err<HsmFailure>->Void){
    return Arrowlet._.environment(
      self,
      ctx,
      (res:Res<G,HsmFailure>) -> {
        res.fold(success,failure);
      },
      __.crack
    );
  }
}