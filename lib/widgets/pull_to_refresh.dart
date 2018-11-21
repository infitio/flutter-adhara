import 'dart:async';

import 'package:flutter/material.dart';

import 'stateful_widget.dart';


class PullToRefresh extends AdharaStatefulWidget{

  final Widget child;
  final Function postRefresh;
  final Function processing;

  PullToRefresh({
    Key key,
    this.postRefresh,
    @required this.processing,
    @required this.child
  }): super(key: key);

  @override
  _PullToRefreshState createState() => new _PullToRefreshState();

}

class _PullToRefreshState extends AdharaState<PullToRefresh>{

  String get tag => "PullToRefresh";


  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() async {
//    AppDataInterface dataInterface = r.dataInterface;
    if(widget.processing!=null) {
      await widget.processing();
    }
//    await dataInterface.sync();
    if(widget.postRefresh!=null){
      widget.postRefresh();
    }
  }

  @override
  Widget build(BuildContext context){
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: widget.child,
    );
  }

}