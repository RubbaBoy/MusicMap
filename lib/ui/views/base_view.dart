import 'package:flutter/material.dart';
import 'package:music_map/enums/view_states.dart';
import 'package:music_map/scoped_model/base_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/ui/widgets/busy_overlay.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final GlobalKey<ScaffoldState>? _scaffoldKey;
  final ScopedModelDescendantBuilder<T> _builder;
  final Function(BuildContext, T)? appBar;
  final Function(T)? onModelReady;
  final Function(T)? onModelEnd;

  const BaseView(
      {GlobalKey<ScaffoldState>? scaffoldKey,
      required ScopedModelDescendantBuilder<T> builder,
      this.appBar,
      this.onModelReady,
      this.onModelEnd})
      : _scaffoldKey = scaffoldKey,
        _builder = builder;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  final T _model = locator<T>();
  ScopedModelDescendantBuilder<T>? otherBuilder;

  @override
  void initState() {
    otherBuilder = (context, child, T model) => BusyOverlay(
          show: model.state == ViewState.Busy,
          child: Scaffold(
            key: widget._scaffoldKey,
            appBar: widget.appBar?.call(context, model),
            body: Builder(
              builder: (context) => SafeArea(
                child: widget._builder(context, child, model),
              ),
            ),
          ),
        );

    if (widget.onModelReady != null) {
      widget.onModelReady!(_model);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.onModelEnd != null) {
      widget.onModelEnd!(_model);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
        model: _model,
        child: ScopedModelDescendant<T>(
          builder: otherBuilder!,
        ));
  }
}
