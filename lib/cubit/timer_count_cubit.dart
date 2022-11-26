import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_count_state.dart';

class TimerCountCubit extends Cubit<TimerCountState> {
  TimerCountCubit() : super(TimerCountInitial());
}
