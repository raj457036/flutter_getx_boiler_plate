class RouteArguments {
  final Map<String, dynamic> _data;

  const RouteArguments([this._data = const {}]);

  get(String key, {dynamic defaultValue}) => _data[key] ?? defaultValue;

  Map<String, dynamic> get raw => {..._data};
}
