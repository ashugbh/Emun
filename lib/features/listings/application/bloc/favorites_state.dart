import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  const FavoritesState({this.ids = const <String>{}});

  final Set<String> ids;

  FavoritesState copyWith({Set<String>? ids}) {
    return FavoritesState(ids: ids ?? this.ids);
  }

  @override
  List<Object?> get props => [ids];
}
