package id.ninjasage.signals
{
   public interface ISignalOwner extends ISignal, IDispatcher
   {
       
      
      function removeAll() : void;
   }
}
