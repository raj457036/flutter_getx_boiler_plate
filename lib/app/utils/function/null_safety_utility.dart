T parseNullToObject<T>(T? object) {
  if (T is bool) return false as T;
  if (T is String) return "" as T;
  if (T is int) return 0 as T;
  if (T is double) return 0.0 as T;
  if (T is List) return List.empty() as T;
  if (T is Set) return Set.identity() as T;
  if (T is Map) return Map.identity() as T;
  return object as T;
}
