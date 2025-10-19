import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:reading_app/features/profile/presentation/bloc/profile_event.dart';

class ProfileForm extends StatefulWidget {
  final UserProfile profile;

  const ProfileForm({super.key, required this.profile});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController _firstNameController;
  late TextEditingController _ageController;
  late TextEditingController _gradeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile.firstName ?? '',
    );
    _ageController = TextEditingController(
      text: widget.profile.age?.toString() ?? '',
    );
    _gradeController = TextEditingController(text: widget.profile.grade ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _ageController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Perfil',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Tu nombre',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value != null && value.trim().isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  if (value != null && value.length > 50) {
                    return 'El nombre no puede tener más de 50 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  hintText: 'Tu edad',
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return 'Edad inválida';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Grade
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(
                  labelText: 'Grado Escolar',
                  hintText: 'Ej: 3º Primaria, 1º ESO',
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      authState.when(
        authenticated: (user) {
          final updatedProfile = widget.profile.copyWith(
            firstName:
                _firstNameController.text.isNotEmpty
                    ? _firstNameController.text
                    : null,
            age:
                _ageController.text.isNotEmpty
                    ? int.tryParse(_ageController.text)
                    : null,
            grade:
                _gradeController.text.isNotEmpty ? _gradeController.text : null,
            updatedAt: DateTime.now(),
          );

          context.read<ProfileBloc>().add(
            ProfileEvent.updateProfile(updatedProfile),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
        initial: () {},
        loading: () {},
        unauthenticated: () {},
        error: (message) {},
      );
    }
  }
}
