// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'inbox_event.dart';
export 'inbox_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/messages/application/bloc/inbox_event.dart';
import 'package:emun/features/messages/application/bloc/inbox_state.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  InboxBloc(this._repository) : super(const InboxState()) {
    on<InboxLoadRequested>((event, emit) async {
      await load();
    });
  }

  final MessagesRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final conversations = await _repository.fetchConversations();
      emit(state.copyWith(isLoading: false, conversations: conversations));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
