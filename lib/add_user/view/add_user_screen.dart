import 'package:flutter/material.dart';
import 'package:flutter_task/add_user/cubit/add_user_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  // route
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AddUserScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User'), centerTitle: false),
      body: BlocProvider(
        create: (context) => AddUserCubit(context.read<NotesRepository>()),
        child: const AddUserView(),
      ),
    );
  }
}

class AddUserView extends StatefulWidget {
  const AddUserView({
    Key? key,
  }) : super(key: key);

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddUserCubit, AddUserState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          Fluttertoast.showToast(
              msg: 'User Added Successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pop();
        } else if (state.status == FormStatus.failure) {
          Fluttertoast.showToast(
              msg: state.error.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: BlocBuilder<AddUserCubit, AddUserState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // image picker
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      foregroundImage: state.imageAsBase64 == null
                          ? const AssetImage(
                              'assets/images/user_placeholder.jpeg')
                          : MemoryImage(state.imageAsBase64!) as ImageProvider,
                    ),
                  ),
                  // button to pick image
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image == null || !mounted) return;
                        context
                            .read<AddUserCubit>()
                            .imagePicked(await image.readAsBytes());
                      },
                      child: const Text('Select Image'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      context.read<AddUserCubit>().usernameChanged(val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      // password should have alphabet and numbers with minimum length of 8
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (!RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                          .hasMatch(value)) {
                        return 'Password should have alphabet and numbers with minimum length of 8';
                      }
                      return null;
                    },
                    obscureText: !isPasswordVisible,
                    onChanged: (val) {
                      context.read<AddUserCubit>().passwordChanged(val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                          .hasMatch(value)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      context.read<AddUserCubit>().emailChanged(val);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: state.interestId,
                    decoration: const InputDecoration(
                      labelText: 'Interest',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select interest';
                      }
                      return null;
                    },
                    items: context
                        .read<NotesRepository>()
                        .getAllInterests()
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.interestText ?? 'unknown'),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<AddUserCubit>().interestChanged(val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state.status == FormStatus.submitting
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              context.read<AddUserCubit>().insertUser();
                            }
                          },
                    child: state.status == FormStatus.submitting
                        ? const CircularProgressIndicator()
                        : const Text('SAVE'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
