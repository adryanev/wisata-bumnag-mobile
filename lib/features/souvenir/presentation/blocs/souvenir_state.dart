part of 'souvenir_bloc.dart';

abstract class SouvenirState extends Equatable {
  const SouvenirState();

  @override
  List<Object> get props => [];
}

class SouvenirInitial extends SouvenirState {}
