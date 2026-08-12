package com.pnwrain.flashsocket
{
   import com.pnwrain.flashsocket.events.EventEmitter;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Engine extends EventEmitter
   {
       
      
      private var opts:Object;
      
      private var pingInterval:int;
      
      private var pingIntervalTimer:int;
      
      private var pingTimeout:int;
      
      private var pingTimeoutTimer:int;
      
      private var writeBuffer:Array;
      
      private var prevBufferLen:int = 0;
      
      public var upgrading:Boolean = false;
      
      public var readyState:String;
      
      public var transport:Transport;
      
      private var upgrades:Array;
      
      public function Engine(param1:Object)
      {
         this.writeBuffer = [];
         super();
         this.opts = param1;
         this.opts.transports = !!this.opts.transports ? this.opts.transports.concat() : ["polling","websocket"];
         this.opts.upgrade = this.opts.upgrade !== false;
         this.open();
      }
      
      private function open() : void
      {
         if(!this.opts.transports.length)
         {
            throw new Error("no transports");
         }
         this.readyState = "opening";
         var _loc1_:Transport = Transport.create(this.opts.transports[0],this.opts);
         _loc1_.open();
         this.setTransport(_loc1_);
      }
      
      private function setTransport(param1:Transport) : void
      {
         FlashSocket.log("setting transport " + param1.name);
         if(this.transport)
         {
            FlashSocket.log("clearing existing transport " + this.transport.name);
            this.transport.removeListener("drain",this.onDrain);
            this.transport.removeListener("packet",this.onPacket);
            this.transport.removeListener("error",this.onError);
            this.transport.removeListener("close",this.onClose);
         }
         this.transport = param1;
         this.transport.on("drain",this.onDrain);
         this.transport.on("packet",this.onPacket);
         this.transport.on("error",this.onError);
         this.transport.on("close",this.onClose);
      }
      
      private function probe(param1:String) : void
      {
         var newtransport:Transport = null;
         var failed:Boolean = false;
         var onTransportOpen:Function = null;
         var onerror:Function = null;
         var onTransportClose:Function = null;
         var onclose:Function = null;
         var onupgrade:Function = null;
         var name:String = param1;
         newtransport = null;
         failed = false;
         onTransportOpen = null;
         onerror = null;
         onTransportClose = null;
         onclose = null;
         onupgrade = null;
         onTransportOpen = function(param1:FlashSocketEvent):void
         {
            var e:FlashSocketEvent = param1;
            if(failed)
            {
               return;
            }
            FlashSocket.log("probe transport \"%s\" opened",name);
            newtransport.send([{
               "type":"ping",
               "data":"probe"
            }]);
            newtransport.once("packet",function(param1:FlashSocketEvent):void
            {
               var e:FlashSocketEvent = param1;
               var msg:Object = e.data;
               if(failed)
               {
                  return;
               }
               if("pong" == msg.type && "probe" == msg.data)
               {
                  FlashSocket.log("probe transport \"%s\" pong",name);
                  upgrading = true;
                  _emit("upgrading",newtransport);
                  if(!newtransport)
                  {
                     return;
                  }
                  FlashSocket.log("pausing current transport \"%s\"",transport.name);
                  transport.pause(function():void
                  {
                     if(failed)
                     {
                        return;
                     }
                     if("closed" == readyState)
                     {
                        return;
                     }
                     FlashSocket.log("changing transport and sending upgrade packet");
                     cleanup();
                     setTransport(newtransport);
                     newtransport.send([{"type":"upgrade"}]);
                     _emit("upgrade",newtransport);
                     newtransport = null;
                     upgrading = false;
                     flush();
                  });
               }
               else
               {
                  FlashSocket.log("probe transport failed",name);
                  _emit("upgradeError",{"transport":name});
               }
            });
         };
         var freezeTransport:Function = function():void
         {
            if(failed)
            {
               return;
            }
            failed = true;
            cleanup();
            newtransport.close();
            newtransport = null;
         };
         onerror = function(param1:*):void
         {
            freezeTransport();
            FlashSocket.log("probe transport failed because of error: ",name,param1);
            _emit("upgradeError",{
               "transport":name,
               "error":"probe error: " + param1
            });
         };
         onTransportClose = function():void
         {
            onerror("transport closed");
         };
         onclose = function():void
         {
            onerror("socket closed");
         };
         onupgrade = function(param1:FlashSocketEvent):void
         {
            var _loc2_:Transport = param1.data;
            if(newtransport && _loc2_.name != newtransport.name)
            {
               FlashSocket.log("\"%s\" works - aborting \"%s\"",_loc2_.name,newtransport.name);
               freezeTransport();
            }
         };
         var cleanup:Function = function():void
         {
            newtransport.removeListener("open",onTransportOpen);
            newtransport.removeListener("error",onerror);
            newtransport.removeListener("close",onTransportClose);
            removeListener("close",onclose);
            removeListener("upgrading",onupgrade);
         };
         FlashSocket.log("probing transport ",name);
         newtransport = Transport.create(name,this.opts);
         failed = false;
         newtransport.once("open",onTransportOpen);
         newtransport.once("error",onerror);
         newtransport.once("close",onTransportClose);
         once("close",onclose);
         once("upgrading",onupgrade);
         newtransport.open();
      }
      
      protected function onHandshake(param1:Object) : void
      {
         var hs:Object = param1;
         FlashSocket.log("handshake",hs);
         this.opts.sid = hs.sid;
         this.upgrades = hs.upgrades.filter(function(param1:*):*
         {
            return opts.transports.indexOf(param1) != -1;
         });
         this.pingTimeout = hs.pingTimeout;
         this.pingInterval = hs.pingInterval;
         this.onOpen();
         this.setPing();
      }
      
      private function onOpen() : void
      {
         var _loc1_:int = 0;
         this.readyState = "open";
         this.flush();
         if("open" == this.readyState && this.opts.upgrade && this.transport.pausable)
         {
            FlashSocket.log("starting upgrade probes",this.upgrades);
            _loc1_ = 0;
            while(_loc1_ < this.upgrades.length)
            {
               this.probe(this.upgrades[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      private function onHeartbeat(param1:int) : void
      {
         var timeout:int = param1;
         clearTimeout(this.pingTimeoutTimer);
         this.pingTimeoutTimer = setTimeout(function():void
         {
            if("closed" == readyState)
            {
               return;
            }
            FlashSocket.log("onHeartbeat closing",timeout);
            close();
         },timeout);
      }
      
      private function setPing() : void
      {
         clearTimeout(this.pingIntervalTimer);
         this.pingIntervalTimer = setTimeout(function():void
         {
            FlashSocket.log("writing ping packet - expecting pong within " + pingTimeout + " ms");
            sendPacket("ping");
            onHeartbeat(pingTimeout);
         },this.pingInterval);
      }
      
      public function sendPacket(param1:String, param2:* = null, param3:Object = null, param4:Boolean = true) : void
      {
         if("closing" == this.readyState || "closed" == this.readyState)
         {
            return;
         }
         param3 = param3 || {};
         param3.compress = false !== param3.compress;
         var _loc5_:Object = {
            "type":param1,
            "data":param2,
            "options":param3
         };
         this.writeBuffer.push(_loc5_);
         if(param4)
         {
            this.flush();
         }
      }
      
      public function flush() : void
      {
         if(!("closed" != this.readyState && this.transport.writable && !this.upgrading && this.writeBuffer.length))
         {
            return;
         }
         FlashSocket.log("flushing " + this.writeBuffer.length + " packets in socket",this.writeBuffer);
         this.transport.send(this.writeBuffer);
         this.prevBufferLen = this.writeBuffer.length;
      }
      
      protected function onPacket(param1:FlashSocketEvent) : void
      {
         if(this.readyState != "opening" && this.readyState != "open" && this.readyState != "closing")
         {
            FlashSocket.log("packet received with socket readyState " + this.readyState);
            return;
         }
         if(this.readyState == "open")
         {
            this.onHeartbeat(this.pingInterval + this.pingTimeout);
         }
         var _loc2_:Object = param1.data;
         if(_loc2_.type == "open")
         {
            this.onHandshake(JSON.parse(_loc2_.data));
         }
         else if(_loc2_.type == "pong")
         {
            FlashSocket.log("pong");
            this.setPing();
         }
         else if(_loc2_.type == "error")
         {
            this.onError({"data":FlashSocketEvent.IO_ERROR});
         }
         else if(_loc2_.type == "message")
         {
            _emit("data",_loc2_.data);
         }
      }
      
      private function onDrain(param1:FlashSocketEvent) : void
      {
         this.writeBuffer.splice(0,this.prevBufferLen);
         this.prevBufferLen = 0;
         if(this.writeBuffer.length)
         {
            this.flush();
         }
      }
      
      private function onClose(param1:Object) : void
      {
         if(!("opening" == this.readyState || "open" == this.readyState || "closing" == this.readyState))
         {
            return;
         }
         var _loc2_:String = param1.data;
         FlashSocket.log("socket close with reason: \"%s\"",_loc2_);
         clearTimeout(this.pingIntervalTimer);
         clearTimeout(this.pingTimeoutTimer);
         this.transport.removeListener("close",this.onClose);
         this.transport.close();
         this.transport.removeListener("drain",this.onDrain);
         this.transport.removeListener("packet",this.onPacket);
         this.transport.removeListener("error",this.onError);
         if("opening" == this.readyState && this.opts.transports.length > 1)
         {
            this.opts.transports.shift();
            this.open();
         }
         else
         {
            this.readyState = "closed";
            this.opts.sid = null;
            _emit("close",_loc2_);
            this.writeBuffer = [];
            this.prevBufferLen = 0;
         }
      }
      
      private function onError(param1:Object) : void
      {
         FlashSocket.log("transport error",param1.data);
         if(!("opening" == this.readyState && this.opts.transports.length > 1))
         {
            _emit("error",param1.data);
         }
         this.onClose({"data":"transport error: " + param1.data});
      }
      
      public function close() : void
      {
         var cleanupAndClose:Function = null;
         cleanupAndClose = null;
         var close:Function = function():void
         {
            FlashSocket.log("socket closing - telling transport to close");
            transport.close();
         };
         cleanupAndClose = function(param1:*):void
         {
            removeListener("upgrade",cleanupAndClose);
            removeListener("upgradeError",cleanupAndClose);
            close();
         };
         var waitForUpgrade:Function = function():void
         {
            once("upgrade",cleanupAndClose);
            once("upgradeError",cleanupAndClose);
         };
         if("opening" == this.readyState || "open" == this.readyState)
         {
            this.readyState = "closing";
            if(this.writeBuffer.length)
            {
               this.once("drain",function():void
               {
                  if(upgrading)
                  {
                     waitForUpgrade();
                  }
                  else
                  {
                     close();
                  }
               });
            }
            else if(this.upgrading)
            {
               waitForUpgrade();
            }
            else
            {
               close();
            }
         }
      }
   }
}
