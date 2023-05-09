package eu.ohmrun.walker.test;

#if js
import js.Browser.*;
import coconut.Ui.hxx;
import eu.ohmrun.walker.html5.History;

class HistoryTest extends TestCase{
  public function test(){
    if(document.getElementById('app') == null){
      __.log().info("mount");
      final document            = js.Browser.document;
      final el                  = document.createDivElement();
            el.setAttribute("id",'app');
            document.body.appendChild(el);
      final value               = hxx('<HistoryTestRootView history=${new History({state : Nada})}/>');
            coconut.ui.Renderer.mount(el,value);
    }   
  }
}
class HistoryTestRootView<T,G,K,E> extends coconut.ui.View{
  @:attribute var history : History<T,G,K,E>;
  public function render() '
    <Port history=${history}>
      <div ref=${history.intercept}>
        <HistoryTestSubView></HistoryTestSubView>
      </div>
    </Port>';
}
class HistoryTestSubView extends coconut.ui.View{
  @:state var string = "subview string";

  public function render() 
  '<Swap name="zero" 
          call=${
            () -> {
              string = "second subview string";
              return Future.sync(Nada);
            }
          }
    >
    <Rack name="one">     
      <HistoryTestSubSubView link="/two" />   
    </Rack>
    <Rack name="two">     
      <HistoryTestSubSubView link="/three" />   
    </Rack>
    <Swap call=${() -> Future.sync(Nada)}  name="three">   <HistoryTestSubSubView2/>  </Swap>  
  </Swap>
  ';
}
class HistoryTestSubSubView extends coconut.ui.View{
  @:optional @:attribute var link : String = "/";
  public function render() '<div><a href=${link}>${link}</a></div>';
}
class HistoryTestSubSubView2 extends coconut.ui.View{
  public function render() '
    <div>
      <Swap call=${() -> Future.sync(Nada)}  name="a">     
        <HistoryTestLeaf text="/three/b" link="/three/b"/>  
      </Swap>
      <Swap call=${() -> Future.sync(Nada)}  name="b">    
        <HistoryTestLeaf text="/three/c" link="/three/c" />  
      </Swap>
      <Swap                                   name="c">                      
        <HistoryTestLeaf text="/one" link="/one" />  
      </Swap>  
    </div>
  ';
}
class HistoryTestLeaf extends coconut.ui.View{
  @:attribute var text : String;
  @:attribute var link : String;
  public function render() '<a href=${link}>$text</a>';
}
#end