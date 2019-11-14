import 'dart:async';

import 'package:flutter/material.dart';

import 'pull_to_refresh.dart';
import 'stateful_widget.dart';

enum PaginatorTypes { CUSTOM_SCROLL_VIEW, LIST_VIEW }

typedef Future<bool> OnPageChange(int);

class Paginator extends AdharaStatefulWidget {
  final List<Widget> children;
  final OnPageChange onPageChange;
  final Function onPageLoaded;
  final PaginatorTypes listType;
  final IndexedWidgetBuilder itemBuilder;
  final bool reverse;
  final int itemCount;
  final bool endNavigationOnLastPage;
  final Widget loadingWidget;

  Paginator(
      {Key key,
      @required this.onPageChange,
      @required this.onPageLoaded,
      this.children,
      this.itemBuilder,
      this.listType: PaginatorTypes.CUSTOM_SCROLL_VIEW,
      this.itemCount,
      this.reverse: false,
      this.endNavigationOnLastPage: false,
      this.loadingWidget})
      : assert(children != null || itemBuilder != null),
        super(key: key);

  @override
  _PaginatorState createState() => new _PaginatorState();
}

class _PaginatorState extends AdharaState<Paginator> {
  String get tag => "Paginator";
  ScrollController _scrollController;
  bool isLoading = false;
  int page = 0;

  @override
  initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  get didHitBottom {
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  bool hasMore = true;

  onScroll() async {
    if (!isLoading && didHitBottom) {
      isLoading = true;
      setState(() {});
      if (widget.endNavigationOnLastPage && !hasMore) {
        return;
      }
//      _scrollController.position.setPixels(_scrollController.position.pixels+10.0); //Throwing exception - Need to check back
      hasMore = await widget.onPageChange(page + 1);
      if (hasMore) page++;
      await widget.onPageLoaded(page);
      isLoading = false;
      setState(() {});
    }
  }

  bool get isListView {
    return widget.listType == PaginatorTypes.LIST_VIEW;
  }

  Widget get indicator {
    if (isLoading) {
      return widget.loadingWidget ??
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 20.0,
                  height: 20.0,
                  padding: EdgeInsets.all(5.0),
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
                Text('${r.getString("loading")}')
              ],
            ),
            height: 30.0,
          );
    }
    return Container(
      height: 0.1,
    );
  }

  get children {
    List<Widget> _children = List<Widget>.from(widget.children);
    //adding the loading text...
    if (isListView)
      _children.add(indicator);
    else
      _children.add(SliverList(delegate: SliverChildListDelegate([indicator])));
    //return all elements including loading text
    return _children;
  }

  Widget get paginator {
    if (widget.itemBuilder != null) {
      return ListView.builder(
        reverse: widget.reverse,
        itemBuilder: widget.itemBuilder,
        itemCount: widget.itemCount,
        controller: _scrollController,
      );
    }
    if (isListView) {
      return ListView(
        controller: _scrollController,
        children: children,
      );
    }
    return CustomScrollView(
      controller: _scrollController,
      slivers: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
        processing: () async {
          page = 0;
          await widget.onPageChange(page);
        },
        postRefresh: () async {
          await widget.onPageLoaded(page);
        },
        child: paginator);
  }
}
