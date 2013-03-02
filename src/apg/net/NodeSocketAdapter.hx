package apg.net;

import js.Node;
import haxe.Serializer;
import haxe.Unserializer;
import apg.EventEmitter;

/**
 *  Wraps the node.js Socket object in the EventSocket interface. This makes the
 *  client and server code use the same socket interface.
 *  
 *  @author alexmiller@gmail.com
 **/
class NodeSocketAdapter extends EventEmitter, implements EventSocket {
  public var debug(default, default) : Bool;
  
  /**
   *  node.js socket
   **/
  var socket : NodeNetSocket;

  /**
   *  Create the socket adapter with the passed node.js socket.
   **/
  public function new(socket : NodeNetSocket) {
    super();
    this.socket = socket;
    this.debug = false;
    socket.on('data', onDataReceived);
    socket.on('close', onDisconnected);
  }
  
  public function connect(host, port) {
    socket.connect(port, host);
  }
  
  private function onDisconnected(data) {
    dispatch('disconnected');    
  }
  
  public function disconnect() {
    dispatch('disconnected');
    socket.destroy();
  }
  
  public function send(type : String, ?data : Dynamic = null) : Void {
    if (data == null) {
      data = {};
    }
    var m = Serializer.run({
      type: type,
      data: data
    });
    m = m.length + '|' + m;
    if (debug) {
      trace('sending: ' + m);
    }
    var ret : Bool = socket.write(m);
  }
  
  private function onDataReceived(data) {
    var message = Unserializer.run(data.toString('utf8'));
    if (debug) {
      trace('received: ' + message.type + ', ' + message.data);
    }
    dispatch(message.type, message.data);
  }
}