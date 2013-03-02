package apg.net;

import haxe.Serializer;
import haxe.Unserializer;
import flash.events.Event;
import flash.events.SecurityErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.Socket;
import apg.EventEmitter;

/**
 *  Wraps the Flash Socket object in the EventSocket interface. This makes the
 *  client and server code use the same socket interface.
 *  
 *  @author alexmiller@gmail.com
 **/
class FlashSocketAdapter extends EventEmitter, implements EventSocket {
  public var debug(default, default) : Bool;
  
  /**
   *  The Flash socket
   **/
  private var socket : Socket;
  
  /**
   *  Constructs a new FlashSocketAdapter
   **/
  public function new() {
    super();
    this.debug = false;
    socket = new Socket();
    socket.timeout = 1000;
    socket.addEventListener(Event.CONNECT, function(event) {
      dispatch('connected');
    });
    socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
    
    // TODO: Better error handling?
    socket.addEventListener(IOErrorEvent.IO_ERROR, function(event) {
      trace('IO Error!');
      trace(event);
    });
    socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event) {
      trace('Security Error!');
      trace(event);
    });
  }
  
  /**
   *  Event listener for when data is received. 
   **/
  private function onDataReceived(event : ProgressEvent) {
    while(socket.bytesAvailable > 0) {
      processNextMessage();
    }
  }
  
  private function processNextMessage() {
    // first we must grab the length of the next message
    // we will do this by reading bytes from the socket until we reach a pipe
    // the message is formatted like this: <length>|<message>
    var messageLength = "";
    var byte = socket.readUTFBytes(1);
    var i = 0;
    while(byte != '|' && i < 10) {
      messageLength += byte;
      byte = socket.readUTFBytes(1);
      i++;
    }
    // now that we have the actual length of the payload, read it in
    var messageString = socket.readUTFBytes(Std.parseInt(messageLength));
    if (debug) {
      trace('received: ' + messageString);
    }
    // unserialize it into an object
    var message = Unserializer.run(messageString);
    // let listeners know there's a new message
    dispatch(message.type, message.data);
  }
  
  /**
   *  Connect to the passed host and port
   **/
  public function connect(host : String, port : Int) : Void {
    trace('Attempting to connect to ' + host + ':' + port);
    socket.connect(host, port);
  }
  
  /**
   *  Disconnect the socket. Dispatches the 'disconnected' event.
   **/
  public function disconnect() : Void {
    dispatch('disconnected');
    socket.close();
  }
  
  /**
   *  Send data through the socket of the passed type.
   **/
  public function send(type : String, ?data : Dynamic = null) : Void {
    if (data == null) {
      data = {};
    }
    var message = Serializer.run({
      type: type,
      data: data
    });
    socket.writeUTFBytes(message);
    socket.flush();
  }
}