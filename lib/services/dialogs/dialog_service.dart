import 'dart:async';

class DialogService{
  Function _showDialogListener;
  Function _showPromoCodeListener;
  Function _showNotificationListener;
  Completer _dialogCompleter;

  void registerDialogListener(Function showDialogListener){
    _showDialogListener = showDialogListener;
  }

  void registerPromoCodeListener(Function showPromoCodeListener){
    _showPromoCodeListener = showPromoCodeListener;
  }
  void registerNotificationListener(Function showNotificationListener){
    _showNotificationListener = showNotificationListener;
  }

  Future showDialog(){
    _dialogCompleter = Completer();
    _showDialogListener();
    return _dialogCompleter.future;
  }

  Future showPromoDialog(){
    _dialogCompleter = Completer();
    _showPromoCodeListener();
    return _dialogCompleter.future;
  }

  Future showNotificationDialog(){
    _dialogCompleter = Completer();
    _showNotificationListener();
    return _dialogCompleter.future;
  }

  void dialogComplete(){
    _dialogCompleter.complete();
    _dialogCompleter = null;
  }
}