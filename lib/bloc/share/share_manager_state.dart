part of 'share_manager_cubit.dart';

abstract class ShareManagerState extends Equatable {
  const ShareManagerState();

  @override
  List<Object?> get props => [];
}

class ShareManagerInitial extends ShareManagerState {
  final String? msg;

  const ShareManagerInitial({this.msg});

  @override
  List<Object?> get props => [
        msg,
      ];
}
