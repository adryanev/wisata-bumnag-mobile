import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Event transformer that will only emit items from the source sequence
/// whenever the time span defined by duration passes, without the source
/// sequence emitting another item.
// This time span start after the last debounced event was emitted.
// debounce filters out items obtained events that are rapidly followed by
// another emitted event.
EventTransformer<Event> debounce<Event>({required Duration duration}) =>
    (event, mapper) => event.debounceTime(duration).switchMap(mapper);

/// Only accept LATEST event after certain period of time.
EventTransformer<Event> debounceRestartable<Event>({
  required Duration duration,
}) =>
    (event, mapper) =>
        restartable<Event>().call(event.debounceTime(duration), mapper);

/// Emits an event, then ignores subsequent events for a duration,
/// then repeats this process.
///
/// If [leading] is true, then the first event in each window is emitted.
/// If [trailing] is true, then the last event is emitted instead.
EventTransformer<Event> throttle<Event>(
  Duration duration, {
  bool trailing = false,
  bool leading = true,
}) =>
    (events, mapper) => events
        .throttleTime(
          duration,
          trailing: trailing,
          leading: leading,
        )
        .switchMap(mapper);

///Skips the first [count] events.
EventTransformer<Event> skip<Event>(int count) =>
    (events, mapper) => events.skip(count).switchMap(mapper);

/// The delay() transformer is pausing adding events for a particular
/// increment of time (that you specify) before emitting each of the events.
/// This has the effect of shifting the entire sequence of events added
/// to the bloc forward in time by that specified increment.
EventTransformer<Event> delay<Event>(Duration duration) =>
    (events, mapper) => events.delay(duration).switchMap(mapper);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttleTime(duration), mapper);
  };
}
