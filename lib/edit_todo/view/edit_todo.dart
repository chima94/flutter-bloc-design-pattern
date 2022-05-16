import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:todo/edit_todo/bloc/edit_todo_event.dart';
import 'package:todo/edit_todo/bloc/edit_todo_state.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';
import 'package:todo/widget/dialog/loading_screen.dart';
import 'package:todos_repository/todo_repository.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({Key? key}) : super(key: key);

  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
              create: (context) => EditTodoBloc(
                  todoRepository: context.read<TodoRepository>(),
                  initialTodo: initialTodo),
              child: const EditTodoPage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) => previous.status != current.status,
      //current.status != EditTodoStatus.success,
      listener: (context, state) {
        if (state.status == EditTodoStatus.success) {
          LoadingScreen.instance().hide();
          Navigator.of(context).pop();
        }

        if (state.status == EditTodoStatus.loading) {
          LoadingScreen.instance().show(context: context, text: 'loading');
        }
      },
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo =
        context.select((EditTodoBloc bloc) => bloc.state.isNewTodo);
    final theme = Theme.of(context);
    final fabBackgroundButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor =
        fabBackgroundButtonTheme.backgroundColor ?? theme.colorScheme.secondary;
    final themeData = context.select(
      (ThemeBloc bloc) => bloc.state.themeData,
    );
    final appbarColor = themeData == FlutterTodosTheme.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNewTodo ? 'Add Todo' : 'Edit Todo'),
        elevation: 0,
        backgroundColor: appbarColor,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'save',
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              _TitleField(),
              _DescriptionField(),
              _Schedule(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Title',
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Description',
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 5,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}

class _Schedule extends StatelessWidget {
  const _Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDate = DateTime.now();
    final startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
    final repeatList = <String>['None', 'Daily', 'weekly', 'monthly'];
    var _selectedRepeat = 'None';

    return Column(
      children: [
        _ScheduleInputField(
          title: 'Date',
          hint: DateFormat.yMd().format(selectedDate),
          widget: IconButton(
            onPressed: () {
              showDateFromUSer(context, (date) {
                final dateTime = DateFormat.yMd().format(date);
                print(dateTime);
              });
            },
            icon: const Icon(Icons.calendar_today_outlined),
          ),
        ),
        _ScheduleInputField(
          title: 'StartTime',
          hint: startTime,
          widget: IconButton(
            onPressed: () {
              getTimeFromUser(context, startTime, (time) {});
            },
            icon: const Icon(
              Icons.access_time_rounded,
            ),
          ),
        ),
        _ScheduleInputField(
            title: 'Repeat',
            hint: _selectedRepeat,
            widget: DropdownButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              iconSize: 32,
              elevation: 4,
              style: Theme.of(context).textTheme.bodyText1,
              underline: Container(
                height: 0,
              ),
              items: repeatList.map<DropdownMenuItem<String>>((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value!,
                      style: Theme.of(context).textTheme.bodyText1),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            )),
      ],
    );
  }

  Future<void> showDateFromUSer(
    BuildContext context,
    Function(DateTime) dateTime,
  ) async {
    final pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );
    if (pickerDate != null) {
      dateTime(pickerDate);
    }
  }

  Future<TimeOfDay?> _showTimePicker(
    BuildContext context,
    String startTime,
  ) {
    return showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(
          startTime.split(':')[1].split(' ')[0],
        ),
      ),
    );
  }

  Future<void> getTimeFromUser(
    BuildContext context,
    String startTime,
    Function(String) time,
  ) async {
    var pickTime = await _showTimePicker(context, startTime);
    if (pickTime != null) {
      final formatedTime = pickTime.format(context);
      time(formatedTime);
    }
  }
}

class _ScheduleInputField extends StatelessWidget {
  final String title;
  final String hint;
  final Widget? widget;

  const _ScheduleInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor: Theme.of(context).primaryColor,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).backgroundColor,
                        width: 0,
                      ),
                    ),
                  ),
                )),
                if (widget == null)
                  Container()
                else
                  Container(
                    child: widget,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
