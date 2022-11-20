import 'package:music_map/enums/view_states.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {

  ViewState _state = ViewState.Ok;
  ViewState get state => _state;

  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}