import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:todo/edit_todo/bloc/edit_todo_event.dart';
import 'package:todo/edit_todo/bloc/edit_todo_state.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isNewTodo ? 'Add Todo' : 'Edit Todo'),
        elevation: 0,
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
      body: CupertinoScrollbar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [_TitleField(), _DescriptionField()],
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
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}
